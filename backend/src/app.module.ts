import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { validate } from './common/config/env.validation';
import { LoggerMiddleware } from './common/middleware/logger.middleware';
import { CorrelationMiddleware } from './common/middleware/correlation.middleware';
import { AuthModule } from './modules/auth/auth.module';
import { PetsModule } from './modules/pets/pets.module';
import { StorageModule } from './modules/storage/storage.module';
import { InteractionsModule } from './modules/interactions/interactions.module';
import { RedisModule } from './modules/redis/redis.module';
import { BullModule } from '@nestjs/bullmq';
import { EventsModule } from './modules/events/events.module';
import { HealthModule } from './modules/health/health.module';

import { ThrottlerStorageRedisService } from '@nest-lab/throttler-storage-redis';

@Module({
  imports: [
    AuthModule,
    PetsModule,
    StorageModule,
    InteractionsModule,
    RedisModule,
    EventsModule,
    HealthModule,
    BullModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        connection: {
          host: configService.get('REDIS_HOST', 'localhost'),
          port: configService.get('REDIS_PORT', 6379),
        },
      }),
    }),
    // Distributed rate limiting across multiple instances.
    ThrottlerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        throttlers: [
          {
            name: 'default',
            ttl: 60000,
            limit: 60,
          },
          {
            name: 'auth',
            ttl: 60000,
            limit: 5, // Stricter for login/register
          },
          {
            name: 'upload',
            ttl: 3600000,
            limit: 10, // Max 10 uploads per hour
          },
        ],
        storage: new ThrottlerStorageRedisService({
          host: configService.get('REDIS_HOST', 'localhost'),
          port: configService.get('REDIS_PORT', 6379),
        }),
      }),
    }),
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: process.env.NODE_ENV === 'production'
        ? '.env.production'
        : '.env.development',
      validate,
    }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get<string>('DB_HOST'),
        port: configService.get<number>('DB_PORT'),
        username: configService.get<string>('DB_USER'),
        password: configService.get<string>('DB_PASSWORD'),
        database: configService.get<string>('DB_NAME'),
        autoLoadEntities: true,
        // 1️⃣ Disable synchronize in production
        synchronize: process.env.NODE_ENV !== 'production',
        // 2️⃣ Add logging in dev to see SQL queries easily
        logging: process.env.NODE_ENV !== 'production',
        // 3️⃣ Use SSL for cloud DB (e.g. AWS RDS, Supabase, Neon)
        ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
      }),
    }),
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(CorrelationMiddleware, LoggerMiddleware).forRoutes('*');
  }
}

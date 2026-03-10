import { plainToInstance } from 'class-transformer';
import { IsEnum, IsNumber, IsString, validateSync, IsOptional, IsUrl, IsNotEmpty } from 'class-validator';

enum Environment {
    Development = 'development',
    Production = 'production',
    Test = 'test',
}

class EnvironmentVariables {
    @IsEnum(Environment)
    @IsOptional()
    NODE_ENV: Environment = Environment.Development;

    @IsString()
    @IsNotEmpty()
    DB_HOST: string;

    @IsNumber()
    @IsOptional()
    DB_PORT: number = 5432;

    @IsString()
    @IsNotEmpty()
    DB_USER: string;

    @IsString()
    @IsNotEmpty()
    DB_PASSWORD: string;

    @IsString()
    @IsNotEmpty()
    DB_NAME: string;

    @IsString()
    @IsNotEmpty()
    JWT_SECRET: string;

    @IsString()
    @IsNotEmpty()
    JWT_REFRESH_SECRET: string;

    @IsString()
    @IsNotEmpty()
    R2_ACCOUNT_ID: string;

    @IsString()
    @IsNotEmpty()
    R2_ACCESS_KEY_ID: string;

    @IsString()
    @IsNotEmpty()
    R2_SECRET_ACCESS_KEY: string;

    @IsString()
    @IsNotEmpty()
    R2_BUCKET_NAME: string;

    @IsUrl()
    R2_PUBLIC_URL: string;

    @IsString()
    @IsOptional()
    REDIS_HOST: string = 'localhost';

    @IsNumber()
    @IsOptional()
    REDIS_PORT: number = 6379;
}

export function validate(config: Record<string, any>) {
    const validatedConfig = plainToInstance(
        EnvironmentVariables,
        config,
        { enableImplicitConversion: true },
    );
    const errors = validateSync(validatedConfig, { skipMissingProperties: false });

    if (errors.length > 0) {
        throw new Error(`Config validation error: ${errors.toString()}`);
    }
    return validatedConfig;
}

import { DataSource } from 'typeorm';
import { config } from 'dotenv';
import { join } from 'path';

config({ path: join(__dirname, '../../.env') });

// Connect to the PostgreSQL database.
export default new DataSource({
    type: 'postgres',
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT || '5432'),
    username: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    entities: [join(__dirname, 'modules/**/*.entity{.ts,.js}')],
    migrations: [join(__dirname, 'migrations/*{.ts,.js}')],
    /* 
     * ⚠️ STARTUP DATABASE BEHAVIOR:
     * 
     * synchronize: false -> (SAFE/PRODUCTION) Preserves data. Requires running migrations manually.
     * synchronize: true  -> (DEV ONLY) Auto-alters tables/columns to match your Entity classes on startup.
     *                       Warning: can cause data loss if you rename/delete entity properties!
     * dropSchema: true   -> (DANGER/TESTING) Completely wipes/drops the entire database on every startup.
     */
    synchronize: false,
    logging: true,
});

const { S3Client, PutBucketCorsCommand } = require('@aws-sdk/client-s3');
const fs = require('fs');
const path = require('path');

// Basic .env parser since we might not have dotenv standalone
// NestJS uses .env.development in this setup
const envPath = path.resolve(__dirname, '../../../.env.development');
const envConfig: Record<string, string> = {};

if (fs.existsSync(envPath)) {
    const envFile = fs.readFileSync(envPath, 'utf8');
    envFile.split('\n').forEach((line: string) => {
        const match = line.match(/^\s*([\w.-]+)\s*=\s*(.*)?\s*$/);
        if (match) {
            envConfig[match[1]] = match[2].trim().replace(/^['"]|['"]$/g, '');
        }
    });
} else {
    // Check if it's in the backend root directly if __dirname resolved differently
    const altEnvPath = path.resolve(process.cwd(), '.env.development');
    if (fs.existsSync(altEnvPath)) {
        const envFile = fs.readFileSync(altEnvPath, 'utf8');
        envFile.split('\n').forEach((line: string) => {
            const match = line.match(/^\s*([\w.-]+)\s*=\s*(.*)?\s*$/);
            if (match) {
                envConfig[match[1]] = match[2].trim().replace(/^['"]|['"]$/g, '');
            }
        });
    }
}

const accountId = envConfig['R2_ACCOUNT_ID'];
const accessKeyId = envConfig['R2_ACCESS_KEY_ID'];
const secretAccessKey = envConfig['R2_SECRET_ACCESS_KEY'];
const bucketName = envConfig['R2_BUCKET_NAME'];

if (!accountId || !accessKeyId || !secretAccessKey || !bucketName) {
    console.error('Missing required R2 credentials in .env');
    process.exit(1);
}

const s3Client = new S3Client({
    region: 'auto',
    endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
    credentials: {
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
    },
});

async function main() {
    try {
        console.log(`Setting CORS for bucket: ${bucketName}...`);
        
        await s3Client.send(
            new PutBucketCorsCommand({
                Bucket: bucketName,
                CORSConfiguration: {
                    CORSRules: [
                        {
                            AllowedHeaders: ['*'],
                            AllowedMethods: ['GET', 'PUT', 'POST', 'DELETE', 'HEAD'],
                            AllowedOrigins: ['*'], // Allow all origins (Flutter Web localhost)
                            ExposeHeaders: ['ETag'],
                            MaxAgeSeconds: 3000,
                        },
                    ],
                },
            })
        );
        
        console.log('✅ CORS successfully configured for R2 bucket.');
    } catch (error) {
        console.error('❌ Error configuring CORS:', error);
    }
}

main();

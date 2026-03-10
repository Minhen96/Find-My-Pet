import datasource from './src/datasource.config';

async function test() {
    try {
        console.log('Connecting to database...');
        await datasource.initialize();
        console.log('✅ Connection successful!');
        console.log('Entities found:', datasource.entityMetadatas.map(e => e.name));
        await datasource.destroy();
    } catch (error) {
        console.error('❌ Connection failed:');
        console.error(error);
        process.exit(1);
    }
}

test();

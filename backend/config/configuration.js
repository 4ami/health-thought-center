import dotenv from 'dotenv';
dotenv.config();

const DB = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    pwd: process.env.DB_PASS,
    database: process.env.DB_NAME, 
    port: process.env.DB_PORT,
    dialect: "mysql",
    timezone: '+00:00',
    sync: { force: false },
    define: { freezeTableName: true },
    pool: { max: 5, min: 0, acquire: 30000, idle: 10000 }
};

export default DB;
import express from 'express';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import authRoute from './router/auth.js';
import courseRouter from './router/course.js';
import trainerRouter from './router/trainer.js';
import errorHandler from './middleware/error.js';
import dotenv from 'dotenv';
import cors from 'cors';
dotenv.config();
const server = express()

server.use(cors());
server.use(bodyParser.json());
server.use(morgan('dev'));

server.use('/auth/v1', authRoute);

server.use('/courses/v1', courseRouter);

server.use('/trainer/v1' ,trainerRouter);


server.use(errorHandler);//Global error Handler
server.listen(3000,()=>{
    console.log("Server running");
});
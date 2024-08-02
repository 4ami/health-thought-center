import ValidateScheme from '../../helper/validation_scheme.js';
import connection from '../../model/db-index.js';
import HashHelper from '../../helper/hashing.js';
import authHelper from './auth_helper.js';
import jwt from 'jsonwebtoken';

import {v4} from 'uuid';
const {hash: hash , match: match} = HashHelper;
class AUTHController {
    static async register(req, res, next){
        try{
            const user = connection.user;
            const vQuery = await ValidateScheme.newAuth.validateAsync(req.body);
            
            const exist = await user.findOne({
                where:{
                    email: vQuery.email.toLowerCase(),
                }
            });
            
            console.log(exist);
            if(exist){
                let e = Error("Email is already registered");
                e.status = 404;
                throw e;
            }

            const hashed = hash(vQuery.password);
            
            const _id = v4();

            const create = await user.create({
                _id: _id,
                full_name: vQuery.full_name,
                password: hashed,
                email: vQuery.email.toLowerCase()
            });

            if(!create){
                let e = Error("Something goes wrong");
                e.status = 500;
                throw e;
            }

            res.send({
                full_name: vQuery.full_name,
                email: vQuery.email.toLowerCase(),
                role: "USER"
            }).status(201);
        }catch(e){
            console.log("[Auth-Controller / REGISTER]: " + e.message);
            next(e);
        }
    };

    static async login(req,res,next){
        try{
            const user = connection.user;
            const vQuery = await ValidateScheme.signIn.validateAsync(req.body);

            const data = await user.findOne({
                attributes: ['_id','password', 'role'],
                where: {
                    email: vQuery.email.toLowerCase(),
                }
            });

            if(!data){
                let e = Error('Email/Password incorrect');
                e.status = 404;
                throw e;
            }

            const hashMatch = match(vQuery.password, data['password']);

            if(!hashMatch){
                let e = Error("Email/Password incorrect");
                e.status = 404;
                throw e;
            }

            const token = authHelper.generateToken(data);
            const refreshToken = authHelper.generateRefreshToken(data);
            res.status(202).send({ token, refreshToken });
        }catch(e){
            console.log("[Auth-Controller / LOGIN]: " + e.message);
            next(e);
        }
    }

    static async refreshToken(req, res ,next){
        try{
            const vQuery = await ValidateScheme.refreshToken.validateAsync(req.body);
            const token = authHelper.verifyRefreshToken(vQuery.refreshToken);
            res.status(201).send({token});
        }catch(e){
            console.log("[Auth-Controller / REFRESH TOKEN]: " + e.message);
            next(e);
        }
    }
}

export default AUTHController;
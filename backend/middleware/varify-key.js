import dotenv from 'dotenv';
import {v4} from 'uuid';
import con from '../model/db-index.js';

dotenv.config();

async function authenticateAPI_KEY(req, res, next){
    try{
        const keys = con.api_keys;
        const isThereKeys = await keys.findAll({});
        if(isThereKeys == 0){
            await _AddKEY();
        }

        if(!req.headers['x-api-key']){
            let e = Error('Forbidden: No API key provided')
            e.status = 403;
            throw e;
        }

        const key = await keys.findOne({
            where:{
                _key: req.headers['x-api-key']
            }
        });

        if(!key){
            let e = Error('Forbidden: Invalid API key')
            e.status = 403;
            throw e;
        }
        next();
    }catch(e){
        console.log('[Key Authentication Error]: ' + e.message);
        if(e.status){
            res.status(e.status).send({
                message: e.message,
                code: e.status
            });
            return;
        }
        res.status(403).send({
            message: "You are forbidden",
            code: 403
        });
    }
}

async function _AddKEY(){
    try{
        const keys = con.api_keys;
        const _id = v4();
        const key = process.env.TRAINER_KEY;
        const isCreated = await keys.create({_id: _id, _key: key});
        
        if(!isCreated){
            let e = Error('Un Expected Error!');
            e.status = 500;
        }

    }catch(e){
        console.log('[Key Creation Error]: ' + e.message);
        throw e;
    }
}

export default authenticateAPI_KEY;
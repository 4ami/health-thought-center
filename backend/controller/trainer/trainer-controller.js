import {v4} from 'uuid';
import ValidationScheme from '../../helper/validation_scheme.js';
import connection from '../../model/db-index.js';

class TrainerController {
     static async getMyCourses(req, res, next) {
        try{
            console.log(req.params.id);
            const vID = await ValidationScheme.trainerID.validateAsync({id: req.params.id})
            .catch((er)=>{
                let e = Error('Invalid ID');
                e.status = 403;
                throw e;
            });

            const user = connection.user;

            const isTrainer = await user.findOne({
                attributes: ['role'],
                where: {
                    _id: vID.id
                }
            });

            //Wrong ID
            if(!isTrainer){
                let e = Error('Invalid Request ID');
                e.status = 403;
                throw e;
            }
            
            //Wrong Role
            if(isTrainer.dataValues.role != 'TRAINER'){
                let e = Error('Forbidden!');
                e.status = 403;
                throw e;
            }

            const tc = connection.trainer_course;
            const courseInfo = connection.course;

            //Get All trainer courses including their info
            const trainerCourses = await tc.findAll({
                where:{
                    _uid: vID.id
                },
                include: [
                    {
                        model: courseInfo,
                    }
                ]
            });
            
            res.status(200).send(trainerCourses);
       }catch(e){
            console.log('[Get Trainer Courses ERROR]: '+ e.message);
            next(e);
        }
     }

    static async newCourse(req,res,next){
        const transaction = await connection.sequelize.transaction();
        try{
            const vQuery = await ValidationScheme.newCourse.validateAsync(req.body);
            const vID = await ValidationScheme.trainerID.validateAsync({id: req.params.id });
            const _id = v4();
            const course = connection.course;

            const created = await course.create({
                _id: _id,
                ...vQuery,
            }, {trainsaction: transaction});

            if(!created) {
                let er = Error('Adding new course failed, try again later.');
                er.status = 500;
                transaction.rollback();
                throw er;
            }
            const trainer = connection.trainer_course;

            const assigned = await trainer.create({ _uid: vID.id, _cid: _id });


            if(!assigned){
                let er = Error('Adding new course failed, try again later.');
                er.status = 500;
                transaction.rollback();
                throw er;
            }
            transaction.commit();
            res.status(201).send({message: "Course added successfully.", code: 201});
        }catch(e){
            transaction.rollback();
            console.log('[Trainer New Courses ERROR]: '+ e.message);
            next(e);
        }
    }
}

export default TrainerController;
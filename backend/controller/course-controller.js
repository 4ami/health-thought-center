import ValidateScheme from '../helper/validation_scheme.js';
import connection from '../model/db-index.js';
import {v4} from 'uuid';
import {Op} from 'sequelize';

class Course {
     static async getAll(req, res, next) {
        try{
            const course = connection.course;

            const allCourses = await course.findAll({
                limit: 1000,
            });
            
            res.status(200).send({allCourses});
        }catch(e){
            console.log('[Course-Controller ERROR] GET ALL: ' + e.message);
            next(e);
        }
    }

    static async enroll(req, res, next){
        try{
            const enroll = connection.enrollment;
            const vQuery = await ValidateScheme.courseEnrollment.validateAsync(req.body);
            
            
            const isEnrolled = await enroll.findOne({
                where: {
                    [Op.and]: [
                        {_uid: vQuery._uid},
                        {_cid: vQuery._cid}
                    ]
                }
            });

            if(isEnrolled){
                let er = Error('You Already enrolled');
                er.status = 404;
                throw er;
            }

            const _id = v4();
            const newEnroll = await enroll.create({
                _id: _id,
                _uid: vQuery._uid,
                _cid: vQuery._cid,
            });

            if(vQuery.price > 0){
                res.status(201).send({
                    message: 'We will contact you through email to complete payment',
                    ...newEnroll.dataValues,
                });
            }

            res.status(201).send({
                message: 'Enrollment Success',
                ...newEnroll.dataValues
            });
        }catch(e){
            console.log('[Course-Controller ERROR] ENROLL: ' + e.message);
            next(e);
        }
    }

    static async search(req, res, next){
        try{
            const vQuery = await ValidateScheme.search.validateAsync(req.query);
            const course = connection.course;
            const courses = await course.findAll({
                where:{
                    [Op.or]: {
                        name: {[Op.like]: `%${vQuery.query}%`},
                        description: {[Op.like]: `%${vQuery.query}%`}
                    }
                }
            })
            res.status(200).send(courses);
        }catch(e){
            console.log('[Course-Controller ERROR] SEARCH: ' + e.message);
            next(e);
        }
    }
}

export default Course;
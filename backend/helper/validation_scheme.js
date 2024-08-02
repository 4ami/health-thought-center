import joi from 'joi';
class ValidateScheme {
    static newAuth = joi.object({
        full_name: joi.string().max(50).required(),
        email: joi.string().max(100).email().required(),
        password: joi.string().required(),
    });

    static signIn = joi.object({
        email: joi.string().max(100).email().required(),
        password: joi.string().required(),
    });

    static refreshToken = joi.object({ refreshToken: joi.string().required() });

    static courseEnrollment = joi.object({
        _uid: joi.string().required(), 
        _cid: joi.string().required(),
        price: joi.number().required(),
    });

    static trainerID = joi.object({id: joi.string().min(32).max(37).required()});

    static newCourse = joi.object({
        name: joi.string().max(37).required(),
        description: joi.string().optional().allow(""),
        duration: joi.number().required(),
        price: joi.number().precision(2).required().min(0),
        mode: joi.string().valid('RECORDED','LIVE').required(),
        due_date: joi.date().required(),
    });

    static search = joi.object({query: joi.string().optional().allow('')})
}


export default ValidateScheme;
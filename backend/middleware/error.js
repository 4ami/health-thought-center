function error(err,req, res, next){
    console.log(err);
    res.status(err.status || 500).send({
        "message": err.message,
        "code": err.status || 500,
    });
};

export default error;
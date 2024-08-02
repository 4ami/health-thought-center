import bcrypt from 'bcrypt';
function hash(pass){
    const salt = bcrypt.genSaltSync(10);
    return bcrypt.hashSync(pass, salt);
}


function match(pass, hash){
    return bcrypt.compareSync(pass, hash);
}

export default {hash, match};
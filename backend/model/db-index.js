import {Sequelize, DataTypes} from 'sequelize';
import db from '../config/configuration.js';
import USER from './user.js';
import COURSE from './course.js';
import ENROLLMENT from './enrollment.js';
import TRAINER_COURSE from './trainer-course.js';
import API_KEYS from './api-key.js';

const $equelize = new Sequelize(
    db.database,
    db.user,
    db.pwd,
    {
        host: db.host,
        dialect: db.dialect,
        operatorAliases: false,
        pool: {max: db.max, min: db.min, acquire: db.acquire, idle: db.idle},
        logging: false /// [stop developer logs]
    }
);

$equelize.authenticate().then(()=>console.log("Database Authenticated!")).catch((e)=> console.log("[DB-Authentication Error]: " + `${e}`));
const Database = {};
Database.Sequelize = Sequelize;
Database.sequelize = $equelize;

Database.user = USER($equelize, DataTypes);
Database.course = COURSE($equelize, DataTypes);
Database.enrollment = ENROLLMENT($equelize, DataTypes);
Database.trainer_course = TRAINER_COURSE($equelize, DataTypes);
Database.api_keys = API_KEYS($equelize, DataTypes);

// relations
Database.user.hasMany(Database.enrollment, { foreignKey: '_uid' });
Database.enrollment.belongsTo(Database.user, { foreignKey: '_id' });

Database.course.hasMany(Database.enrollment, { foreignKey: '_cid' });
Database.enrollment.belongsTo(Database.course, { foreignKey: '_id' });

Database.user.hasMany(Database.trainer_course, { foreignKey: '_uid' });
Database.trainer_course.belongsTo(Database.user, { foreignKey: '_uid' });

Database.course.hasMany(Database.trainer_course, { foreignKey: '_cid' });
Database.trainer_course.belongsTo(Database.course, { foreignKey: '_cid' });

export default Database;
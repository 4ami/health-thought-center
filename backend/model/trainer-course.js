function trainerCourse(sequelize, DataType) {
    return sequelize.define('TRAINER_COURSE',{
        _uid: { type: DataType.STRING(37), allowNull: false, primaryKey: true, references: {model: 'USER', key: '_id' } },
        _cid: { type: DataType.STRING(37), allowNull: false, primaryKey: true, references: { model: 'COURSE', key: '_id' } },
    },{ timestamps: false, freezeTableName: true, primaryKey: false });
}

export default trainerCourse;
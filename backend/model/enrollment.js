function Enrollment(sequelize, DataTypes){
    return sequelize.define('ENROLEMENT', {
        _id: { type: DataTypes.STRING(37), allowNull: false, primaryKey: true },
        _uid: { type: DataTypes.STRING(37), allowNull: false, references: { model: 'USER', key: '_id'}},
        _cid: { type: DataTypes.STRING(37), allowNull: false, references: { model: 'COURSE', key: '_id' }}
    },{ timestamps: false, freezeTableName: true });
}

export default Enrollment;
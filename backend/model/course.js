function Course(sequelize, DataTypes){
    return sequelize.define('COURSE', {
        _id: { type: DataTypes.STRING(37), allowNull: false, primaryKey: true },
        name: { type: DataTypes.STRING(50), allowNull: false },
        description: { type: DataTypes.TEXT, allowNull: true },
        duration: { type: DataTypes.INTEGER, allowNull: false },
        price: { type: DataTypes.DECIMAL(10,2), allowNull: false },
        mode: { type: DataTypes.ENUM('RECORDED', 'LIVE'), allowNull: false },
        due_date: { type: DataTypes.DATE }
    },{ timestamps: false, freezeTableName: true });
}

export default Course;
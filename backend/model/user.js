function USER(sequelize, DataTypes){
    return sequelize.define('USER',{
        _id: { type: DataTypes.STRING(37), allowNull: false, primaryKey: true },
        full_name: { type: DataTypes.STRING(50), allowNull: false },
        email: { type: DataTypes.STRING(100), allowNull: false, unique: true },
        password: { type: DataTypes.STRING(60), allowNull: false },
        role: { type: DataTypes.ENUM('USER', 'TRAINER'), allowNull: false, defaultValue: 'USER' },
    },{ timestamps: false, freezeTableName: true });
}

export default USER;
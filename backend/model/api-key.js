function API_KEY(sequelize, DataTypes){
    return sequelize.define('API_KEYS', {
        _id: { type: DataTypes.STRING(37), allowNull: false, primaryKey: true },
        _key: { type: DataTypes.STRING(64), allowNull: false },
    },{ timestamps: false, freezeTableName: true });
}

export default API_KEY;
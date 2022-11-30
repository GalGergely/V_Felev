'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Tickets extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      this.hasMany(models.Comments)
      this.belongsToMany(models.User, {
        through: "ticketUser",
      });
    }
  }
  Tickets.init({
    title: DataTypes.STRING,
    priority: DataTypes.INTEGER,
    done: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'Tickets',
  });
  return Tickets;
};
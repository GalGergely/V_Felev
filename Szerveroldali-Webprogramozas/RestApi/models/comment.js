'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Comment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
     this.belongsToMany(models.User);
     this.belongsToMany(models.Ticket);
    }
  }
  Comment.init({
    text: DataTypes.STRING,
    filename: DataTypes.STRING,
    UserId: DataTypes.INTEGER,
    TicketId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Comment',
  });
  return Comment;
};
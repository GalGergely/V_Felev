'use strict';

const {faker} = require('@faker-js/faker');
const models = require('../models');
const { User } = models;
const { Ticket } = models;

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    //User
    const userCount = faker.datatype.number({min:10, max:20});
    const users = [];
    for (let i = 0; i < userCount; i++) {
      users.push( await User.create({
        name: faker.name.fullName(),
        email: faker.internet.email(),
        password: 'password',
        is_admin: faker.datatype.boolean(),
      }));
    }
    //Tickets
    const ticketCount = faker.datatype.number({min:10, max:20});
    const tickets = [];
    for (let i = 0; i < ticketCount; i++) {
      tickets.push(await Ticket.create({
        text: faker.lorem.paragraph(),
        priority: faker.datatype.number({min:0, max:3}),
        done: faker.datatype.boolean(),
      }));
    }
  },

  async down (queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  }
};

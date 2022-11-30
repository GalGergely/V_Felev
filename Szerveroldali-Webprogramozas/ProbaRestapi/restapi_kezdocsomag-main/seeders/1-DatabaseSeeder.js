"use strict";

// Faker dokumentáció, API referencia: https://fakerjs.dev/guide/#node-js
const { faker } = require("@faker-js/faker");
const chalk = require("chalk");
const { kdf } = require("crypto-js");
const { Track, Playlist, User } = require("../models");

module.exports = {
    up: async (queryInterface, Sequelize) => {
        try {
            const tracks = [];
            const tracksCount = faker.datatype.number({
                min:20,
                max:30,
            });

            for (let i = 0; i < tracksCount; i++) {
                await Track.create({
                    title: faker.music.songName(),
                    length: faker.datatype.number({
                        min:60,
                        max:360,
                    }),
                    author: faker.name.fullName(),
                    genres: "nincskedvem",
                    album: faker.lorem.word(),
                    url: "szar.com",
                });

            }

            console.log(chalk.green("A DatabaseSeeder lefutott"));
        } catch (e) {
            // Ha a seederben valamilyen hiba van, akkor alapértelmezés szerint elég szegényesen írja
            // ki azokat a rendszer a seeder futtatásakor. Ezért ez Neked egy segítség, hogy láthasd a
            // hiba részletes kiírását.
            // Így ha valamit elrontasz a seederben, azt könnyebben tudod debug-olni.
            console.log(chalk.red("A DatabaseSeeder nem futott le teljesen, mivel az alábbi hiba történt:"));
            console.log(chalk.gray(e));
        }
    },

    // Erre alapvetően nincs szükséged, mivel a parancsok úgy vannak felépítve,
    // hogy tiszta adatbázist generálnak, vagyis a korábbi adatok enélkül is elvesznek
    down: async (queryInterface, Sequelize) => {},
};

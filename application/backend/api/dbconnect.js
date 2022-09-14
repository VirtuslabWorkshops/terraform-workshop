require('dotenv').config();

var dbConfig = {
    server: process.env.SERVER, 
    database: process.env.DATABASE,
    user: process.env.USER,
    password: process.env.PASSWORD,
    port: 1433,
    options: {
        encrypt: true
    }
};

module.exports = {
    dbConfig
  }
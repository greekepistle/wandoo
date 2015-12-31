var mysql = require('mysql');
var config = require('./config/config');

db = mysql.createConnection({
  host: config.dbHost,
  user: config.dbUser,
  password: config.dbPassword,
  database: config.db,
  timezone: 'Z'
});

// db.connect(function(err) {
//   if (err) {
//     console.error('Database Connection Error: ' + err.stack);
//     return;
//   }
//   console.log('Database successfully connected');
// });


module.exports = db;

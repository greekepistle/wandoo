var mysql = require('mysql');
var config = require('./config');

db = mysql.createConnection({
  user: config.dbUser,
  password: config.dbPassword,
  database: 'wandoo',
  timezone: 'Z'
});

db.connect(function(err) {
  if (err) {
    console.error('Database Connection Error: ' + err.stack);
    return;
  }
  console.log('Database successfully connected');
});


module.exports = db;

var mysql = require('mysql');
var config = require('./config/config');

var dbConfig = {
  host: config.dbHost,
  user: config.dbUser,
  password: config.dbPassword,
  database: config.db,
  timezone: 'Z'
}

var handleDisconnect = function (client) {
  client.on('error', function (err) {
    if (!err.fatal) {
      return;
    }
    if (err.code !== 'PROTOCOL_CONNECTION_LOST') {
      throw err;
    } 
    console.error('Reconnecting lost MySQL connection: ' + err.stack);
    db = mysql.createConnection(dbConfig);
    handleDisconnect(db);
  });
};

var db = mysql.createConnection(dbConfig);

handleDisconnect(db);

// db.connect(function(err) {
//   if (err) {
//     console.error('Database Connection Error: ' + err.stack);
//     return;
//   }
//   console.log('Database successfully connected');
// });

// db.on('error', function(err) {
//   console.log(err.code); // 'ER_BAD_DB_ERROR'
// });



module.exports = db;


// connection pool start

// var mysql = require('mysql');
// var pool  = mysql.createPool({
//   connectionLimit : 10,
//   host            : config.dbHost,
//   user            : config.dbUser,
//   password        : config.db
// });

// pool.query('SELECT 1 + 1 AS solution', function(err, rows, fields) {
//   if (err) throw err;

//   console.log('The solution is: ', rows[0].solution);
// });

// connection pool end

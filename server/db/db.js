var mysql = require('mysql');
var config = require('../config/config');

// db = mysql.createConnection({
//   host: config.dbHost,
//   user: config.dbUser,
//   password: config.dbPassword,
//   database: config.db,
//   timezone: 'Z'


var db  = mysql.createPool({
  connectionLimit : 10,
  host : config.dbHost,
  user : config.dbUser,
  password : config.dbPassword,
  database : config.db,
  timezone : 'Z'
});



// db.connect(function(err) {
//   if (err) {
//     console.error('Database Connection Error: ' + err.stack);
//     return;
//   }
//   console.log('Database successfully connected');
// });


module.exports = db;


// DISCONNECT HANDLER TEST

// var handleDisconnect = function (client) {
//   client.on('error', function (err) {
//     if (!err.fatal) {
//       return;
//     }
//     if (err.code !== 'PROTOCOL_CONNECTION_LOST') {
//       throw err;
//     } 
//     console.error('Reconnecting lost MySQL connection: ' + err.stack);
//     db = mysql.createConnection(dbConfig);
//     handleDisconnect(db);
//   });
// };

// handleDisconnect(db);

// END DISCONNECT HANDLER TEST

var mysql = require('mysql');
var config = require('./config/config');

// var dbConfig = {
//   host: config.dbHost,
//   user: config.dbUser,
//   password: config.dbPassword,
//   database: config.db,
//   timezone: 'Z'
// }

// var db = mysql.createConnection(dbConfig);

// connection pool start


var db = mysql.createPool({
  connectionLimit : 10,
  host : config.dbHost,
  user : config.dbUser,
  password : config.dbPassword,
  database: config.db,
  timezone: 'Z'
});



// connection pool end




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

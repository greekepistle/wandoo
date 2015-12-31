var db = require('./db');

module.exports = {
  queryBuilder : function (qs, data, callback) {
    db.getConnection(function (err, con) {
      if (err) {
        callback(err);
      } else {
        con.query(qs, data, function (err, result) {
          con.release();
          if (err) {
            callback(err);
          } else {
            callback(null, result);
          }
        });
      }
    });
  }
}


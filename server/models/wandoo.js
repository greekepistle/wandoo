var db = require('../db');
var queryBuilder = function (qs, data, callback) {
  db.query(qs, data, function (err, result) {
    if (err) {
      callback(err);
    } else {
      callback(null, result);
    }
  });
}

module.exports = {
  getAll : function (callback) {
    var qs = "select * from wandoo";
    queryBuilder(qs, [], callback);  
  },

  getPartialRes : function (params, callback) {
    var qs = "select * from wandoo where wandooID >= ? order by start_time desc limit ?"
    queryBuilder(qs, params, callback);
  },

  getByUserID : function (userID, callback) {
    var qs = "select * from wandoo where userID = ?;"
    queryBuilder(qs, userID, callback);
  },

  create : function (wandooData, callback) {
    var qs = 'INSERT INTO `wandoo` (`wandooID`,`userID`,`text`,`start_time`,\
    `end_time`,`post_time`,`latitude`,`longitude`,`num_people`) VALUES \
    (0,?,?,?,?,?,?,?,?);';
    queryBuilder(qs, wandooData, callback);
  },

  delete : function (wandooID, callback) {
    var qs1 = 'delete from wandoo_interest where wandooID = ?;' 
    var qs2 = 'delete from wandoo_tag where wandooID = ?;'
    var qs3 = 'delete from wandoo where wandooID = ?;'

    // Delete all rooms, room_user corresponding to Wandoo_id before deleting wandoos table
    // If you don't do this, the other operations (Wandoo_delete) will be unsucccessful

    db.query(qs1, wandooID, function (err, results1) {
      if (err) {
        callback(err);
      } else {
        db.query(qs1, wandooID, function (err, results2) {
          if (err) {
            callback(err);
          } else {
            db.query(qs3, wandooID, function (err, results3) {
              if (err) {
                callback(err);
              } else {
                callback(null, results1, results2, results3);
              }
            });
          }
        });
      }
    });
  }
}

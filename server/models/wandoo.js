var db = require('../db/db');
var room = require('../models/room');
var dbUtils = require('../db/dbUtils');

module.exports = {
  getAll : function (callback) {
    var qs = "select * from wandoo where status='A' order by start_time asc;";
    dbUtils.queryBuilder(qs, [], callback);  
  },

  getPartialRes : function (params, callback) {
    var qs = "select * from wandoo where status='A' order by start_time asc limit ?,?;";
    dbUtils.queryBuilder(qs, params, callback);
  },

  getByHost : function (userID, callback) {
    var qs = "select * from wandoo where userID = ?;"
    dbUtils.queryBuilder(qs, userID, callback);
  },

  getByUser : function (userID, callback) {
    var qs1 = 'select latitude, longitude from user where userID = ?;';
    var qs2 = "select * from wandoo where status ='A' order by start_time asc;"

    db.getConnection(function (err, con) {
      if (err) {
        con.release();
        callback(err);
      } else {
        db.query(qs1, userID, function (err, results1) {
          if (err) {
            con.release();
            callback(err);
          } else if (!results1.length) {
            con.release();
            callback('The specified userID does not exist');
          } else if (!results1[0].latitude || !results1[0].longitude) {
            con.release();
            callback('The user location is undefined');
          } else {
            var location = [results1[0].latitude, results1[0].longitude];
            db.query(qs2, [], function (err, results2) {
              con.release();
              if (err) {
                callback(err);
              } else {
                callback(err, results2, location);
              }
            });
          }
        });
      }
    });
  },

  create : function (wandooData, callback) {
    var qs = 'INSERT INTO `wandoo` (`wandooID`,`userID`,`text`,`start_time`,\
    `end_time`,`post_time`,`latitude`,`longitude`,`num_people`,`status`) VALUES \
    (0,?,?,?,?,?,?,?,?,"A");';
    dbUtils.queryBuilder(qs, wandooData, callback);
  },

  delete : function (wandooIDs, callback) {
    if (!wandooIDs.length) {
      callback(null, 'No entries were updated.');
    } else {
      var qs1 = "delete from wandoo_interest where wandooID in (?);" 
      var qs2 = "delete from wandoo_tag where wandooID in (?);"
      var qs3 = "delete from wandoo where wandooID in (?);"
      
      db.getConnection(function (err, con) {
        if (err) {
          callback(err);
        } else {
          db.query(qs1,[wandooIDs], function (err, results1) {
            if (err) {
              callback(err);
            } else {
              db.query(qs1,[wandooIDs], function (err, results2) {
                if (err) {
                  callback(err);
                } else {
                  room.deleteByWandoo(wandooIDs, function (err, results3) {
                    if (err) {
                      callback(err);
                    } else {
                      db.query(qs3,[wandooIDs], function (err, results4) {
                        if (err) {
                          callback(err);
                        } else {
                          callback(null, results1, results2, results3, results4);
                        }
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });

    }
  },

  getForDW : function (callback) {
    var qs = "select wandoo.*, 0 as room from wandoo where status='A' and \
    wandooID not in (select wandooID from room) union \
    select wandoo.*, 1 as room from wandoo where status='A' and \
    wandooID in (select wandooID from room) union \
    select wandoo.*, 0 as room from wandoo where status='E';"

    dbUtils.queryBuilder(qs, [], callback);
  },

  updateToPassive : function (wandooIDs, callback) {
    if (!wandooIDs.length) {
      callback(null, 'No entries were updated.');
    } else {
      var qs = "update wandoo set status = 'P' where wandooID in (?);"
      dbUtils.queryBuilder(qs, [wandooIDs], callback);
    }
  },

  updateToExpired : function (wandooIDs, callback) {
    if (!wandooIDs.length) {
      callback(null, 'No entries were updated.');
    } else {
      var qs = "update wandoo set status = 'E' where wandooID in (?);"
      dbUtils.queryBuilder(qs, [wandooIDs], callback);
    }
  }
}

var db = require('../db/db');
var util = require('../util');
var dbUtils = require('../db/dbUtils');



module.exports = {
  // used by worker:
  getAll : function (data, callback) {
    // the inner join assumes that a room will always have users
    var qs = "select room.*,userID from room inner join room_user on (room.roomID = room_user.roomID);"
    db.getConnection(function (err, con) {
      if (err) {
        callback(err);
      } else {
        db.query(qs, [], function (err, result) {
          if (err) {
            callback(err);
          } else {
            var cleanedResult = util.entriesToArray(result);
            callback(null, cleanedResult);
          }
        });
      }
    });
  },
  // DOESN'T LOOK LIKE THIS IS USED BY ANYTHING (would need to remove from controller if removing):
  getByRoom : function (roomID, callback) {
    var qs = "select * from room where roomID = ?;";
    dbUtils.queryBuilder(qs, roomID, callback);
  },
  
  getByUserID : function (userID, callback) {
    var qs = "select room.*,userID from room left join room_user on\
      (room.roomID = room_user.roomID) where room.roomID in \
      (select roomID from room_user where userID = ?);"
    db.getConnection(function (err, con) {
      if (err) {
        callback(err);
      } else {
        db.query(qs, userID, function (err, result) {
          if (err) {
            callback(err);
          } else {
            var cleanedResult = util.entriesToArray(result);
            callback(null, cleanedResult);
          }
        });
      }
    });
  },
  // DOESN'T LOOK LIKE THIS IS USED BY ANYTHING (would need to remove from controller if removing):
  getByWandooID : function (wandooID, callback) {
    var qs = "select * from room where wandooID = ?;";
    dbUtils.queryBuilder(qs, wandooID, callback);
  },

  create : function (roomData, roomUserData, callback) {

    var qs1 = "INSERT INTO `room` (`roomID`,`expiry_time`,`wandooID`, `conversationID`) VALUES\
      (0,?,?,?);";

    var qs2 = "INSERT INTO `room_user` (`roomID`,`userID`) VALUES\
      (?,?);"

    var numUsers = roomUserData.length;
    var userCount = 0;

    db.getConnection(function (err, con) {
      if (err) {
        callback(err);
      } else {
        db.query(qs1, roomData, function (err, result1) {
          if (err) {
            callback(err);
          } else {
            var roomID = result1.insertId;
            var insertUser = function (userIndex) {
              var insertParams = [roomID, roomUserData[userIndex]]
              db.query(qs2, insertParams, function (err, result2) {
                if (err) {
                  callback(err);
                } else {
                  if (userIndex < roomUserData.length - 1) {
                    insertUser(userIndex + 1);
                  } else {
                    callback(null, result1, result2);
                  }
                }
              });
            }
            insertUser(0);
          }
        });
      }
    });
  },

  delete : function (roomIDs, callback) {
    if (!roomIDs.length) {
      callback(null, 'No entries were updated.');
    } else {
      var qs1 = "delete from room_user where roomID in (?);"
      var qs2 = "delete from room where roomID in (?);"

      db.getConnection(function (err, con) {
        if (err) {
          callback(err);
        } else {
          db.query(qs1, [roomIDs], function (err, results1) {
            if ( err ) {
              callback(err);
            } else {
              db.query(qs2, [roomIDs], function (err, results2) {
                if ( err ) {
                  callback(err);
                } else {
                  callback(null, results1, results2);
                }
              });
            }
          });
        }
      });
    }
  

  },

  deleteByWandoo : function (wandooIDs, callback) {

    var qs1 = "delete from room_user where roomID in (select roomID from room where wandooID in (?));";
    var qs2 = "delete from room where wandooID in (?);";

    db.getConnection(function (err, con) {
      if (err) {
        callback(err);
      } else {
        db.query(qs1,[wandooIDs], function (err, results1) {
          if (err) {
            callback(err);
          } else {
            db.query(qs2,[wandooIDs], function (err, results2) {
              if (err) {
                callback(err);
              } else {
                callback(null, results1, results2);
              }
            });
          }
        });
      }
    });
    //in the future, we can add check on results to see if something has been deleted

  },

  addRoomUsers : function (roomID, roomUserData, callback) {
    var qs = "INSERT INTO `room_user` (`roomID`,`userID`) VALUES\
      (?,?);"
    db.getConnection(function (err, con) {
      if (err) {
        callback(err);
      } else {
        insertRoomUser(0);
      }
    });
    var insertRoomUser = function (roomUserIndex) {
      db.query(qs, [roomID, roomUserData[roomUserIndex]], function (err, result) {
        if (err) {
          callback(err);
        } else {
          if (roomUserIndex < roomUserData.length - 1) {
            insertRoomUser(roomUserIndex + 1);
          } else {
            callback(null, result);
          }
        }
      });
    }
  },

  getCountForWandoo : function (wandooID, callback) {
    var qs = "select count(*) as count from room where wandooID = ?;";
    dbUtils.queryBuilder(qs, wandooID, callback);
  },

  getWandooUsers : function (wandooID, callback) {
    var qs = "select distinct userID from room inner join room_user on \
      (room.roomID = room_user.roomID) where wandooID = ?;";
    dbUtils.queryBuilder(qs, wandooID, callback);
  }
}




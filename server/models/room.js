var db = require('../db');
var util = require('../util');
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
  getAll : function (data, callback) {
    var qs = "select room.*,userID from room left join room_user on (room.roomID = room_user.roomID);"
    db.query(qs, [], function (err, result) {
      if (err) {
        callback(err);
      } else {
        var cleanedResult = util.entriesToArray(result);
        callback(null, cleanedResult);
      }
    });
  },

  getByRoom : function (roomID, callback) {
    var qs = "select * from room where roomID = ?;";
    queryBuilder(qs, roomID, callback);
  },

  getByUserID : function (userID, callback) {
    var qs = "select * from room_user where userID = ?;";
    queryBuilder(qs, userID, callback);
  },

  getByWandooID : function (wandooID, callback) {
    var qs = "select * from room where wandooID = ?;";
    queryBuilder(qs, wandooID, callback);
  },

  create : function (roomData, roomUserData, callback) {

    var qs1 = "INSERT INTO `room` (`roomID`,`expiry_time`,`wandooID`) VALUES\
      (0,?,?);";

    var qs2 = "INSERT INTO `room_user` (`roomID`,`userID`) VALUES\
      (?,?);"

    var numUsers = roomUserData.length;
    var userCount = 0;

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
  },

  delete : function (roomIDs, callback) {
    if (!roomIDs.length) {
      callback(null, 'No entries were updated.');
    } else {
      var qs1 = "delete from room_user where roomID in (?);"
      var qs2 = "delete from room where roomID in (?);"

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
  

  },

  deleteByWandoo : function (wandooIDs, callback) {

    var qs1 = "delete from room_user where roomID in (select roomID from room where wandooID in (?));";
    var qs2 = "delete from room where wandooID in (?);";

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
    //in the future, we can add check on results to see if something has been deleted

  },

  addRoomUsers : function (roomID, roomUserData, callback) {
    var qs = "INSERT INTO `room_user` (`roomID`,`userID`) VALUES\
      (?,?);"
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
    insertRoomUser(0);
  }
}



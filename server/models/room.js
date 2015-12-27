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
    var qs = "select room.*,userID from room inner join room_user on (room.roomID = room_user.roomID);"
    queryBuilder(qs, [], callback);
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

  delete : function (roomID, callback) {
    // Delete all rooms, room_user corresponding to Wandoo_id
    //We need wandoo_id as a parameter instead of roomID

    // Delete all rooms, room_user corresponding to Wandoo_id
    // We need wandoo_id as a parameter instead of roomID

    var qs1 = "delete from room_user where roomID = ?;"
    var qs2 = "delete from room where roomID = ?;"

    db.query(qs1, roomID, function (err, results1) {
      if ( err ) {
        callback(err);
      } else {
        db.query(qs2, roomID, function (err, results2) {
          if ( err ) {
            callback(err);
          } else {
            callback(null, results1, results2);
          }
        });
      }
    });

  },

  deleteByWandoo : function (wandooIDs, callback) {
    // get all of the rooms associated with the wandooIDs
    // delete all of the rooms based on the roomID within room_user
    // delete all of the room based on the roomID within room

    // var qs = "select wandooID "
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



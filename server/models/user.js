var db = require('../db/db');
var _ = require('underscore');
var dbUtils = require('../db/dbUtils');

module.exports = {
  getByUserID : function (userID, callback) {
    var qs = "select user.*, institution_name from user left join \
    user_education on (user.userID = user_education.userID) where user.userID = ?;";
    dbUtils.queryBuilder(qs, userID, callback);
  },

  getByFBID : function (facebookID, callback) {
    var qs = "select user.*, institution_name from user left join \
    user_education on (user.userID = user_education.userID) where user.facebookID = ?;";
    dbUtils.queryBuilder(qs, facebookID, callback);
  },

  getObjIDs : function (userIDs, callback) {
    var qs = "select userID, objectID from user where userID in (?)";
    if (!userIDs.length) {
      callback(null, 'No userIDs were provided');
    } else {
      dbUtils.queryBuilder(qs, [userIDs], callback);
    }
  },
  
  post : function (userData, eduData, callback) {
    var qs1 = "INSERT INTO `user` (`userID`,`name`,`facebookID`,`email`,\
      `age`,`sex`,`profile_picture`,`employer`,`job_title`,`latitude`,`longitude`,`objectID`) \
      VALUES (0,?,?,?,?,?,?,?,?,?,?,?);";

    var qs2 = "INSERT INTO `user_education` \
      (`userID`,`institution_name`) VALUES (?,?);";

    db.getConnection(function (err, con) {
      if (err) {
        con.release();
        callback(err);
      } else {
        db.query(qs1, userData, function(err, results1) {
          if ( err ) {
            con.release();
            callback(err);
          } else {
            eduData.unshift(results1.insertId);
            db.query(qs2, eduData, function(err,results2) {
              con.release();
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


  },

  delete : function (userID, callback) {
    var qs1 = "delete from user_education where userID = ?;";
    var qs2 = "delete from user where userID = ?;";
    
    // need to also delete all wandoos associated with a user
      // though we can also wait for the wandoo to be cleaned up by the worker

    db.getConnection(function (err, con) {
      if (err) {
        callback(err);
      } else {
        db.query(qs1, userID, function (err, results1) {
          if ( err ) {
            callback(err);
          } else {
            db.query(qs2, userID, function (err, results2) {
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

  },

  put : function (locationData, callback) {
    var qs = "update user set latitude = ?, longitude = ? where userID = ?;";

    dbUtils.queryBuilder(qs, locationData, callback);

  }

}

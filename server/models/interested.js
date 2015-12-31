var db = require('../db/db');
var dbUtils = require('../db/dbUtils');

module.exports = {
  getByWandoo : function (wandooID, callback) {
    var qs = "select * from wandoo_interest where wandooID=?;";
    dbUtils.queryBuilder(qs, wandooID, callback);
  },

  getByUser : function (userID, callback) {
    var qs = 'select * from wandoo_interest where userID=?;';
    dbUtils.queryBuilder(qs, userID, callback);    
  },

  create : function (interestedData, callback) {
    var qs = "INSERT INTO `wandoo_interest` (`wandooID`,`userID`,`selected`,`rejected`) VALUES \
      (?,?,false,false);"
    dbUtils.queryBuilder(qs, interestedData, callback);
  },

  update : function (updateData, callback) {
    var qs = "update wandoo_interest set ? where wandooID=? and userID=?;"
    dbUtils.queryBuilder(qs, updateData, callback);
  
  }
}

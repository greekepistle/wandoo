var room = require('../models/room');
var util = require('../util');

var roomExpiry = 1;// number of days after end time when room will be expired

var postQueryCB = function (err, result, res) {
  if (err) {
    console.error(err);
    res.status('400').send('There was an error with insertion');
  } else {
    res.send();
  }  
}

var putQueryCB = function (err, result, res) {
  if (err) {
    console.error(err);
    res.status('400').send('There was an error with update');
  } else {
    res.send();
  }  
}

var getQueryCB = function (err, result, res) {
  if (err) {
    console.error(err);
    res.status('400').send('There was an error with selection');
  } else {
    res.json({data : result});
  }
}

var deleteQueryCB = function (err, result, res) {
  if (err) {
    console.error(err);
    res.status('400').send('There was an error in deletion');
  } else {
    res.send();
  }
}

module.exports = {
  get : function (req, res) {
    var roomMethod;
    var resourceID;
    if ((Object.keys(req.query).length + Object.keys(req.params).length) > 1) {
      res.send('Invalid parameters');
    } else if (req.query.userID) {
      resourceID = req.query.userID;
      roomMethod = room.getByUserID;
    } else if (req.query.wandooID) {
      resourceID = req.query.wandooID;
      roomMethod = room.getByWandooID;
    } else if (req.params.roomID) {
      resourceID = req.params.roomID;
      roomMethod = room.getByRoom;
    } else if (!Object.keys(req.params).length &&  !Object.keys(req.query).length) { // condition for when no params or query exist
      roomMethod = room.getAll;
    } else {
      res.send('Invalid parameters');
    }
    if (roomMethod) {
      roomMethod(resourceID, function (err, result) {
        getQueryCB(err, result, res);
      })
    }
  },

  post : function (req, res) {
    var expiryTime = new Date();
    expiryTime.setDate(expiryTime.getDate() + 1);
    util.isoDateToMySQL(expiryTime.toJSON());
    
    room.create([expiryTime, req.body.wandooID], req.body.userIDs, function(err, result) {
      postQueryCB(err, result, res);
    });

  },

  delete : function (req, res) {
    room.delete(req.params.roomID, function (err, result) {
      deleteQueryCB(err, result, res);
    });
  },

  put : function (req, res) {
    room.addRoomUsers(room.params.roomID, room.body.userIDs, function(err, result) {
      putQueryCB(err, result, res);
    });
    
  } 
}

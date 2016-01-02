var interested = require('../models/interested');
var room = require('../controllers/room');
var _ = require('underscore');

module.exports = {
  get : function (req, res) {
    var wandooID = req.query.wandooID ? req.query.wandooID : undefined;
    var userID = req.query.userID ? req.query.userID : undefined;

    if (wandooID && userID) {
      res.status('400').send('Must specify either wandooID or userID, but not both'); //what error should I send here?
      return; // do I need this return?
    } else if (wandooID) {
      interested.getByWandoo(wandooID, function (err, result) {
        if (err) {
          console.error(err);
          res.status('400').send('There was an error in retrieval');
        } else {
          res.json(result);
        }
      });

      // check for query parameters which are not defined in spec?

    } else if (userID) {
      interested.getByUser(userID, function (err, result) {
        if (err) {
          console.error(err);
          res.status('400').send('There was an error in retrieval');
        } else {
          res.json(result);
        }
      })
    } else {
      res.status('400').send('Passed invalid query parameters');
    }
  },

  post : function (req, res) {
  
    interested.create([req.body.wandooID, req.body.userID], function (err, result) {
      if (err) {
        console.error(err);
        res.status('400').send('There was an error in insertion');
      } else {
        res.send();
      }
    });

  },

  put : function (req, res) {

    var interestedData = [req.params.wandooID, req.params.userID];

    if (req.body.selected && req.body.rejected) { // this error check isn't working
      res.status('400').send('Must specify selected or rejected but not both');
    } else if (_.reduce(req.body, function (memo, val, key) {
      if (key !== 'selected' || key !== 'rejected') {
        return false;
      } else {
        return true;
      }
    }, true)) { // check if anything other than selected or rejected
      res.status('400').send('Passed invalid parameters');
    } else {

      room.insertRoomAndConversation(req.params.wandooID, [req.body.hostID,
        req.params.userID], function (err) {
        if (err) {
          res.status('400').send('Error in inserting room and conversation');
        } else {
          delete req.body.hostID;
          interestedData.unshift(req.body);
          interested.update(interestedData, function (err, result) {
            if (err) {
              console.error(err);
              res.status('400').send('There was an error in retrieval');
            } else {
              res.send();
            }
          });
        }

      });
      
    }

    // check if not 0 or 1?


  }

}

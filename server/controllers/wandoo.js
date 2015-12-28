var wandoo = require('../models/wandoo.js');
var util = require('../util');

var getQueryCB = function (err, result, res) {
    if (err) {
      console.error(err);
      res.status('400').send('There was an error with selection');
    } else {
      res.json({data : result});
    }
}

module.exports = {
  get : function (req, res) {
    if (req.query.offset && req.query.limit && !req.query.hostID && !req.query.userID) {
      wandoo.getPartialRes([+req.query.offset, +req.query.limit], function (err, result) {
        getQueryCB(err, result, res); // need to wrap this function so that I can pass res to my callback
      });
    } else if (!req.query.offset && !req.query.limit && req.query.hostID && !req.query.userID) {
      wandoo.getByHost(+req.query.hostID, function (err, result) {
        getQueryCB(err, result, res);
      });
    } else if (!req.query.offset && !req.query.limit && !req.query.hostID && req.query.userID) {
      wandoo.getByUser(+req.query.userID, function (err, result) {
        // WHAT TO DO
      });
    } else if (!Object.keys(req.query).length) {
      wandoo.getAll(function (err, result) {
        getQueryCB(err, result, res);
      });
    } else {
      res.status('400').send('Wrong parameters');
    } // can account for other edge cases later if necessary
  },

  post : function (req, res) {
    var wandooAttr = {
      userID : 0,
      text : 1,
      startTime : 2,
      endTime : 3,
      postTime : 4,
      latitude : 5, 
      longitude : 6,
      numPeople : 7
    };

    var wandooValues = [];
    
    for ( var i in req.body ) {
      if ( i in wandooAttr ) {
  
        if (/.*?Time/.exec(i)) {
          wandooValues[wandooAttr[i]] = util.isoDateToMySQL(req.body[i]);
        } else {
          wandooValues[wandooAttr[i]] = req.body[i];
        }

      } else {
        res.status('400').send('Wrong parameters');
        return;
      }
    }

    wandoo.create(wandooValues, function (err, result) {
      if (err) {
        console.error(err);
        res.status('400').send('There was an error with insertion');
      } else {
        res.send();
      }
    });
    
  },

  delete : function (req,res) {
    wandoo.delete(req.params.wandooID, function (err, result) {
      if ( err ) {
        console.error(err);
        res.status('400').send('Error with deletion');
      } else {
        res.send();
      }
    });

  }
}

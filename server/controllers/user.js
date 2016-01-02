var user = require('../models/user');
var _ = require('underscore');
var util = require('../util');
var s3 = require('../util/s3');

module.exports = {
  get : function (req, res) {

    if (req.params.userID) {
      user.getByUserID(req.params.userID, function (err, result) {
        if ( err ) {
          console.error(err);
          res.status('400').send('There was an error');
        } else {
          res.json({ data : result }); 
        }
      });
    } else if (req.query.facebookID) { // need to account for case when other params aside frmo facebookID are passed
      user.getByFBID(req.query.facebookID, function (err, result) {
        if (err) {
          console.error(err);
          res.status('400').send('Error in retrieval');
        } else {
          res.json({ data : result });
        } 
      });
    } else {
        res.status('400').send('Wrong parameters');
    }
  },

  post: function (req, res) {
    var userAttr = {
      name : 0,
      facebookID : 1,
      email : 2,
      age : 3,
      sex : 4,
      profilePic : 5,
      employer : 6,
      jobTitle : 7,
      latitude : 8,
      longitude : 9,
      objectID: 10
    };

    var eduAttr = {
      educationInstitution : 0
    };

    var userValues = [],
      eduValues = [];

    for ( var i in req.body ) {
      if ( i in userAttr ) {
        if ( i === 'profilePic' ) {
          // userValues[userAttr[i]] = '/images/' + req.body['facebookID'] + '.png';
          // util.writeImage(userValues[userAttr[i]], req.body['profilePic']);
          userValues[userAttr[i]] = s3.fileURL(req.body.facebookID);
          s3.uploadFileToS3(req.body.facebookID, req.body.profilePic);
        } else {
          userValues[userAttr[i]] = req.body[i];
        }
      } else if ( i in eduAttr ) {
        eduValues[eduAttr[i]] = req.body[i];
      } else {
        res.status('400').send('Wrong parameters');
        return;
      }
    }

    user.post(userValues, eduValues, function (err, result) {
      if ( err ) {
        console.error(err);
        res.status('400').send('There was an error with insertion');
      } else {
        res.send();
      }
    });
  },

  delete : function (req, res) {
    user.delete(req.params.userID, function (err, result1, result2) {
      if ( err ) {
        console.error(err);
        res.status('400').send('Error with deletion');
      } else {
        res.send();// what if there was no user that had the userID specified?
        // we can use result.affectedRows=0 to check if there was a deletion
      }
    });
  },

  put : function (req, res) {

    var locAttr = {
      latitude : 0,
      longitude : 1
    };

    var locValues = [];
    for ( var i in req.body ){
      if ( i in locAttr ) {
        locValues[locAttr[i]] = req.body[i];
      } else {
        res.send('Wrong parameters');
        return;// is this necessary?  will execution continue further even though we've sent?
      }
    }

    locValues.push(req.params.userID);

    user.put(locValues, function (err, result) {
      if ( err ) {
        console.error(err);
        res.status('400').send('Error with update');
      } else {
        res.send();
      }
    });

  }


}

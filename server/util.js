var fs = require('fs');
var _ = require('underscore');

module.exports = {
  isoDateToMySQL : function (date) {
    console.log(date.substring(0,10) + ' ' + date.substring(11, 19));
    return date.substring(0,10) + ' ' + date.substring(11, 19);
  },

  // checkDir : function (path, callback) {
  //   fs.readdir(path, function () {

  //   })
  // },

  writeImage : function (path, image) {

    var writeTheImage = function () {
      fs.writeFile(__dirname + '/public' + path, new Buffer(image, 'base64'), function (err) {
        if (err) {
          throw err;
        } 
        console.log('Image successfully saved to the server');
      });
    }

    writeTheImage();

    // fs.stat('/public/images', function (stats) {// check if the public directory exists
    //   console.log('stats',files);
    //   if (!stats.isDirectory()) { // if it doesn't, make that directory
    //     fs.mkdir(__dirname + '/public' + '/images', function () {
    //       writeTheImage();
    //     });
    //   } else {
    //     writeTheImage();
    //   }
      
    // });
  },

  distance : function (lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;    // Math.PI / 180
    var c = Math.cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
            c(lat1 * p) * c(lat2 * p) * 
            (1 - c((lon2 - lon1) * p))/2;

    return 7917.5 * Math.asin(Math.sqrt(a)); // Diameter of the earth: 7917.5
  },

  entriesToArray : function (data) {
    // This needs to be cleaned up and optimized
    var set = [];
    var cleanedResult = [];

    for (var i = 0; i < data.length; i ++) {
      if (data[i].userID === null) {
        data[i]['userIDs'] = null;
        cleanedResult.push(data[i]);
      } else if (!data[i + 1]['userID'] || data[i]['roomID'] !== data[i + 1]['roomID']) {
        set.push(data[i].userID);
        data[i]['userIDs'] = set;
        cleanedResult.push(data[i]);
        set = [];    
      } else {
        set.push(data[i].userID);
      }
    }
    _.each(cleanedResult, function (entry) {
      delete entry.userID;
    });
    return cleanedResult;
  }

}

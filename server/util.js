var fs = require('fs');

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
  } 

}

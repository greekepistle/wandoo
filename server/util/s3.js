var AWS = require('aws-sdk');
var fs = require('fs');

AWS.config.region = 'us-west-1';

var s3 = new AWS.S3();

var params = {Bucket: 'wandoo-images', ContentType: 'image/png', ACL: 'public-read'};

var s3BucketURL = 'https://s3-us-west-1.amazonaws.com/wandoo-images/';

var fileName = function (facebookID) {
  return 'fb-profile-pics/' + facebookID + '.png';
}

var uploadFileToS3 = function (facebookID, data) {
  params.Key = fileName(facebookID);
  params.Body = new Buffer(data, 'base64');
  s3.putObject(params, function (err, data) {
    if (err)
      console.log(err);
    else
      console.log("Successfully uploaded file to S3");
      // console.log(data);
  });
}

var fileURL = function (facebookID) {
  return s3BucketURL + fileName(facebookID);
}

module.exports = {
  uploadFileToS3 : uploadFileToS3,
  fileURL : fileURL
}





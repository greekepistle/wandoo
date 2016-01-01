var LayerAPI = require('layer-api');
 
var layer = new LayerAPI ({
  token: '1YR875AItcv775MuG3WTNrhMXgOG3AV4iU1jMpmsa8aUlkVq',
  appId: 'layer:///apps/staging/35cf31e8-ac52-11e5-be54-e99ef71601e8'
});
 
module.exports = {
  // Create a Conversation 

  createConversation : function (objectIDs, callback) {
    console.log('objectIDs',objectIDs);
    layer.conversations.create({participants: objectIDs}, function(err, result) {
      if (err) {
        callback(err);
      } else {
        console.log('Conversation created with id:', result.body.id);
        console.log('Participants:', result.body.participants);
        callback(null, result.body.id);
      }
    });
  }
  
}

//TEST
// createConversation('asg', function (err, result) {
//   if (err) {
//     console.log(err);
//   } else {
//     console.log(result);
//   }
// });

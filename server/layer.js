var LayerAPI = require('layer-api');
 
var layer = new LayerAPI ({
  token: '1YR875AItcv775MuG3WTNrhMXgOG3AV4iU1jMpmsa8aUlkVq',
  appId: 'layer:///apps/staging/35cf31e8-ac52-11e5-be54-e99ef71601e8'
});
 
module.exports = {
  createConversation : function (objectIDs, callback) {
    console.log('objectIDs received:',objectIDs);
    layer.conversations.create({participants: objectIDs}, function(err, result) {
      if (err) {
        callback(err);
      } else {
        console.log('Conversation created with id:', result.body.id);
        console.log('Participants:', result.body.participants);

        layer.messages.sendTexFromUser(result.body.id, objectIDs[0], 
          "Congratulations! We're matched. Let's get to know each other. What are you up to?", 
          function(err, res) {
           if (err) {
             console.error(err);
           }
           console.log('Message sent from host successfully');
        });
        callback(null, result.body.id);
      }
    });
  },

  updateConversation : function (cid, objectID, callback) {
    var operations = [
      {"operation": "add", "property": "participants", "value": objectID}
    ];
    layer.conversations.edit(cid, operations, function (err, result) {
      if (err) {
        callback(err);
      } else {
        // verify what result is provided here to us
        console.log('Coversation updated');
        console.log(result);
        callback(null, result);
      }
    });
  }
}


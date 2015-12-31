var LayerAPI = require('layer-api');
 
// Initialize by providing your Layer credentials 
var layer = new LayerAPI ({
  token: 'API_TOKEN',
  appId: 'APP_ID'
});
 
// Create a Conversation 
var createConversation = function (objectID, callback) {
  layer.conversations.create({participants: ['abcd']}, function(err, res) {
    if (err) {
      callback(err);
    } else {
      callback(null, res.body.id);
    }
  });
}


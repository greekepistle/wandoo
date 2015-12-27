var user = require('./controllers/user');
var wandoo = require('./controllers/wandoo');
var interested = require('./controllers/interested');
var room = require('./controllers/room');

module.exports = function (router) {
  router.get('/api/test', function (req, res) {
    console.log('Request received.');
    res.send();
  });

  router.get('/api/users', user.get)

  router.get('/api/users/:userID', user.get);

  router.post('/api/users', user.post);

  router.delete('/api/users/:userID', user.delete);

  router.put('/api/users/:userID', user.put);

  router.get('/api/wandoos', wandoo.get);

  router.post('/api/wandoos', wandoo.post);

  router.delete('/api/wandoos/:wandooID', wandoo.delete);

  router.get('/api/interested', interested.get);

  router.post('/api/interested', interested.post);

  router.put('/api/interested/:wandooID/:userID', interested.put);

  router.get('/api/rooms', room.get); 

  router.get('/api/rooms/:roomID', room.get);

  router.post('/api/rooms', room.post);

  router.delete('/api/rooms/:roomID', room.delete);

  router.put('/api/rooms/:roomID', room.put);

}

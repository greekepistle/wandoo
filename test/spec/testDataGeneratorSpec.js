var generate = require('../generateTestData');
var expect = require('chai').expect;

// IN PROGRESS

describe('generateUsers', function () {
  before(function executeFunction (done) {
    generate.generateUsers(done);
  });
  // verify in the database that the correct n
});

describe('getUserIDs', function () {
  before(function executeFunction (done) {
    var userIDs = generate.getUserIDs(done);
  });
  // it('should return an array of userIDs')
});

describe('generateWandoos', function () {
  before(function executeFunction (done) {
    generate.generateWandoos(done);
  });
});

describe('getWandooIDs', function () {
  before(function executeFunction (done) {
    generate.getWandooIDs(done);
  });
});

xdescribe('generateInterests', function () {
  before(function executeFunction (done) {
    var userIDs = [61,62,63];
    var wandooIDs = [1,2];
    generate.generateInterests(userIDs, wandooIDs, function () {
      console.log('Complete');
      done();
    });
  });
  it('is a function', function () {
    expect(generate.generateInterests).to.be.a('function');
  });
});



var express = require('express');
var app = express();
app.use(express.bodyParser());

app.post('/v1/sessions', function(req, res) {
  var token = {
    "token":{
      "id":"testTokenId",
      "email":"testEmail",
      "userId":"testUserId"
    }
  }
  res.send(token);
});

app.post('/v1/users', function(req, res) {
  if (req.query.email == 'duplicateEmail') {
    var response = {"error":"Email is already in use"};
  } else {
    var response = {
      "token":{
        "id":"testTokenId",
        "email":"testEmail",
        "userId":"testUserId"
      }
    }
  }
    res.send(response);
});

app.get('/v1/users/password', function(req, res) {
    if (req.query.email == 'invalidEmail') {
      var response = {"error":"Email was invalid"};
    } else {
      var response = {"msg":"Please check your email for the reset code"};
    }
    res.send(response);
});

app.put('/v1/users/password', function(req, res) {
  if (req.query.code == 'invalidCode') {
    var response = {"error":"Code was invalid"};
  } else {
    var response = {
      "token":{
        "id":"testTokenId",
        "email":"testEmail",
        "userId":"testUserId"
      }
    }
  }
  res.send(response);
});


app.listen(3000);
console.log('Listening on port 3000');


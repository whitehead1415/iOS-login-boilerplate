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
    response = {"error":"Email is already in use"};
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


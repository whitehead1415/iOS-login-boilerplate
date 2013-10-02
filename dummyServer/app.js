var express = require('express');
var app = express();

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


app.listen(3000);
console.log('Listening on port 3000');


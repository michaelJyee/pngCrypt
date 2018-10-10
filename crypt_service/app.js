const express = require('express');
const app = express();
const port = 4000;
const bodyParser = require('body-parser');
const fs = require("fs");
const steggy = require('steggy')

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({limit: '50mb', extended: true}))
// parse application/json
app.use(bodyParser.json({limit: '50mb', extended: true}))

//PING 
app.get('/ping', function (req, res) {
  console.log("GET-PING HEY Bitch!");
  res.send('pong')
})

app.post('/ping', function (req, res) {
  var base64Data = req.body.imageData.replace(/^data:image\/png;base64,/, "");
  var original = new Buffer(base64Data, 'base64');
  var message = req.body.message;

  var buffer = steggy.conceal()(original, message);
  let encoded64 = buffer.toString('base64');

  res.json({encodedImageData:encoded64})
})

//Encryption Services
app.post('/encryption', function(req,res){
  var base64Data = req.body.imageData.replace(/^data:image\/png;base64,/, "");
  
  require("fs").writeFile("./out.png", base64Data, 'base64', function(err) {
    if(err) console.log(err);
    else console.log("fin!");
  });

  res.send(200);
});


app.post('/decrypt', function(req,res){
  var base64Data = req.body.imageData.replace(/^data:image\/png;base64,/, "");
  var original = new Buffer(base64Data, 'base64');
  var buffer = steggy.reveal()(original);
  var decryptedMessage = buffer.toString();

  res.json({decryptedMessage:decryptedMessage});
});



app.listen(port, () => console.log(`Example app listening on port ${port}!`))

/**
 * Module dependencies.
 */

var express = require('../');

var app = express()
  , blog = express();

// app.use(express.logger('dev'));
app.use('/blog', blog);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.locals.self = true;

// generate 600 pets

var pets = [];
var n = 200;
while (n--) {
  pets.push({ name: 'Tobi', age: 2, species: 'ferret' });
  pets.push({ name: 'Loki', age: 1, species: 'ferret' });
  pets.push({ name: 'Jane', age: 6, species: 'ferret' });
}

app.get('/render', function(req, res){
  res.render('hello');
});

app.get('/render/large', function(req, res){
  res.render('large', { pets: pets });
});

blog.get('/', function(req, res){
  res.send('Hello World\n');
});

app.get('/', function(req, res){
  res.send('Hello World\n');
});

app.get('/json', function(req, res){
  res.send({ name: 'Tobi', role: 'admin' });
});

function foo(req, res, next) {
  next();
}

app.get('/middleware', foo, foo, foo, foo, function(req, res){
  res.send('Hello World\n');
});

var n = 100;
while (n--) {
  app.get('/foo', foo, foo, function(req, res){
    
  });
}

app.get('/match', function(req, res){
  res.send('Hello World\n');
});

app.listen(8000);
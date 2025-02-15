const express = require('express')
const session = require('express-session');
const { v4:genuuid } = require('uuid');
const app = express()
const port = 4000

var sessionstore = require('sessionstore'); // need a memcache or redis store instead
var store = sessionstore.createSessionStore();

app.use(session({
    genid: function(req) {
        return genuuid()
    },
    secret: 'keyboard cat',
    name: 'spademo',
    resave: false,
    saveUninitialized: true,
    store,
    cookie: { secure: false } // live has to be true
}))

app.use(express.static('public'));
app.get('/api/health', (req, res) => {
    console.log("health check")
    res.send("OK");
});
app.get('/auth/logout', (req, res, next) => {
    console.log("logout")
    req.session.user = null;
    req.session.save();
    return res.redirect('/login.html')
});
app.get('/auth/login', (req, res, next) => {
    console.log("login")
    if (req.query.email) {
        req.session.user = {
            email: req.query.email
        }
        return next();
    }
    return res.redirect('/login.html');
});

// protect resource
app.use((req, res, next) => {
    if (req.session.user) {
        return next();
    }
    res.redirect('/login.html');
});

//api
app.get('/api/user', (req, res, next) => {
    console.log("/api/user")
    res.json(req.session.user);
});

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
  
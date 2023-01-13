const { connect } = require('getstream');
const bcrypt = require('bcrypt');
const StreamChat = require('stream-chat').StreamChat;
const crypto = require('crypto');

var db = require('../db');

require('dotenv').config();

const api_key = process.env.STREAM_API_KEY;
const api_secret = process.env.STREAM_API_SECRET;
const app_id = process.env.STREAM_APP_ID;

const signup = async (req, res) => {
    try {
        const { username, password } = req.body;

        const userId = crypto.randomBytes(16).toString('hex');
        register(userId, username, password, function(err, result) {
            if (err) {
                res.status(500).json({ message: err });
                return;
            }
            const feedClient = connect(api_key, api_secret, app_id, { location: 'eu-west' });
            const chatClient = StreamChat.getInstance(api_key, api_secret);//, location = "eu-west");
                
            const chatResult = chatClient.upsertUser({
                id: userId,
                username: username,
                // email: user.email,
                // image: user.photoURL,
              });
    
            const feedResult = feedClient.user(userId).getOrCreate();
            const feedToken = feedClient.createUserToken(userId);
            const chatToken = chatClient.createToken(userId);
    
            res.status(200).json({ feedToken, chatToken, username, userId });
        })

    } catch (err) {
        console.log(err);

        res.status(500).json({ message: err });
    }
};

const login = async (req, res) => {
    try {
        const { username, password } = req.body;

        verify(username, password, async function(err, result) {
            if (err) {
                res.status(500).json({ message: err });
                return;
            }

            const feedClient = connect(api_key, api_secret, app_id, { location: 'eu-west' });
            const chatClient = StreamChat.getInstance(api_key, api_secret);//, location="eu-west" )

            const { users } = await chatClient.queryUsers({ username: { $eq: username } });
            if(!users.length) return res.status(400).json({ message: 'User not found' });

            const feedResult = feedClient.user(users[0].id).get()
            const chatToken = chatClient.createToken(username);
            const feedToken = feedClient.createUserToken(username);

            res.status(200).json({ feedToken, chatToken, username, userId: users[0].id});
        })
        
    } catch (error) {
        console.log(error);

        res.status(500).json({ message: error.message });
    }
};

function register(userId, username, password, cb) {
    var salt = bcrypt.genSaltSync(10);

    var data = {
        userId: userId,
        username: username,
        hashed_password: bcrypt.hashSync(password, salt),
        salt: salt
    }

    var sql ='INSERT INTO users (id, username, hashed_password, salt) VALUES (?,?,?,?)'
    var params =[data.userId, data.username, data.hashed_password, data.salt]
    db.run(sql, params, function (err, innerResult) {
        if (err){
            cb(err)
        } else {
            cb(null, data)
        }
    });
}

function verify(username, password, cb) {
    db.get('SELECT * FROM users WHERE username = ?', [ username ], function(err, row) {
      if (err) { return cb(err); }
      if (!row) { return cb('Incorrect username or password.'); }
      
      const hashed_password = bcrypt.hashSync(password, row.salt);

      if (hashed_password === row.hashed_password) {
        cb(null, row);        
      } else {
        return cb('Incorrect username or password.');
      }
    });
  }
// "$2b$10$Z2LS.rJyA7u9kKAdtr3zQ.QCOaiYKiLpgisCDrzOBjjh6lInQGZQS"
// "$2b$10$Z2LS.rJyA7u9kKAdtr3zQ.QCOaiYKiLpgisCDrzOBjjh6lInQGZQS"
module.exports = { signup, login }
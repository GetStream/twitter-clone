const { connect } = require('getstream');
const bcrypt = require('bcrypt');
const StreamChat = require('stream-chat').StreamChat;
const crypto = require('crypto');

require('dotenv').config();

const api_key = process.env.STREAM_API_KEY;
const api_secret = process.env.STREAM_API_SECRET;
const app_id = process.env.STREAM_APP_ID;

const signup = async (req, res) => {
    try {
        const { fullName, username, password, phoneNumber } = req.body;

        const userId = crypto.randomBytes(16).toString('hex');
        
        // const feedClient = connect(api_key, api_secret, app_id, { location: 'eu-west' });
        const chatClient = StreamChat.getInstance(api_key, api_secret);//, location = "eu-west");

        const hashedPassword = await bcrypt.hash(password, 10);
        
        const chatResult = await chatClient.upsertUser({
            id: userId,
            name: fullName,
            username: username,
            // email: user.email,
            // image: user.photoURL,
          });

        // const feedResult = await feedClient.user(userId).getOrCreate({
        //       name: fullName
        //   });
        // const feedToken = feedClient.createUserToken(userId);
        const chatToken = chatClient.createToken(userId);

        res.status(200).json({ chatToken, fullName, username, userId, hashedPassword, phoneNumber });
    } catch (error) {
        console.log(error);

        res.status(500).json({ message: error });
    }
};

const login = async (req, res) => {
    try {
        const { username, password } = req.body;
        
        const feedClient = connect(api_key, api_secret, app_id, { location: 'eu-west' });
        const chatClient = StreamChat.getInstance(api_key, api_secret);//, location="eu-west" )

        const { users } = await chatClient.queryUsers({ username: { $eq: username } });
        if(!users.length) return res.status(400).json({ message: 'User not found' });

        const feedResult = await feedClient.user(username).get()
        const chatToken = await chatClient.createToken(username);
        const feedToken = await feedClient.createUserToken(username);

        const success = true;//await bcrypt.compare(password, users[0].hashedPassword);

        if(success) {
            res.status(200).json({ feedToken, chatToken, fullName: users[0].fullName, username, userId: users[0].id});
        } else {
            res.status(500).json({ message: 'Incorrect password' });
        }
    } catch (error) {
        console.log(error);

        res.status(500).json({ message: error });
    }
};

module.exports = { signup, login }
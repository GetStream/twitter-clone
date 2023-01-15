const { connect } = require("getstream");
const StreamChat = require("stream-chat").StreamChat;
const bcrypt = require("bcrypt");

const db = require("../db");
require("dotenv").config();

const api_key = process.env.STREAM_API_KEY;
const api_secret = process.env.STREAM_API_SECRET;
const app_id = process.env.STREAM_APP_ID;

const verifyUser = (username, password, cb) => {
    db.get(
        "SELECT * FROM users WHERE username = ?",
        [username],
        function (err, row) {
            if (err) {
                return cb(err);
            }
            if (!row) {
                return cb("User with this username doesn't exist.");
            }
            const hashed_password = bcrypt.hashSync(password, row.salt);
            if (hashed_password === row.hashed_password) {
                cb(null, row);
            } else {
                return cb("Incorrect Password.");
            }
        }
    );
};

const registerUser = (userId, username, password, cb) => {
    const salt = bcrypt.genSaltSync(10);
    const hashed_password = bcrypt.hashSync(password, salt);

    const sql =
        "INSERT INTO users (id, username, hashed_password, salt) VALUES (?,?,?,?)";
    const params = [userId, username, hashed_password, salt];
    db.run(sql, params, function (err, innerResult) {
        if (err) {
            cb(err, innerResult);
        } else {
            cb(null, { userId, username, hashed_password, salt });
        }
    });
};

const signupHandler = async (err, result, res) => {
    if (err) {
        res.status(500).json({ message: err });
        return;
    }
    const { username, userId } = result;
    const feedClient = connect(api_key, api_secret, app_id, {
        location: "eu-west",
    });
    const chatClient = StreamChat.getInstance(api_key, api_secret); //, location = "eu-west");
    chatClient.upsertUser({
        id: userId,
        username: username,
    });

    const feedToken = feedClient.createUserToken(userId);
    const chatToken = chatClient.createToken(userId);

    res.status(200).json({ feedToken, chatToken, username, userId });
};

const loginHandler = async (error, result, res) => {
    if (error) {
        res.status(500).json({ message: error });
        return;
    }
    const { username, id } = result;
    const feedClient = connect(api_key, api_secret, app_id, {
        location: "eu-west",
    });
    const chatClient = StreamChat.getInstance(api_key, api_secret); //, location="eu-west"
    const { users } = await chatClient.queryUsers({
        username: { $eq: username },
    });
    if (!users.length) {
        return res
            .status(400)
            .json({ message: "User not found in Chat Database" });
    }

    const chatToken = chatClient.createToken(id);
    const feedToken = feedClient.createUserToken(id);

    res.status(200).json({
        feedToken,
        chatToken,
        username,
        userId: id,
    });
};

module.exports = { verifyUser, loginHandler, registerUser, signupHandler };

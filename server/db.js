const sqlite3 = require("sqlite3");
const mkdirp = require("mkdirp");
const crypto = require("crypto");

mkdirp.sync("./var/db");

const db = new sqlite3.Database("./var/db/twitter-clone.db");

// create the database schema for the todos app
const createTable = () => {
    db.run(
        "CREATE TABLE IF NOT EXISTS users ( \
id TEXT PRIMARY KEY, \
username TEXT UNIQUE, \
hashed_password BLOB, \
salt BLOB \
)"
    );
};

// create an initial user (username: alice, password: letmein)
const createInitialUser = () => {
    const salt = crypto.randomBytes(16);
    db.run(
        "INSERT OR IGNORE INTO users (username, hashed_password, salt) VALUES (?, ?, ?)",
        [
            "alice",
            crypto.pbkdf2Sync("letmein", salt, 310000, 32, "sha256"),
            salt,
        ]
    );
};

db.serialize(function () {
    createTable();
    createInitialUser();
});

module.exports = db;

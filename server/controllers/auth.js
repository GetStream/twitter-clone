const crypto = require("crypto");
const {
    loginHandler,
    registerUser,
    signupHandler,
    verifyUser,
} = require("../utils");

const signup = async (req, res) => {
    try {
        const { username, password } = req.body;
        const userId = crypto.randomBytes(16).toString("hex");

        registerUser(userId, username, password, function (err, result) {
            signupHandler(err, result, res);
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: err });
    }
};

const login = async (req, res) => {
    try {
        const { username, password } = req.body;

        verifyUser(username, password, (err, result) => {
            loginHandler(err, result, res);
        });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: error.message });
    }
};

// "$2b$10$Z2LS.rJyA7u9kKAdtr3zQ.QCOaiYKiLpgisCDrzOBjjh6lInQGZQS"
// "$2b$10$Z2LS.rJyA7u9kKAdtr3zQ.QCOaiYKiLpgisCDrzOBjjh6lInQGZQS"
module.exports = { signup, login };

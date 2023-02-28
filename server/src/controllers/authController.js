const { Router } = require('express')
const router = Router();

const User = require('../models/userModal');

const jwt = require('jsonwebtoken');
const config = require('../config');

router.post('/signup', async(req, res) => {
    try {
        const { username, email, password } = req.body;
        const user = new User({ username, email, password });
        user.password = await user.encryptPassword(password);
        await user.save();

        const token = jwt.sign({ id: user.id }, config.secret, {
            expiresIn: '24h'
        });
        res.status(200).json({ auth: true, token });
    } catch (e) {
        console.log(e);
        res.status(500).send("Error al registrarse");
    }
});

router.post('/signin', async(req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email })
        if (!user) {
            return res.status(404).send('El correo no existe');
        }
        const validPassword = await user.validatePassword(req.body.password, user.password);
        if (!validPassword) {
            return res.status(404).send('La contrasña es incorrecta');
        }
        const token = jwt.sign({ id: user._id }, config.secret, {
            expiresIn: '24h'
        });
        res.status(200).json({ auth: true, token });
    } catch (e) {
        console.log(e);
        res.status(500).send('Error al iniciar');
    }
});

router.get('/logout', function(req, res) {
    res.status(200).send({ auth: false, token: null });
});

module.exports = router;
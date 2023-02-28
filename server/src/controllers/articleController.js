const { Router } = require('express')
const router = Router();

const Article = require('../models/articleModal');

router.get('/getArticles', async(req, res) => {
    try {
        const articles = await Article.find({});
        res.status(200).send(articles);
    } catch (e) {
        console.log(e);
        res.status(500).send("Error al obtener los articulos");
    }
});

router.post('/registerArticles', async(req, res) => {
    try {
        const { imagen, nombre, vendedor, calificacion } = req.body;
        const article = new Article({
            imagen,
            nombre,
            vendedor,
            calificacion
        });
        await article.save();
        res.status(200).json({ check: true });
    } catch (e) {
        console.log(e);
        res.status(500).send("Error al registrar producto");
    }
});
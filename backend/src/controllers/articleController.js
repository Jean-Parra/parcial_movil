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
        const { foto, nombre, vendedor, calificacion } = req.body;
        const article = new Article({
            foto,
            nombre,
            vendedor,
            calificacion,
            false: false
        });
        await article.save();
        res.status(200).json({ check: true });
    } catch (e) {
        console.log(e);
        res.status(500).send("Error al registrar producto");
    }
});

router.put('/estrella', async (req, res) => {
    try {
      const nombre = req.query.nombre; 
  
      const article = await Article.findOne({ nombre });
      if (!article) {
        return res.status(404).send('Article not found');
      }
  
      article.estrella = !article.estrella;
      await article.save();
      res.status(200).json({ success: true, article });
    } catch (e) {
      console.log(e);
      res.status(500).send('Error toggling estrella attribute');
    }
  });
  
  
  

module.exports = router;
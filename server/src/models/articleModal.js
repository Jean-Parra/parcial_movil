const { Schema, model } = require('mongoose');

const articleShema = new Schema({
    imagen: String,
    nombre: String,
    vendedor: String,
    calificacion: String
});


module.exports = model('Articles', articleShema)
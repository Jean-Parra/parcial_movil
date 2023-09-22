const { Schema, model } = require('mongoose');

const articleShema = new Schema({
    foto: String,
    nombre: String,
    vendedor: String,
    calificacion: String,
    estrella: Boolean
});


module.exports = model('Articles', articleShema)
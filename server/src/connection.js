const mongoose = require('mongoose')

mongoose.set("strictQuery", true);
mongoose.connect("mongodb://127.0.0.1:27017/parcial_movil", {
        useNewUrlParser: true,
        useUnifiedTopology: true
    })
    .then(db =>
        console.log('MongoDB connection established.')
    )
    .catch((error) => console.log("MongoDB connection failed:", error.message))
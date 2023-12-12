const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const cors = require("cors");
const PORT = 3099;

var fs = require("fs");
app.use(cors({ origin: "*" }));
app.use(express.json({ limit: "250mb" }));
app.use(bodyParser.urlencoded({ extended: true }));

fs.readdirSync("routes").forEach(function (file) {
    if (file[0] == ".") return;
    var routeName = file.substr(0, file.indexOf("."));
    require("./routes/" + routeName)(app);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(
        `FOOTBALLDER app listening at port ${PORT} `
    );
});

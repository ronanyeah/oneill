var fa = require("@fortawesome/fontawesome").default;

fa.library.add(require("@fortawesome/fontawesome-free-brands/faTwitter"));
fa.library.add(require("@fortawesome/fontawesome-free-brands/faFacebookF"));
fa.library.add(require("@fortawesome/fontawesome-free-brands/faInstagram"));

fa.library.add(require("@fortawesome/fontawesome-free-solid/faMapMarkerAlt"));
fa.library.add(require("@fortawesome/fontawesome-free-solid/faPhone"));
fa.library.add(require("@fortawesome/fontawesome-free-solid/faEnvelope"));

var Elm = require("./Main.elm");

var app = Elm.Main.embed(document.getElementById("app"));

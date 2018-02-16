var fa = require("@fortawesome/fontawesome").default;

fa.library.add(require("@fortawesome/fontawesome-free-brands/faTwitter"));
fa.library.add(require("@fortawesome/fontawesome-free-brands/faFacebookF"));
fa.library.add(require("@fortawesome/fontawesome-free-brands/faInstagram"));

fa.library.add(require("@fortawesome/fontawesome-free-solid/faMapMarkerAlt"));
fa.library.add(require("@fortawesome/fontawesome-free-solid/faPhone"));
fa.library.add(require("@fortawesome/fontawesome-free-solid/faEnvelope"));

var Elm = require("./Main.elm");

var app = Elm.Main.embed(document.body);

window.initMap = function() {
  var map = new google.maps.Map(document.createElement("div"));

  var service = new google.maps.places.PlacesService(map);

  service.getDetails(
    {
      placeId: "ChIJjzfi5b-lRUgRMa-Dov_hHrA"
    },
    function(place, status) {
      if (status === "OK") {
        app.ports.hours.send(place);
      }
    }
  );
};

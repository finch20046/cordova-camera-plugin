"use strict";

var Functions = function() {
};

Functions.getPicture = function(success, fail) {
  cordova.exec(success, fail, "CameraPlugin", "openCamera", []);
};


module.exports = Functions;
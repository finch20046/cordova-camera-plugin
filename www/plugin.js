"use strict";

var Functions = function() {
};

Functions.getPicture = function(value, success, fail) {
  cordova.exec(success, fail, "CameraPlugin", "openCamera", []);
};


module.exports = Functions;
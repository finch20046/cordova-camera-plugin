"use strict";

var Functions = function() {
};

Functions.takePhoto = function(value, success, fail) {
  cordova.exec(success, fail, "CameraPlugin", "performPayment", [value]);
};


module.exports = Functions;
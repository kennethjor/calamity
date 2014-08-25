// Import underscore if necessary.
if (typeof _ === "undefined" && typeof require === "function") {
	_ = require("underscore");
}

// Init Calamity object.
var Calamity = {version: "%version%"};

var root = this
// CommonJS
if (typeof exports !== "undefined") {
	if (typeof module !== "undefined" && module.exports) {
		exports = module.exports = Calamity;
	}
	exports.Calamity = Calamity;
}
// AMD
else if (typeof define === "function" && define.amd) {
    define(['calamity'], Calamity);
}
// Browser
else {
	root['calamity'] = Calamity;
}

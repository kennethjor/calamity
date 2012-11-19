// Import underscore if necessary.
if (typeof _ === "undefined" && typeof require === "function") {
	_ = require("underscore");
}

// Init Calamity object.
var C = {};

// This wrapper is brutally stolen from Underscore 1.4.2.
// https://raw.github.com/documentcloud/underscore/master/underscore.js
var root = this
if (typeof exports !== 'undefined') {
	if (typeof module !== 'undefined' && module.exports) {
		exports = module.exports = C;
	}
	exports.C = C;
} else {
	root['Calamity'] = C;
}

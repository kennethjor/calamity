module.exports = function(grunt) {

	// Project configuration.
	grunt.initConfig({
		pkg: '<json:package.json>',
		meta: {
			banner: "/*! <%= pkg.fullname %> <%= pkg.version %> - MIT license */",
			wrapperVersion: "C.VERSION = \"<%= pkg.version %>\";",
			wrapperStart: "(function(){",
			wrapperEnd: "})();"
		},

		coffee: {
			core: {
				files: {
					"build/tmp/core.js": ["src/core/*.coffee"]
				},
				options: {
					bare: true
				}
			},
			tests: {
				files: {
					"build/test/*.js": ["test/**/*.coffee"]
				}
			}
		},
		concat: {
			core: {
				src: [
					"<banner>",
					"<banner:meta.wrapperStart>",
					"src/init/init.js",
					"<banner:meta.wrapperVersion>",
					"build/tmp/core.js",
					"<banner:meta.wrapperEnd>"
				],
				dest: "build/dist/<%= pkg.name %>.js"
			}
		},
		min: {
			core: {
				src: [
					"<banner>",
					"<config:concat.core.dest>"
				],
				dest: "build/dist/<%= pkg.name %>-min.js"
			}
		},
		test: {
			files: "<%= _.keys(coffee.tests.files) %>"
		},
		watch: {
			files: [
				"src/**",
				"test/**"
			],
			tasks: "default"
		}
	});

	// Load grunt plugins.
	grunt.loadNpmTasks("grunt-contrib-coffee");

	// Default task.
	grunt.registerTask("default", "coffee concat min test");

};

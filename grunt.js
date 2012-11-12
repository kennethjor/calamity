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
			// Compiles the core coffee files.
			core: {
				files: {
					"build/tmp/core.js": ["src/core/*.coffee"]
				},
				options: {
					bare: true
				}
			},
			// Compile the core test coffee files.
			core_test: {
				files: {
					"build/test/core/*.js": ["test/core/*.coffee"]
				}
			}
		},

		concat: {
			// Assembles the core distribution files.
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
			// Minimizes the core distribution files.
			core: {
				src: [
					"<banner>",
					"<config:concat.core.dest>"
				],
				dest: "build/dist/<%= pkg.name %>-min.js"
			}
		},

		test: {
			files : [
				// Core tests.
				"<%= _.keys(coffee.core_test.files) %>"
			]
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

	// Core compile.
	grunt.registerTask("compile-core", "coffee:core concat:core min:core");
	grunt.registerTask("test-core", "coffee:core_test test");

	// Default task.
	grunt.registerTask("default", "compile-core test-core");

};

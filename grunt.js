module.exports = function(grunt) {

	// Project configuration.
	grunt.initConfig({
		pkg: '<json:package.json>',
		meta: {
			banner: "/*! <%= pkg.fullname %> <%= pkg.version %> - MIT license */",
			wrapperVersion: "C.VERSION = \"<%= pkg.version %>\";",
			wrapperStart: "(function(){",
			wrapperEnd: "}).call(this);"
		},

		coffee: {
			// Initial precompile to catch compile errors properly.
			core_first: {
				files: {
					"build/core/*.js": ["src/core/*.coffee"]
				},
				options: {
					bare: true
				}
			},
			// Second compile of concatenated coffee files for more minimizes output.
			core_second: {
				files: {
					"build/core/calamity.js": ["build/core/<%= pkg.name %>.coffee"]
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
			},
			// Compile the jasmine specs.
			spec: {
				files: {
					"build/spec/*.js": ["spec/**/*.coffee"]
				}
			}
		},

		// Build Jasmine specs for the browser
		browserify: {
			"build/spec.js": {
//				requires: ['traverse'],
//				aliases: ['jquery:jquery-browserify'],
				entries: ["spec/**/*.coffee"]
			}
		},

		// Execute Jasmine specs
		jasmine : {
//			src : "calamity.js",
			specs : "build/spec.js",
			//helpers : "specs/helpers/*.js",
			timeout : 10000,
			verbose: true,
			junit : {
				output : "build/junit/"
			},
			phantomjs : {
				"ignore-ssl-errors" : true
			}
		},

		concat: {
			// Assembles the core coffee files in prep for full compile.
			core_coffee: {
				src: "src/core/*.coffee",
				dest: "build/core/<%= pkg.name %>.coffee"
			},
			// Assembles the core distribution files.
			core_dist: {
				src: [
					"<banner>",
					"<banner:meta.wrapperStart>",
					"src/init/init.js",
					"<banner:meta.wrapperVersion>",
					"<%= _.keys(coffee.core_second.files)[0] %>",
					"<banner:meta.wrapperEnd>"
				],
				dest: "<%= pkg.name %>.js"
			}
		},
		min: {
			// Minimizes the core distribution files.
			core: {
				src: [
					"<banner>",
					"<config:concat.core_dist.dest>"
				],
				dest: "<%= pkg.name %>-min.js"
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
	grunt.loadNpmTasks("grunt-jasmine-runner");
//	grunt.loadNpmTasks("grunt-jasmine-node");
	grunt.loadNpmTasks("grunt-browserify");

	// Core compile.
	grunt.registerTask("compile-core", "coffee:core_first concat:core_coffee coffee:core_second");
	grunt.registerTask("dist-core", "concat:core_dist min:core");
	grunt.registerTask("test-core", "coffee:core_test test");
	grunt.registerTask("build-core", "compile-core dist-core test-core");
	// Default task.
	grunt.registerTask("default", "build-core");

};

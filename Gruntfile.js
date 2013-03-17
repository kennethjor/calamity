var exec = require("child_process").exec;

module.exports = function(grunt) {
	// Project configuration.
	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json"),

		coffee: {
			// Core compile
			core: {
				files: {
					"build/calamity.js": ["src/core/*.coffee"]
				},
				options: {
					bare: true
				}
			},
			// Compile the test files.
			test: {
				expand: true,
				cwd: "test",
				src: ["**/*.coffee"],
				dest: "build/test",
				ext: ".js"
			},
			// Compile the Jasmine specs.
			spec: {
				expand: true,
				cwd: "spec",
				src: ["**/*.coffee"],
				dest: "build/spec",
				ext: ".js"
			}
		},

		concat: {
			// Assembles the core distribution files.
			core: {
				options: {
					banner:
						"/*! <%= pkg.fullname %> <%= pkg.version %> - MIT license */\n" +
						"(function(){\n",
					footer: "}).call(this);",
					process: true
				},
				src: [
					"src/init/init.js",
					"<%= _.keys(coffee.core.files)[0] %>"
				],
				dest: "<%= pkg.name %>.js"
			}
		},

		uglify: {
			core: {
				options: {
					preserveComments: "some"
				},
				files: {
					"calamity-min.js": "calamity.js"
				}
			}
		},

		nodeunit: {
			all: ["build/test/**/*.js"]
		},

		watch: {
			files: [
				"src/**",
				"test/**",
				"spec/**"
			],
			tasks: "default"
		}
	});

	grunt.registerTask("jessie", "Runs Jasmine with Jessie.", function() {
		done = this.async();
		command = "./node_modules/jessie/bin/jessie build/spec"
		exec(command, function(err, stdout, stderr) {
			console.log(stdout);
			if (err) {
				grunt.warn(err);
				done(false);
			}
			else {
				done(true);
			}
		});
	});

	// Load grunt plugins.
	grunt.loadNpmTasks("grunt-contrib-coffee");
	grunt.loadNpmTasks("grunt-contrib-concat");
	grunt.loadNpmTasks("grunt-contrib-uglify");
	grunt.loadNpmTasks("grunt-contrib-nodeunit");
//	grunt.loadNpmTasks("grunt-jasmine-runner");
//	grunt.loadNpmTasks("grunt-jasmine-node");
//	grunt.loadNpmTasks("grunt-browserify");

	grunt.registerTask("default", ["coffee", "concat", "uglify", "nodeunit", "jessie"]);

	// Core compile.
//	grunt.registerTask("compile-core", "coffee:core_first concat:core_coffee coffee:core_second");
//	grunt.registerTask("dist-core", "concat:core_dist min:core");
//	grunt.registerTask("test-core", "coffee:core_test test"); // will go away once ported to jasmine
//	grunt.registerTask("spec-phantomjs", "browserify jasmine");
//	grunt.registerTask("build-core", "compile-core dist-core test-core spec-phantomjs");
	// Default task.
//	grunt.registerTask("default", "build-core");

};

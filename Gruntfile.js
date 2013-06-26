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
			all: ["build/test/**/*Test.js"]
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

	// Jessie Jasmine runner.
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

	// Default task.
	grunt.registerTask("default", ["coffee", "concat", "uglify", "nodeunit", "jessie"]);
};

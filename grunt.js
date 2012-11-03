module.exports = function(grunt) {

	// Project configuration.
	grunt.initConfig({
		pkg: '<json:package.json>',
		meta: {
			banner: "/*! <%= pkg.fullname %> <%= pkg.version %> - <%= pkg.homepage %> */"
		},

		coffee: {
			main: {
				files: {
					"build/<%= pkg.name %>.js": ["src/**/*.coffee"]
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
			main: {
				src: [
					"<banner:meta.banner>",
					"build/<%= pkg.name %>.js"
				],
				dest: "build/dist/<%= pkg.name %>.js"
			}
		},
		min: {
			main: {
				src: [
					"<banner:meta.banner>",
					"<config:concat.main.dest>"
				],
				dest: "build/dist/<%= pkg.name %>-min.js"
			}
		},
		test: {
			files: "<%= _.keys(coffee.tests.files) %>"
		},
//		"require-dir": {
//			main: {
//				src: "src/*",
//				baseDir: "src/",
//				prefixDir: "calamity/",
//				dest: "build/amd.js"
//			}
//		},
//		test: {
//			files: ['test/**/*.js']
//		},
//		lint: {
//			files: ['grunt.js', 'lib/**/*.js', 'test/**/*.js']
//		},
		watch: {
			files: [
				"src/**",
				"test/**"
			],
			tasks: "default"
		},
		uglify: {}
	});

	// Load grunt plugins.
	grunt.loadNpmTasks("grunt-contrib-coffee");
	grunt.loadNpmTasks('grunt-require-dir');

	// Default task.
	grunt.registerTask("default", "coffee concat min test");

};

module.exports = function(grunt) {

	// Project configuration.
	grunt.initConfig({
		pkg: '<json:package.json>',
		meta: {
			banner: [
				"/*!",
				" <%= pkg.fullname %> <%= pkg.version %>",
				" Built <%= grunt.template.today('yyyy-mm-dd') %>",
				" <%= pkg.homepage %>",
				" Copyright (c) <%= grunt.template.today('yyyy') %> <%= pkg.author.name %>;",
				" Licensed <%= _.pluck(pkg.licenses, 'type').join(', ') %>",
				"/"
			].join("\n *")

		},

		coffee: {
			compile: {
				files: {
					"build/<%= pkg.name %>.js": ["src/**/*.coffee"],
				}
			}
		},
		concat: {
			dist: {
				src: [
					"<banner:meta.banner>",
					"build/<%= pkg.name %>.js"
				],
				dest: "dist/<%= pkg.name %>.js"
			}
		},
		min: {
			dist: {
				src: [
					"<banner:meta.banner>",
					"<config:concat.dist.dest>"
				],
				dest: "dist/<%= pkg.name %>-min.js"
			}
		},
//		test: {
//			files: ['test/**/*.js']
//		},
//		lint: {
//			files: ['grunt.js', 'lib/**/*.js', 'test/**/*.js']
//		},
		watch: {
			files: "src/**",
			tasks: "default"
		},
//		uglify: {}
	});

	// Load CoffeeScript plugin
	grunt.loadNpmTasks("grunt-contrib-coffee");

	// Default task.
	grunt.registerTask("default", "coffee concat min");

};

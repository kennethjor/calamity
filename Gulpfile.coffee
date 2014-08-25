fs = require "fs"
gulp = require "gulp"
sourcemaps = require "gulp-sourcemaps"
concat = require "gulp-concat"
coffee = require "gulp-coffee"
uglify = require "gulp-uglify"
jasmine = require "gulp-jasmine"
wrapper = require "gulp-wrapper"

pkg = JSON.parse fs.readFileSync "package.json"

gulp.task "compile", ->
	gulp.src "./src/**/*.coffee"
		.pipe sourcemaps.init
			loadMaps: true
		.pipe concat "calamity.coffee"
		.pipe coffee()
		.pipe wrapper
			header: "/*! #{pkg.fullname} #{pkg.version} - MIT license */\n" + "(function(){\n" + fs.readFileSync "src/init/init.js"
			footer: "}).call(this);"
		.pipe sourcemaps.write ".",
			includeContent: true
			sourceRoot: "/calamity"
		.pipe gulp.dest "."

gulp.task "test", ["compile"], ->
	gulp.src "spec/**/*.coffee"
		.pipe jasmine
			verbose: true
			includeStackTrace: true

gulp.task "minimize", ["compile"], ->
	gulp.src ["calamity.js"]
		.pipe sourcemaps.init
			loadMaps: true
		.pipe concat "calamity-min.js"
		.pipe uglify
			preserveComments: "some"
		.pipe sourcemaps.write ".",
			includeContent: true
			sourceRoot: "/calamity"
		.pipe gulp.dest "."

gulp.task "watch", ->
	gulp.watch "src/**", ["default"]

gulp.task "default" , ["test", "minimize"]

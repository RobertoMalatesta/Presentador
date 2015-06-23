var gulp = require('gulp');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var logarithmic = require('logarithmic');

gulp.task("default", ["scripts", "styles", "images", "watch"], function() {
	// does nothing by itself
});

gulp.task("scripts", function () {
	gulp.src("source/scripts/*.coffee")
		.pipe(coffee({bare: true}).on('error', logarithmic.error))
		.pipe(uglify())
		.pipe(gulp.dest("public/scripts"))
});

gulp.task("styles", function() {
	gulp.src("source/styles/*.styl")
		.pipe(gulp.dest("public/styles"))
});

gulp.task("images", function() {
	gulp.src("source/images/*")
		.pipe(gulp.dest("public/images"))
})

gulp.task("watch", function() {
	gulp.watch("source/scripts/*.coffee", ["scripts"]);
	gulp.watch("source/styles/*.styl", ["styles"]);
});

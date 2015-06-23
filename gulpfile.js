var gulp = require('gulp');

gulp.task("default", ["scripts", "styles", "images", "watch"], function() {
	// does nothing by itself
});

gulp.task("scripts", function () {
	gulp.src("source/scripts/*.coffee")
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

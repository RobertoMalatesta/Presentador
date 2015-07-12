var gulp = require('gulp');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var browserify = require('gulp-browserify');
var stylus = require('gulp-stylus');
var minify = require('gulp-minify-css');
var logarithmic = require('logarithmic');

gulp.task("default", ["coffee", "styles", "images"], function() {
    // does nothing by itself
});

gulp.task("coffee", function () {
    gulp.src("source/scripts/client.coffee")
        .pipe(coffee({bare: true}).on('error', logarithmic.error))
        .pipe(browserify({
            transform: ["coffeeify"],
            extensions: ['.coffee']
        }))
        .pipe(uglify())
        .pipe(gulp.dest("public/scripts"));
});

gulp.task("css", function() {
    gulp.src("source/styles/*.css")
        .pipe(minify())
        .pipe(gulp.dest("public/styles"));
});

gulp.task("stylus", function() {
    gulp.src("source/styles/*.styl")
        .pipe(stylus())
        .pipe(minify())
        .pipe(gulp.dest("public/styles"));
});

gulp.task("styles", ["stylus", "css"], function(){
    // let the other functions do the work
});

gulp.task("images", function() {
    gulp.src("source/images/*")
        .pipe(gulp.dest("public/images"));
});

gulp.task("watch", ["default"], function() {
    gulp.watch("source/scripts/*.coffee", ["coffee"]);
    gulp.watch("source/styles/*.styl", ["styles"]);
});

var gulp = require('gulp');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var browserify = require('gulp-browserify');
var stylus = require('gulp-stylus');
var minify = require('gulp-minify-css');
var logarithmic = require('logarithmic');

gulp.task("default", ["vendor", "mine", "images"]);

gulp.task("vendor", ["vendor-js", "vendor-css"]);

gulp.task("vendor-js", function() {
    gulp.src("source/scripts/*.js")
        .pipe(uglify())
        .pipe(gulp.dest("public/scripts"));
});

gulp.task("vendor-css", function() {
    gulp.src("source/styles/*.css")
        .pipe(minify())
        .pipe(gulp.dest("public/styles"));
});

gulp.task("mine", ["coffee", "stylus"]);

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

gulp.task("stylus", function() {
    gulp.src("source/styles/*.styl")
        .pipe(stylus())
        .pipe(minify())
        .pipe(gulp.dest("public/styles"));
});

gulp.task("images", function() {
    gulp.src("source/images/**/*")
        .pipe(gulp.dest("public/images"));
});

gulp.task("watch", ["default"], function() {
    gulp.watch("source/scripts/**/*.coffee", ["coffee"]);
    gulp.watch("source/styles/*.styl", ["stylus"]);

    gulp.watch("source/scripts/**/*.js", ["vendor-js"]);
    gulp.watch("source/styles/**/*.css", ["vendor-css"]);

    gulp.watch("source/images/**/*", ["images"]);
});

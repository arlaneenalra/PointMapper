gulp = require 'gulp'
gutil = require 'gulp-util'
merge = require 'merge-stream'

coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
gulpJade = require 'gulp-jade'
bowerRequire = require 'bower-requirejs'

sourcemaps = require 'gulp-sourcemaps'

jade = require 'jade'
del = require 'del'

source =
  coffee: [ 'src/**/*.coffee' ]
  js: [ 'src/**/*.js' ]
  html: [ 'src/**/*.jade' ]

target =
  public: 'build/objects'
  maps: 'maps'

# Clean Task
gulp.task 'clean', (cb) ->
  del [ 'build/' ], cb

# Build out RequireJS config from bower
gulp.task 'bower', (cb) ->
  options =
    baseUrl: 'src/'
    config: 'src/require.config.js'
    transitive: true

  bowerRequire options, (rjsConfig) ->
    cb()

# Build out scripts
gulp.task 'scripts', [ 'clean' ], () ->
  coffeePipe = gulp.src(source.coffee)
    .pipe(sourcemaps.init({ loadMaps: true}))
    .pipe(coffee()).on('error', gutil.log)
    .pipe(sourcemaps.write())


  merge(coffeePipe, gulp.src(source.js))
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(uglify())
    .pipe(concat('all.min.js'))
    .pipe(sourcemaps.write(target.maps))
    .pipe(gulp.dest(target.public))

# build out html
gulp.task 'html', [ 'clean' ], () ->
  jadeConfig =
    jade: jade
    pretty: true

  gulp.src(source.html)
    .pipe(gulpJade(jadeConfig))
    .pipe(gulp.dest(target.public))

# Setup watch
gulp.task 'watch', [ 'default' ], () ->
  gulp.watch [ 'src/**/*' ], [ 'default' ]

gulp.task 'default', [ 'scripts', 'html' ]


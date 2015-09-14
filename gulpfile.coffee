gulp = require 'gulp'
gutil = require 'gulp-util'
merge = require 'merge-stream'

coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
gulpIf = require 'gulp-if'
uglify = require 'gulp-uglify'
gulpJade = require 'gulp-jade'
bower = require 'gulp-bower'
bowerFiles = require 'gulp-main-bower-files'
wrapCommonJs  = require 'gulp-wrap-commonjs'

sourcemaps = require 'gulp-sourcemaps'

jade = require 'jade'
del = require 'del'

source =
  coffee: [ 'src/js/**/*.coffee' ]
  js: [ 'src/js/**/*.js' ]
  html: [ 'src/**/*.jade' ]
  assets: [ 'assets/**/*' ]

target =
  public: 'build/objects'
  assets: 'build/objects/assets'
  maps: 'maps'

# Clean Task
gulp.task 'clean', (cb) ->
  del [ 'build/' ], cb

# Build out RequireJS config from bower
gulp.task 'bower', (cb) ->
  bower()

# Build out scripts
gulp.task 'scripts', [ 'clean' ], () ->

  # Load bower files
  bowerPipe = gulp.src('./bower.json')
    .pipe(bowerFiles())

  # Compile Coffee script
  coffeePipe = gulp.src(source.coffee)
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(coffee()).on('error', gutil.log)
    .pipe(sourcemaps.write())

  commonWrapper = wrapCommonJs({
    pathModifier: (path) ->
      path.replace /^.*\/src\/js\//, ''
        .replace /^.*\/bower_components\//, ''
        .replace /\.js$/, ''
  })
  
  wrapMatcher = (file) ->
    pattern = /commonjs-require.*/
    !file.path.match(pattern)

  code = merge(coffeePipe, gulp.src(source.js))
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(gulpIf(wrapMatcher, commonWrapper))
    .pipe(sourcemaps.write())

  merge(bowerPipe, code)
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

# copy raw assets
gulp.task 'assets', [ 'clean' ], () ->
  gulp.src(source.assets)
    .pipe(gulp.dest(target.assets))


# Setup watch
gulp.task 'watch', [ 'default' ], () ->
  gulp.watch [ 'src/**/*', 'assets/**/*' ], [ 'default' ]

gulp.task 'default', [ 'scripts', 'html', 'assets' ]




{ src, dest, series } = require 'gulp'
coffee = require 'gulp-coffee'
del    = require 'del'

cp = ->
  src 'src/**/*.*'
    .pipe dest 'dist'

compile = (coffeeOp = {}) ->
  src 'coffee/*.coffee'
    .pipe coffee coffeeOp
    .pipe dest 'dist'

clean = (cb) -> del ['dist'], cb

build = series(
  clean
  compile
  cp
)

exports.src = cp

exports.coffee = compile

exports.default = build
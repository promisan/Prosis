/*
 * Copyright © 2025 Promisan B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
var express = require('express')
  , Chart = require('./chart')

var sendfile = function(filename, root) {
  return function(_, res) {
    res.sendfile(filename, { root: root })
  }
}

var jquery = sendfile('/jquery-1.6.2.min.js', __dirname)
  , peity = sendfile('/jquery.peity.js', __dirname + '/..')
  , style = sendfile('/style.css', __dirname)

var index = function(_, res) {
  res.render('index', {
    charts: Chart.all()
  })
}

var show = function(req, res) {
  var id = req.params.id
    , chart = Chart.find(id)

  if (chart) {
    res.render('show', {
      chart: chart
    })
  } else {
    res
      .status(404)
      .end()
  }
}

var app = express()
  .set('view engine', 'ejs')
  .set('views', __dirname + '/views')
  .get('/jquery.min.js', jquery)
  .get('/jquery.peity.js', peity)
  .get('/style.css', style)
  .get('/', index)
  .get('/:id', show)

module.exports = app

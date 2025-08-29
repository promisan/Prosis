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
var http = require('http')
  , mocha = require('mocha')
  , queue = require('queue-async')
  , app = require('./app')
  , server = http.createServer(app)
  , Chart = require('./chart')
  , assert = require('assert')
  , FUZZY = 7

describe('Peity', function() {
  before(function(done) {
    server.listen(0, function() {
      Chart.port(server.address().port)
      done()
    })
  })

  after(function() {
    server.close()
  })

  Chart.all().forEach(function(chart) {
    it(chart.id, function(done) {
      queue(1)
        .defer(chart.screenshot.bind(chart), chart.imagePath)
        .defer(chart.compare.bind(chart))
        .await(function(err, _, difference) {
          if (err) throw err
          assert.ok(difference <= FUZZY, 'unacceptable difference of ' + difference)
          done()
        })
    })
  })
})

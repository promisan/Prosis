/*
 * Copyright © 2025 Promisan
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
  , queue = require('queue-async')
  , app = require('./app')
  , server = http.createServer(app)
  , Chart = require('./chart')

server.listen(0, function() {
  Chart.port(server.address().port)

  var q = queue(4)

  Chart.all().forEach(function(chart) {
    q.defer(function(callback) {
      process.stdout.write('.')
      chart.screenshot(chart.fixturePath, callback)
    })
  })

  q.awaitAll(function(err) {
    if (err) throw err
    server.close()
    process.stdout.write("\n")
  })
})

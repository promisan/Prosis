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
var app = require('./app')
  , port = process.env.PORT || 8080

var logger = function(req, _, next) {
  console.log('%s %s', req.method, req.url)
  next()
}

app.stack.unshift({ route: '', handle: logger })

app.listen(port, function() {
  console.log('Listening on port %d', port)
})

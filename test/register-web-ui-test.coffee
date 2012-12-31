# register-web-ui-test.js
#
# Test that the home page shows an invitation to join
#
# Copyright 2012, StatusNet Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
assert = require("assert")
vows = require("vows")
oauthutil = require("./lib/oauth")
Browser = require("zombie")
Step = require("step")
setupApp = oauthutil.setupApp
setupAppConfig = oauthutil.setupAppConfig
suite = vows.describe("layout test")

# A batch to test some of the layout basics
suite.addBatch "When we set up the app":
  topic: ->
    setupAppConfig
      site: "Test"
    , @callback

  teardown: (app) ->
    app.close()  if app and app.close

  "it works": (err, app) ->
    assert.ifError err

  "and we visit the root URL":
    topic: ->
      browser = undefined
      browser = new Browser()
      browser.visit "http://localhost:4815/main/register", @callback

    "it works": (err, br) ->
      assert.ifError err
      assert.isTrue br.success

    "and we check the content":
      topic: (br) ->
        br

      "it includes a registration div": (br) ->
        assert.ok br.query("div.registration")

      "it includes a registration form": (br) ->
        assert.ok br.query("div.registration form")

      "the registration form has a nickname field": (br) ->
        assert.ok br.query("div.registration form input[name=\"nickname\"]")

      "the registration form has a password field": (br) ->
        assert.ok br.query("div.registration form input[name=\"password\"]")

      "the registration form has a password repeat field": (br) ->
        assert.ok br.query("div.registration form input[name=\"repeat\"]")

      "the registration form has a submit button": (br) ->
        assert.ok br.query("div.registration form button[type=\"submit\"]")

      "and we submit the form":
        topic: (br) ->
          callback = @callback
          Step (->
            br.fill "nickname", "sparks", this
          ), ((err, br) ->
            throw err  if err
            br.fill "password", "redplainsrider1", this
          ), ((err, br) ->
            throw err  if err
            br.fill "repeat", "redplainsrider1", this
          ), ((err, br) ->
            throw err  if err
            br.pressButton "button[type=\"submit\"]", this
          ), (err, br) ->
            if err
              callback err, null
            else
              callback null, br


        "it works": (err, br) ->
          assert.ifError err
          assert.isTrue br.success

suite["export"] module

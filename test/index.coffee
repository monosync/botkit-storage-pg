lib = require('../src/index')({})

assert = (result, name) ->
  if result
    console.log "\x1B[32m ✅ #{name} \x1B[0m"
  else
    err = new Error()
    console.error "\x1B[31m ❌ #{name} \x1B[0m"
    console.error err.stack
    process.exit 1

example = id: 'team0', token: 'team0'


lib.teams.save example, ->
  lib.teams.get example.id, (getValue) ->
    assert getValue.token == example.token, 'SAVE + GET'
    lib.teams.all (values) ->
      assert values[0].token == example.token, 'ALL'
      lib.teams.delete getValue.id, ->
        lib.teams.all (values) ->
          assert values.length == 0, 'DELETE'
          lib.end()

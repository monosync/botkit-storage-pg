{Pool} = require 'pg'

module.exports = ({url}) =>
  url = url || process.env.BOTKIT_STORAGE_PG_URL
  pool = new Pool connectionString: url

  query = (text, values) ->
    (await pool.query {text, values}).rows

  persisting = (table) ->

    get: (id, cb) ->
      rows = await query "SELECT json FROM #{table} WHERE id = $1", [id]
      cb rows[0].json

    save: (data, cb) ->
      await query "INSERT INTO #{table} (id, json) VALUES ($1, $2) ON CONFLICT (id) DO UPDATE SET json = EXCLUDED.json", [data.id, data]
      cb()

    delete: (id, cb) ->
      await query "DELETE FROM #{table} WHERE id = $1", [id]
      cb()

    all: (cb) ->
      rows = await query "SELECT json FROM #{table}"
      cb rows.map (r) -> r.json

  teams:      persisting 'botkit_teams'
  channels:   persisting 'botkit_channels'
  users:      persisting 'botkit_users'
  end: -> pool.end()

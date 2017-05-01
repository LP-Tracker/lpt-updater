request = require 'request'
path = require 'path'
decompress = require 'decompress'
fs = require 'fs'
util = require 'util'
# Download and extract the update
module.exports.downloadUpdate = (url, cb) ->
  util.log "Downloading update from: #{url}"
  request(url).on('error', (err) ->
    throw err
    ).pipe(fs.createWriteStream path.join __dirname, '../../../', 'update.zip')
    .on('finish', ->
      util.log "Finished downloading update, extracting..."
      decompress((path.join __dirname, '../../../', 'update.zip'), (path.join __dirname, '../../../', 'update/')).then(->
        util.log "Extract complete!"
        cb()
      ).catch((err)->
        throw err
      )
  )  
# Cleans up all update files, accepts a callback
module.exports.cleanUp = (cb) ->
  util.log "Cleaning up update"
  fs.rmdir (path.join __dirname, '../../../', 'update/'), (err) ->
    if err then throw err
    util.log "Deleted update folder"
    fs.unlink (path.join __dirname, '../../../', 'update.zip'), (err) ->
      if err then throw err
      util.log "Deleted update file"
      cb()

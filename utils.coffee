request = require 'request'
path = require 'path'
rimraf = require 'rimraf'
decompress = require 'decompress'
fs = require 'fs'
util = require 'util'
# Download and extract the update
module.exports.downloadUpdate = (url, cb) ->
  util.log "Downloading update from: #{url}"
  request({url: url, headers: {'User-Agent': 'request'}}).on('error', (err) ->
    throw err
    ).pipe(fs.createWriteStream path.join __dirname, '../../../', 'update.zip')
    .on('finish', ->
      util.log "Finished downloading update, extracting..."
      decompress((path.join __dirname, '../../../', 'update.zip'), (path.join __dirname, '../../../', 'update'), {
        map: (file) ->
          paths = file.path.split('/')
          paths.shift()
          file.path = path.join.apply null, paths
          return file
      }).catch((err) ->
        throw err
      ).then(->
        util.log "Extract complete!"
        cb()
      )
  )
# Cleans up all update files, accepts a callback
module.exports.cleanUp = (cb) ->
  util.log "Cleaning up update"
  rimraf (path.join __dirname, '../../../', 'update/'), (err) ->
    if err then throw err
    util.log "Deleted update folder"
    rimraf (path.join __dirname, '../../../', 'update.zip'), (err) ->
      if err then throw err
      util.log "Deleted update file"
      cb()

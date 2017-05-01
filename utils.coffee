request = require 'request'
path = require 'path'
unzip = require 'unzip'
fs = require 'fs'
util = require 'util'
# Download and extract the update
module.exports.downloadUpdate = (url, cb) ->
  util.log "Downloading update from: #{url}"
  request(url).on('error', (err) ->
    throw err
    ).pipe(fs.createWriteStream path.join '../../../', 'update.zip')
    .on('finish', ->
      util.log "Finished downloading update, extracting..."
      fs.createReadStream(path.join '../../../', 'update.zip')
      .pipe(unzip.Extract {path: path.join '../../../', 'update/'})
      .on 'finish', ->
        util.log "Extract complete!"
        cb()
      )
# Cleans up all update files, accepts a callback
module.exports.cleanUp = (cb) ->
  util.log "Cleaning up update"
  fs.rmdir (path.join '../../../', 'update/'), (err) ->
    if err then throw err
    util.log "Deleted update folder"
    fs.unlink (path.join '../../../', 'update.zip'), (err) ->
      if err then throw err
      util.log "Deleted update file"
      cb()

github = require 'octonode'
fs = require 'fs-extra'
pathExists = require 'path-exists'
rimraf = require 'rimraf'
utils = require './utils'
util = require 'util'
ncp = require 'ncp'
client = github.client()
path = require 'path'
mkdirp = require 'mkdirp'
module.exports.updateBootloader = (version) ->
  util.log "Updating Bootloader to Version: #{version}"
  client.get "/repos/LP-Tracker/lpt-bootloader/releases/tags/#{version}", {}, (err, status, body, headers) ->
    util.log "Download URL for update (#{body.zipball_url})! Downloading...."
    utils.downloadUpdate body.zipball_url, ->
      util.log "Download complete! Installing..."
      pathExists (path.join __dirname, "../../", 'bootloader', 'fallback'), (exists) ->
        if exists # The fallback folder already exists
          util.log "Fallback folder already exists, deleting...."
          rimraf (path.join __dirname, "../../", 'bootloader', 'fallback'), (err) ->
            if err
              throw err
            else
              util.log "Fallback folder deleted! Proceeding to update..."
              next()
        else
          util.log "Fallback folder doesn't exist, proceeding to update..."
          next()
      next = ->
        util.log "Copying 'latest' to 'fallback'..."
        ncp (path.join __dirname, "../../", 'bootloader', 'latest'), (path.join __dirname, "../../", 'bootloader', 'fallback'), (err) ->
          if err then throw err
          util.log "Copied old version to fallback folder! Deleting old version folder..."
          rimraf (path.join __dirname, "../../", 'bootloader', 'latest'), (err) ->
            if err then throw err
            util.log "Deleted! Copying over update...."
            ncp '../../../update/', (path.join __dirname, "../../", 'bootloader', 'latest'), (err) ->
              if err then throw err
              util.log "Copied! Cleaning up...."
              utils.cleanUp ->
                util.log "Cleaned up! Finished updating bootloader. Restarting the program..."
                app.relaunch()
                app.exit()

module.exports.updateUpdater = (version) ->
  client.get "/repos/LP-Tracker/lpt-updater/releases/tags/#{version}", {}, (err, status, body, headers) ->
    for asset in body.assets
      if asset.name is "update.zip"
        utils.downloadUpdate asset.browser_download_url, ->
          #
module.exports.updateApplication = (version) ->
  client.get "/repos/LP-Tracker/lpt-application/releases/tags/#{version}", {}, (err, status, body, headers) ->
    for asset in body.assets
      if asset.name is "update.zip"
        utils.downloadUpdate asset.browser_download_url, ->
          #

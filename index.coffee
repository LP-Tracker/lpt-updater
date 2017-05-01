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
app = (require 'electron').app
module.exports.updateBootloader = (version) ->
  util.log "Updating Bootloader to Version: #{version}"
  client.get "/repos/LP-Tracker/lpt-bootloader/releases/tags/#{version}", {}, (err, status, body, headers) ->
    util.log "Download URL for update (#{body.zipball_url})! Downloading...."
    utils.downloadUpdate body.zipball_url, ->
      util.log "Download complete! Installing..."
      pathExists((path.join __dirname, "../../", 'bootloader', 'fallback')).then (exists) ->
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
            ncp (path.join __dirname, '../../../update/'), (path.join __dirname, "../../", 'bootloader', 'latest'), (err) ->
              console.error err
              if err then throw err
              util.log "Copied! Cleaning up...."
              utils.cleanUp ->
                util.log "Cleaned up! Finished updating bootloader. Restarting the program..."
                app.relaunch()
                app.exit()

module.exports.updateUpdater = (version) ->
  util.log "Updating Updater to Version: #{version}"
  client.get "/repos/LP-Tracker/lpt-updater/releases/tags/#{version}", {}, (err, status, body, headers) ->
    util.log "Download URL for update (#{body.zipball_url})! Downloading...."
    utils.downloadUpdate body.zipball_url, ->
      util.log "Download complete! Installing..."
      pathExists((path.join __dirname, "../../", 'updater', 'fallback')).then (exists) ->
        if exists # The fallback folder already exists
          util.log "Fallback folder already exists, deleting...."
          rimraf (path.join __dirname, "../../", 'updater', 'fallback'), (err) ->
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
        ncp (path.join __dirname, "../../", 'updater', 'latest'), (path.join __dirname, "../../", 'updater', 'fallback'), (err) ->
          if err then throw err
          util.log "Copied old version to fallback folder! Deleting old version folder..."
          rimraf (path.join __dirname, "../../", 'updater', 'latest'), (err) ->
            if err then throw err
            util.log "Deleted! Copying over update...."
            ncp (path.join __dirname, '../../../update/'), (path.join __dirname, "../../", 'updater', 'latest'), (err) ->
              console.error err
              if err then throw err
              util.log "Copied! Cleaning up...."
              utils.cleanUp ->
                util.log "Cleaned up! Finished updating updater. Restarting the program..."
                app.relaunch()
                app.exit()
module.exports.updateApplication = (version) ->
  util.log "Updating Application to Version: #{version}"
  client.get "/repos/LP-Tracker/lpt-application/releases/tags/#{version}", {}, (err, status, body, headers) ->
    util.log "Download URL for update (#{body.zipball_url})! Downloading...."
    utils.downloadUpdate body.zipball_url, ->
      util.log "Download complete! Installing..."
      pathExists((path.join __dirname, "../../", 'application', 'fallback')).then (exists) ->
        if exists # The fallback folder already exists
          util.log "Fallback folder already exists, deleting...."
          rimraf (path.join __dirname, "../../", 'application', 'fallback'), (err) ->
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
        ncp (path.join __dirname, "../../", 'application', 'latest'), (path.join __dirname, "../../", 'application', 'fallback'), (err) ->
          if err then throw err
          util.log "Copied old version to fallback folder! Deleting old version folder..."
          rimraf (path.join __dirname, "../../", 'application', 'latest'), (err) ->
            if err then throw err
            util.log "Deleted! Copying over update...."
            ncp (path.join __dirname, '../../../update/'), (path.join __dirname, "../../", 'application', 'latest'), (err) ->
              console.error err
              if err then throw err
              util.log "Copied! Cleaning up...."
              utils.cleanUp ->
                util.log "Cleaned up! Finished updating bootloader. Restarting the program..."
                app.relaunch()
                app.exit()

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
    util.log "Got info on release for tag #{version}"
    for asset in body.assets
      if asset.name is "update.zip"
        util.log "Found download URL for update.zip: #{asset.browser_download_url} Downloading...."
        utils.downloadUpdate asset.browser_download_url, ->
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
    # Copy last release to fallback folder
    util.log "Copying old version to fallback folder..."
    ncp (path.join __dirname, "../../", 'bootloader', 'latest'), (path.join __dirname, "../../", 'bootloader', 'fallback'), (err) ->
      if err then throw err
      # Read updates
      util.log "Copying complete! Reading update manifest..."
      fs.readFile '../../../update/manifest.json', (err, file) ->
        if err then throw err
        file = JSON.parse file
        util.log "Parsed manifest! Looping through changes..."
        bootloaderFolder = path.join __dirname, "../../", 'bootloader', 'latest'
        updateFolder = '../../../update/'
        for change in file
          # Make changes
          if change.status is "added"
            # Check to see if the path exists
            pathExists (path.join bootloaderFolder, (path.dirname change.destination)), (exists) ->
              if exists # The path we are trying to copy to exists
                ncp (path.join updateFolder, change.source), (path.join bootloaderFolder, change.destination), (err) ->
                  if err then throw err
              else # We've got to create the directory up to that point
                mkdirp (path.join bootloaderFolder, (path.dirname change.destination)), (err) ->
                  if err then throw err
                  ncp (path.join updateFolder, change.source), (path.join bootloaderFolder, change.destination), (err) ->
                    if err then throw err
          else if change.status is "modified"
            ncp (path.join updateFolder, change.source), (path.join bootloaderFolder, change.destination), (err) ->
              if err then throw err
          else if change.status is "deleted"
            rimraf (path.join bootloaderFolder, change.destination), (err) ->
              if err then throw err
        util.log "Finished applying #{file.length} updates! Cleaning up..."
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

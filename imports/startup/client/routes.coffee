{ FlowRouter } = require 'meteor/kadira:flow-router'
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'

# Import to load these templates
require '/imports/ui/layouts/app-body.coffee'
require '/imports/ui/pages/root-redirector.js'
require '/imports/ui/pages/notes-show-page.coffee'
require '/imports/ui/pages/app-not-found.coffee'
require '/imports/ui/pages/import/import.coffee'
require '/imports/ui/pages/calendar/calendar.coffee'
require '/imports/ui/pages/kanban/kanban.coffee'
require '/imports/ui/pages/settings/settings.coffee'
# Import to override accounts templates
require '/imports/ui/accounts/accounts-templates.js'

FlowRouter.route '/',
  name: 'App.home'
  action: ->
    NProgress.start()
    Session.set 'searchTerm', null
    BlazeLayout.render 'App_body', main: 'Notes_show_page'

FlowRouter.route '/note/:noteId',
  name: 'Notes.show'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'Notes_show_page'

FlowRouter.route '/note/:noteId/:shareKey',
  name: 'Notes.showShared'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'Notes_show_page'

FlowRouter.route '/calendar',
  name: 'Notes.calendar'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'Notes_calendar'

FlowRouter.route '/calendar/:noteId',
  name: 'Notes.calendar'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'Notes_calendar'

FlowRouter.route '/kanban',
  name: 'Notes.kanban'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'Notes_kanban'

FlowRouter.route '/kanban/:noteId',
  name: 'Notes.kanban'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'Notes_kanban'

FlowRouter.route '/import',
  name: 'Notes.import'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'Notes_import'

FlowRouter.route '/settings',
  name: 'App.settings'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'App_settings'

FlowRouter.route '/search/:searchTerm',
  name: 'App.search'
  action: ->
    NProgress.start()
    BlazeLayout.render 'App_body', main: 'Notes_show_page'

# FlowRouter.route '/calendar',
#   name: 'App.calendar'
#   action: ->
#     BlazeLayout.render 'App_body', main: 'App_calendar'

# FlowRouter.route '/calendar/:noteId',
#   name: 'App.calendar'
#   action: ->
#     BlazeLayout.render 'App_body', main: 'App_calendar'

FlowRouter.route '/dropboxAuth',
  name: 'App.dropboxAuth'
  action: ->
    parseQueryString = (str) ->
      ret = Object.create(null)
      if typeof str != 'string'
        return ret
      str = str.trim().replace(/^(\?|#|&)/, '')
      if !str
        return ret
      str.split('&').forEach (param) ->
        parts = param.replace(/\+/g, ' ').split('=')
        # Firefox (pre 40) decodes `%3D` to `=`
        # https://github.com/sindresorhus/query-string/pull/37
        key = parts.shift()
        val = if parts.length > 0 then parts.join('=') else undefined
        key = decodeURIComponent(key)
        # missing `=` should be `null`:
        # http://w3.org/TR/2012/WD-url-20120524/#collect-url-parameters
        val = if val == undefined then null else decodeURIComponent(val)
        if ret[key] == undefined
          ret[key] = val
        else if Array.isArray(ret[key])
          ret[key].push val
        else
          ret[key] = [
            ret[key]
            val
          ]
        return
      ret

    Meteor.call 'users.setDropboxOauth',
      parseQueryString(window.location.hash)['access_token']
    FlowRouter.redirect '/'

FlowRouter.notFound =
  action: ->
    BlazeLayout.render('App_body', { main: 'App_notFound' })

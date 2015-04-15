@EventModel = Backbone.Model.extend
  urlRoot: '/events'
  fields: ['id', 'title', 'since', 'periodicity']
  dateFormat: "YYYY-MM-DD"

  constructor: (options)->
    Backbone.Model.call @, @_prepare(options)

  _prepare: (data)->
    data = _.pick data, @fields
    data.since = data.since.format(@dateFormat) unless _(data.since).isString()
    data
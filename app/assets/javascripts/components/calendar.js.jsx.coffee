@Calendar = React.createClass

  propTypes:
    onSelect: React.PropTypes.func.isRequired
    onEventClick: React.PropTypes.func.isRequired
    url: React.PropTypes.string.isRequired

  getInitialState: ->
    url: @props.url

  componentDidMount: ->
    @$el().fullCalendar
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'month,basicWeek,basicDay'

      events: @state.url

      selectable: true
      select: @props.onSelect
      eventClick: @props.onEventClick

      eventLimit: true
      allDayDefault: true
      firstDay: 1

  shouldComponentUpdate: ->
    false

  render: ->
    `<div ref="el" />`

  $el: ->
    $ @refs.el.getDOMNode()

  refetchEvents: ->
    @$el().fullCalendar 'refetchEvents'
    @

  changeUrl: (url)->
    @$el().fullCalendar('removeEventSource', @state.url)
    @$el().fullCalendar('addEventSource', url)

    @setState url: url
    @

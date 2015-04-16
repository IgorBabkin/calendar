@DatePicker = React.createClass

  componentDidMount: ->
    @$el().datepicker(@props).on 'changeDate', @props.onChange

  componentWillUnmount: ->
    @$el().datepicker 'remove'

  $el: ->
    $ @refs.el.getDOMNode()

  render: ->
    {name, value} = @props
    `<input required ref="el" name={name} defaultValue={value} type='text' className="form-control" />`
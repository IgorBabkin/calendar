@EventForm = React.createClass

  propTypes:
    onSave: React.PropTypes.func.isRequired
    data: React.PropTypes.object.isRequired

  getInitialState: ->
    data: @props.data

  componentDidMount: ->
    $form = $ @refs.form.getDOMNode()
    $form.validate submitHandler: @onSubmit

  onSubmit: ->
    @props.onSave? @state.data
    false

  changeField: (e)->
    { name, value } = e.target
    data = _.tap @state.data, (data)-> data[name] = value
    @setState data: data

  render: ->
    { id, since, title, periodicity } = @state.data

    `<form ref="form" id="eventForm">
        <input type="hidden" name="id" value={id} readOnly />
        <div className="form-group">
        <label>Since</label>
              <DatePicker autoclose={true} weekStart={1} name="since" value={since} onChange={this.changeField} format="yyyy-mm-dd" />
        </div>
        <div className="form-group">
            <label htmlFor="title">Title</label>
            <input value={title} onChange={this.changeField} className="form-control" id="title" type="text" name="title" autofocus="true" placeholder="Enter title here..." required />
        </div>
        <div className="form-group">
            <label htmlFor="periodicity">Periodicity</label>
            <select id="periodicity" name="periodicity" className="form-control" value={periodicity} onChange={this.changeField}>
                <option value="once">Once</option>
                <option value="daily">Daily</option>
                <option value="weekly">Weekly</option>
                <option value="monthly">Monthly</option>
                <option value="yearly">Yearly</option>
            </select>
        </div>
    </form>`
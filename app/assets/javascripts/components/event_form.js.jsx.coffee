@EventForm = React.createClass

  propTypes:
    onSave: React.PropTypes.func.isRequired

  getInitialState: ->
    model: @props.model

  componentDidMount: ->
    $form = $ @refs.form.getDOMNode()
    $form.validate submitHandler: @onSubmit

  onSubmit: ->
    @state.model.save().success @props.onSave
    false

  changeField: (e)->
    [model, { name, value }] = [@state.model, e.target]
    @setState model: model.set(name, value)

  render: ->
    model = @state.model

    `<form ref="form" id="eventForm">
        <input type="hidden" name="id" value={model.id} readOnly />
        {this.renderSinceField()}
        <div className="form-group">
            <label htmlFor="title">Title</label>
            <input value={model.get('title')} onChange={this.changeField} className="form-control" id="title" type="text" name="title" autofocus="true" placeholder="Enter title here..." required />
        </div>
        <div className="form-group">
            <label htmlFor="periodicity">Periodicity</label>
            <select id="periodicity" name="periodicity" className="form-control" value={model.get('periodicity')} onChange={this.changeField}>
                <option value="once">Once</option>
                <option value="daily">Daily</option>
                <option value="weekly">Weekly</option>
                <option value="monthly">Monthly</option>
                <option value="yearly">Yearly</option>
            </select>
        </div>
    </form>`

  renderSinceField: ->
    model = @state.model

    if model.isNew()
      `<input type="hidden" name="since" value={model.get('since')} readOnly />`
    else
      `<div className="form-group">
          <label>Since</label>
          <DatePicker autoclose={true} name="since" value={model.get('since')} onChange={this.changeField} format="yyyy-mm-dd" />
      </div>`

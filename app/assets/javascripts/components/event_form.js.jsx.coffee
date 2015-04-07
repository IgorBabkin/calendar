@EventForm = React.createClass

  propTypes:
    onSubmit: React.PropTypes.func.isRequired

  componentDidMount: ->
    $form = $ @refs.form.getDOMNode()
    $form.submit @props.onSubmit

  render: ->
    `<form ref="form" id="eventForm">
        <input type="hidden" name="id" />
        <div className="form-group">
            <label htmlFor="title">Title</label>
            <input className="form-control" id="title" type="text" name="title" autofocus="true" placeholder="Enter title here..." required />
        </div>
        <div className="form-group">
            <label htmlFor="periodicity">Periodicity</label>
            <select id="periodicity" name="periodicity" className="form-control">
                <option value="once">Once</option>
                <option value="daily">Daily</option>
                <option value="weekly">Weekly</option>
                <option value="monthly">Monthly</option>
                <option value="yearly">Yearly</option>
            </select>
        </div>
    </form>`

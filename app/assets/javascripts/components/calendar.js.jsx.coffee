@Button = ReactBootstrap.Button
@Modal = ReactBootstrap.Modal

@Calendar = React.createClass
  mixins: [ReactBootstrap.OverlayMixin]

  getInitialState: ->
    isModalOpen: false

  componentDidMount: ->
    $calendar = $ @refs.calendar.getDOMNode()
    $calendar.fullCalendar
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'month,basicWeek,basicDay'

      events: '/events'

      selectable: true
      select: @newEvent
      eventClick: @editEvent

      eventLimit: true
      allDayDefault: true
      firstDay: 1

  newEvent: (start)->
    @openModal event

  editEvent: (event)->
    @openModal event

  openModal: (event)->
    @setState isModalOpen: true

  closeModal: ->
    @setState isModalOpen: false

  submit: ->
    $("#eventForm").submit()

  onSubmit: (e)->
    alert 'SUM'

  render: ->
    `<div ref="calendar"></div>`

  renderOverlay: ->
    return null unless @state.isModalOpen

    `<Modal
        title='Event'
        bsStyle='primary'
        onRequestHide={this.closeModal}>
        <div className='modal-body'>
            <EventForm onSubmit={this.onSubmit} />
        </div>
        <div className='modal-footer'>
            <Button onClick={this.closeModal}>Close</Button>
            <Button onClick={this.submit} bsStyle='primary'>Save changes</Button>
        </div>
    </Modal>`
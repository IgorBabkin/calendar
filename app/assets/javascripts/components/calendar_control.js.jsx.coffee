@Button = ReactBootstrap.Button
@Modal = ReactBootstrap.Modal

@CalendarControl = React.createClass
  mixins: [ReactBootstrap.OverlayMixin]

  getInitialState: ->
    isModalOpen: false
    eventModel: null

  getDefaultProps: ->
    eventsUrl: '/events.json'

  newEvent: (start)->
    @openModal since: start

  editEvent: (eventData)->
    @openModal eventData

  openModal: (eventData)->
    @setState
      isModalOpen: true
      eventModel: new EventModel(eventData)

  closeModal: ->
    @setState isModalOpen: false

  submitEventForm: ->
    $("#eventForm").submit()

  updateCalendar: ->
    @refs.calendar.refetchEvents()
    @closeModal()

  destroyEvent: ->
    @state.eventModel.destroy().success @updateCalendar()

  saveEvent: ->
    @state.eventModel.save().success @updateCalendar()

  changeCalendarUrl: (url)->
    @refs.calendar.changeUrl url

  render: ->
    `<div>
        <UrlFilter url={this.props.eventsUrl} onChange={this.changeCalendarUrl} />
        <Calendar ref="calendar" url={this.props.eventsUrl} onSelect={this.newEvent} onEventClick={this.editEvent} />
    </div>`

  renderOverlay: ->
    { isModalOpen, eventModel } = @state
    return null unless isModalOpen

    deleteButton = `<Button className="btn-danger" onClick={this.destroyEvent}>Delete</Button>`

    `<Modal
        title={ eventModel.isNew() ? 'New event' : 'Edit event' }
        bsStyle='primary'
        onRequestHide={ this.closeModal }>
        <div className='modal-body'>
            <EventForm model={ eventModel } onSave={ this.saveEvent } />
        </div>
        <div className='modal-footer'>
            <Button onClick={ this.closeModal }>Close</Button>
            { eventModel.isNew() ? null : deleteButton }
            <Button onClick={ this.submitEventForm } bsStyle='primary'>Save changes</Button>
        </div>
    </Modal>`
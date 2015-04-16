@Button = ReactBootstrap.Button
@Modal = ReactBootstrap.Modal

@CalendarControl = React.createClass
  mixins: [ReactBootstrap.OverlayMixin]

  getInitialState: ->
    isModalOpen: false
    eventModel: null

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

  render: ->
    `<Calendar ref="calendar" onSelect={this.newEvent} onEventClick={this.editEvent} />`

  renderOverlay: ->
    { isModalOpen, eventModel } = @state
    return null unless isModalOpen

    deleteButton = `<Button className="btn-danger" onClick={ this.destroyEvent }>Delete</Button>`

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
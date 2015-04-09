@Button = ReactBootstrap.Button
@Modal = ReactBootstrap.Modal

@CalendarModal = React.createClass
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

  submit: ->
    $("#eventForm").submit()

  render: ->
    `<Calendar ref="calendar" onSelect={this.newEvent} onEventClick={this.editEvent} />`

  updateView: ->
    @refs.calendar.refetchEvents()
    @closeModal()

  destroy: ->
    @state.eventModel.destroy().success @updateView()

  renderOverlay: ->
    return null unless @state.isModalOpen
    title = if @state.eventModel.isNew() then 'New event' else 'Edit event'

    `<Modal
        title={title}
        bsStyle='primary'
        onRequestHide={this.closeModal}>
        <div className='modal-body'>
            <EventForm model={this.state.eventModel} onSave={this.updateView} />
        </div>
        <div className='modal-footer'>
            <Button onClick={this.closeModal}>Close</Button>
            <Button className="btn-danger" onClick={this.destroy}>Delete</Button>
            <Button onClick={this.submit} bsStyle='primary'>Save changes</Button>
        </div>
    </Modal>`
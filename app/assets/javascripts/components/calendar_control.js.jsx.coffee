@Button = ReactBootstrap.Button
@Modal = ReactBootstrap.Modal

@CalendarControl = React.createClass
  mixins: [ReactBootstrap.OverlayMixin]

  dateFormat: "YYYY-MM-DD"

  getInitialState: ->
    isModalOpen: false
    eventModel: null

  getDefaultProps: ->
    eventsUrl: '/events.json'

  onSelectEvent: (date)->
    attrs = since: date.format(@dateFormat)
    @createModel(attrs).then @openModal

  onEventClick: (data)->
    attrs = _.pick(data, 'id')
    @createModel(attrs).then @openModal

  createModel: (data)->
    model = new EventModel(data)
    new Promise (resolve)->
      return resolve(model) if model.isNew()
      model.fetch().success -> resolve(model)

  openModal: (model)->
    @setState
      isModalOpen: true
      eventModel: model

  closeModal: ->
    @setState isModalOpen: false

  submitEventForm: ->
    $("#eventForm").submit()

  updateCalendar: ->
    @refs.calendar.refetchEvents()
    @closeModal()

  destroyEvent: ->
    @state.eventModel.destroy().success @updateCalendar()

  saveEvent: (data)->
    model = @state.eventModel
    model.on 'sync', @updateCalendar
    model.save(data)

  changeCalendarUrl: (url)->
    @refs.calendar.changeUrl url

  render: ->
    `<div>
        <UrlFilter url={this.props.eventsUrl} onChange={this.changeCalendarUrl} />
        <Calendar ref="calendar" url={this.props.eventsUrl} onSelect={this.onSelectEvent} onEventClick={this.onEventClick} />
    </div>`

  renderOverlay: ->
    { isModalOpen, eventModel } = @state
    return null unless isModalOpen

    deleteButton = `<Button className="btn-danger" onClick={this.destroyEvent}>Delete</Button>`

    `<Modal
        title={ eventModel.isNew() ? 'New event' : 'Event' }
        bsStyle='primary'
        onRequestHide={ this.closeModal }>
        <div className='modal-body'>
            <EventForm data={ eventModel.toJSON() } onSave={ this.saveEvent } />
        </div>
        <div className='modal-footer'>
            <Button onClick={ this.closeModal }>Close</Button>
            { eventModel.isNew() ? null : deleteButton }
            <Button onClick={ this.submitEventForm } bsStyle='primary'>Save changes</Button>
        </div>
    </Modal>`
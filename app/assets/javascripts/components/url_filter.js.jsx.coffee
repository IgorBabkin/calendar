@UrlFilter = React.createClass

  propTypes:
    onChange: React.PropTypes.func.isRequired
    url: React.PropTypes.string.isRequired

  filter: (e)->
    [url, {name, value, checked}] = [URI(@props.url), e.target]
    @props.onChange? if checked
      url.addSearch(name, value).toString()
    else
      url.removeSearch(name).toString()

  render: ->
    `<label>
        <input type="checkbox" name="all" onChange={this.filter} />
        Show only mine
    </label>`
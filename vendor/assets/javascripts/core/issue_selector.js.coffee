class window.IssueSelector
  constructor: (options = {}) ->
    @issues = {}

    @cacheElements(options)
    @bindHandlers()

    @ready = $.Deferred()

    @setIssueOptions().done =>
      @setDefautlOption(options.default_option)
      @ready.resolve()

  cacheElements: (options) ->
    @$issue_selector = $('.js-issue-selector')
    @$year_selector = $('.js-year-selector')
    @$month_selector = $('.js-month-selector')
    @$date_field = $('.js-date-field')

  bindHandlers: ->
    @$year_selector.on 'change', @setIssueOptions
    @$month_selector.on 'change', @setIssueOptions
    @$issue_selector.on 'change', @setDate

  setIssueOptions: (e) =>
    @getData().done =>
      @render @issues[@date()]
      @$issue_selector.trigger('change')

  setDate: =>
    if @$issue_selector.val() == ""
      @$date_field.prop('disabled', false)
      @$date_field.val ""
    else
      @$date_field.prop('disabled', true)
      for issue in  @issues[@date()] when issue.id == parseInt @$issue_selector.val()
        return @$date_field.val issue.date

  getData: ->
    if @issues[@date()]
      $.Deferred().resolve()
    else
      $.ajax
        url:  "/api/issues?year=#{@year()}&month=#{@month()}"
        type: 'get'
      .done (data) =>
        @issues[@date()] = data

  render: (data) ->
    data = data.map (issue) -> {id: issue.id, name: issue.number}
    template_data = { promp: 'Select an issue', options: data }
    @$issue_selector.html HandlebarsTemplates['options'](template_data)

  year: ->
    @$year_selector.val()
  month: ->
    @$month_selector.val()
  date: ->
    "#{@year()}-#{@month()}"

  setDefautlOption: (default_option) ->
    if default_option
      @$issue_selector.find("option[value=#{default_option}]").prop('selected', 'selected')
      @setDate()

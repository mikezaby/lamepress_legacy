class window.CategorySelector
  constructor: (options = {}) ->
    @category_options = {}

    @cacheElements(options)
    @bindHandlers()

    @previus_issue = null

    @setCategoryOptions().done =>
      @setDefautlOption(options.default_option)

  cacheElements: (options) ->
    @$category_selector = options.$category_selector || $('.js-category-selector')
    @$issue_selector = options.$issue_selector || $('.js-issue-selector')

  bindHandlers: ->
    @$issue_selector.on 'change', @setCategoryOptions

  setCategoryOptions: (e) =>
    issue = if @$issue_selector.val() == "" then 'false' else 'true'

    promise = if @category_options[issue]
      $.Deferred().resolve()
    else
      $.ajax
        url:  "/api/categories?issued=#{issue}"
        type: 'get'
      .done (data) =>
        template_data = { promp: 'Select a cagegory', options: data }
        @category_options[issue] = HandlebarsTemplates['options'](template_data)

    promise.done =>
      if @previus_issue != issue then @$category_selector.html @category_options[issue]
      @previus_issue = issue

  setDefautlOption: (default_option) ->
    @$category_selector.find("option[value=#{default_option}]").prop('selected', 'selected') if default_option

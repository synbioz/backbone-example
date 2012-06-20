@app = window.app ? {}

String.prototype.isBlank = ->
  /^\s*$/.test(this)

$(document).ready ->
  @app = window.app ? {}

  _.templateSettings = {
      interpolate: /\{\{\=(.+?)\}\}/g,
      evaluate: /\{\{(.+?)\}\}/g
  };

  # Model
  class Category extends Backbone.Model
    validate: (attributes) ->
      mergedAttributes = _.extend(_.clone(@attributes), attributes)
      if !mergedAttributes.category.name or mergedAttributes.category.name.isBlank()
        return "Name can't be blank."

  @app.Category = Category

  # Collection
  class Categories extends Backbone.Collection
    url: "/categories"
    model: app.Category
  @app.Categories = Categories

  # View
  class CategoryView extends Backbone.View
    tagName: 'li'
    template: _.template($('#category').html())

    initialize: ->
      _.bindAll(@, 'render')

    render: ->
      json =  @model.toJSON()
      json.name = json.category.name if json.category

      $(@el).html @template(json)
      @
  @app.CategoryView = CategoryView

  class NewCategoryView extends Backbone.View
    tagName: 'form'
    template: _.template($('#new_category').html())
    events:
      'keypress #category_name': 'saveNewCategoryIfSubmit'
      'click #save-new-category': 'saveNewCategory'
      'focusout #category_name': 'emptyMessages'

    initialize: (options) ->
      _.bindAll(@, 'render')
      @collection.bind 'reset', @render

    render: ->
      $(@el).html @template()
      @

    saveNewCategory: ->
      attributes = { category: { name: $("#category_name").val() } }
      @collection.create(attributes, { error: @showErrors })

    saveNewCategoryIfSubmit: (event) =>
      if event.keyCode is 13
        event.preventDefault()
        @saveNewCategory()

    emptyMessages: ->
      $("#messages").empty()

    showErrors: (model, errors) =>
      content = errors.responseText || errors
      @emptyMessages()
      $("#messages").html(content)

  @app.NewCategoryView = NewCategoryView

  class CategoriesView extends Backbone.View
    tagName: 'ul'
    template: _.template($('#categories').html())

    initialize: ->
      _.bindAll(@, 'render')
      @collection.bind 'reset', @render
      @collection.bind 'add', @render

    render: ->
      $(@el).html(@template())
      node = @.$('.categories')
      collection = @collection
      @collection.each (category) ->
        view = new CategoryView
          model: category
          collection: collection
        node.append view.render().el
      @
  @app.CategoriesView = CategoriesView

  # Router
  class MetricsRouter extends Backbone.Router
    routes:
      '': 'dashboard'

    initialize: ->
      window.categories = new app.Categories()
      @categoriesView = new app.CategoriesView
        collection: categories

      @newCategoryView = new app.NewCategoryView
        collection: categories

    dashboard: ->
      window.categories.fetch()
      $("#container").html(@categoriesView.el);
      $("#add_category").html(@newCategoryView.el);

  @app.MetricsRouter = new MetricsRouter()

  Backbone.history.start()
  console.log "Fine."
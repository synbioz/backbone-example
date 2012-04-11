@app = window.app ? {}
$(document).ready ->
  @app = window.app ? {}

  _.templateSettings = {
      interpolate: /\{\{\=(.+?)\}\}/g,
      evaluate: /\{\{(.+?)\}\}/g
  };

  # Model
  class Category extends Backbone.Model

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
      $(@el).html @template(@model.toJSON())
      @
  @app.CategoryView = CategoryView

  class CategoriesView extends Backbone.View
    tagName: 'ul'
    template: _.template($('#categories').html())

    initialize: ->
      _.bindAll(@, 'render')
      @collection.bind 'reset', @render

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

    dashboard: ->
      window.categories.fetch()
      $("#container").html(@categoriesView.el);

  @app.MetricsRouter = new MetricsRouter()

  Backbone.history.start()
  console.log "Fine."
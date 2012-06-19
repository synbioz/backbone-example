(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.app = (_ref = window.app) != null ? _ref : {};

  $(document).ready(function() {
    var Categories, CategoriesView, Category, CategoryView, MetricsRouter, NewCategoryView, _ref1;
    this.app = (_ref1 = window.app) != null ? _ref1 : {};
    _.templateSettings = {
      interpolate: /\{\{\=(.+?)\}\}/g,
      evaluate: /\{\{(.+?)\}\}/g
    };
    Category = (function(_super) {

      __extends(Category, _super);

      Category.name = 'Category';

      function Category() {
        return Category.__super__.constructor.apply(this, arguments);
      }

      return Category;

    })(Backbone.Model);
    this.app.Category = Category;
    Categories = (function(_super) {

      __extends(Categories, _super);

      Categories.name = 'Categories';

      function Categories() {
        return Categories.__super__.constructor.apply(this, arguments);
      }

      Categories.prototype.url = "/categories";

      Categories.prototype.model = app.Category;

      return Categories;

    })(Backbone.Collection);
    this.app.Categories = Categories;
    CategoryView = (function(_super) {

      __extends(CategoryView, _super);

      CategoryView.name = 'CategoryView';

      function CategoryView() {
        return CategoryView.__super__.constructor.apply(this, arguments);
      }

      CategoryView.prototype.tagName = 'li';

      CategoryView.prototype.template = _.template($('#category').html());

      CategoryView.prototype.initialize = function() {
        return _.bindAll(this, 'render');
      };

      CategoryView.prototype.render = function() {
        $(this.el).html(this.template(this.model.toJSON()));
        return this;
      };

      return CategoryView;

    })(Backbone.View);
    this.app.CategoryView = CategoryView;
    NewCategoryView = (function(_super) {

      __extends(NewCategoryView, _super);

      NewCategoryView.name = 'NewCategoryView';

      function NewCategoryView() {
        return NewCategoryView.__super__.constructor.apply(this, arguments);
      }

      NewCategoryView.prototype.tagName = 'form';

      NewCategoryView.prototype.template = _.template($('#new_category').html());

      NewCategoryView.prototype.events = {
        'keypress #category_name': 'saveNewCategoryIfSubmit',
        'click #save-new-category': 'saveNewCategory',
        'focusout #category_name': 'emptyMessages'
      };

      NewCategoryView.prototype.initialize = function() {
        _.bindAll(this, 'render');
        return this.collection.bind('reset', this.render);
      };

      NewCategoryView.prototype.render = function() {
        $(this.el).html(this.template());
        return this;
      };

      NewCategoryView.prototype.saveNewCategoryIfSubmit = function(event) {
        if (event.keyCode === 13) {
          event.preventDefault();
          return saveNewCategory();
        }
      };

      NewCategoryView.prototype.saveNewCategory = function() {
        var attributes;
        attributes = {
          category: {
            name: $("#category_name").val()
          }
        };
        return this.collection.create(attributes, {
          error: this.showErrors
        });
      };

      NewCategoryView.prototype.emptyMessages = function() {
        return $("#messages").empty();
      };

      NewCategoryView.prototype.showErrors = function(model, errors) {
        this.emptyMessages();
        return $("#messages").html(errors.responseText);
      };

      return NewCategoryView;

    })(Backbone.View);
    this.app.NewCategoryView = NewCategoryView;
    CategoriesView = (function(_super) {

      __extends(CategoriesView, _super);

      CategoriesView.name = 'CategoriesView';

      function CategoriesView() {
        return CategoriesView.__super__.constructor.apply(this, arguments);
      }

      CategoriesView.prototype.tagName = 'ul';

      CategoriesView.prototype.template = _.template($('#categories').html());

      CategoriesView.prototype.initialize = function() {
        _.bindAll(this, 'render');
        return this.collection.bind('reset', this.render);
      };

      CategoriesView.prototype.render = function() {
        var collection, node;
        $(this.el).html(this.template());
        node = this.$('.categories');
        collection = this.collection;
        this.collection.each(function(category) {
          var view;
          view = new CategoryView({
            model: category,
            collection: collection
          });
          return node.append(view.render().el);
        });
        return this;
      };

      return CategoriesView;

    })(Backbone.View);
    this.app.CategoriesView = CategoriesView;
    MetricsRouter = (function(_super) {

      __extends(MetricsRouter, _super);

      MetricsRouter.name = 'MetricsRouter';

      function MetricsRouter() {
        return MetricsRouter.__super__.constructor.apply(this, arguments);
      }

      MetricsRouter.prototype.routes = {
        '': 'dashboard'
      };

      MetricsRouter.prototype.initialize = function() {
        window.categories = new app.Categories();
        this.categoriesView = new app.CategoriesView({
          collection: categories
        });
        return this.newCategoryView = new app.NewCategoryView({
          collection: categories
        });
      };

      MetricsRouter.prototype.dashboard = function() {
        window.categories.fetch();
        $("#container").html(this.categoriesView.el);
        return $("#add_category").html(this.newCategoryView.el);
      };

      return MetricsRouter;

    })(Backbone.Router);
    this.app.MetricsRouter = new MetricsRouter();
    Backbone.history.start();
    return console.log("Fine.");
  });

}).call(this);

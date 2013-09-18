angular.module('CodeNamer', [])

.factory('Categories', function () {
  var res = {};
  var cats = {};

  res.capitalise = function (string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  };

  res.pickRandom = function (array) {
    return array[Math.floor(Math.random() * array.length)]
  };

  res.pickRandomFromCategory = function (category_name) {
    var section, values;
    if (category_name.values && category_name.values.length) {
      values = category_name.values;
    } else {
      section = cats[category_name];
      if (!section) return console.error(category_name, 'is not a category key.');

      values = section.values;
      if (!values) return console.error(values, 'is not a list of values.', 'Does', section, 'exist?');
    }

    return res.pickRandom(values);
  };

  cats = window.categories;

  return {methods: res, categories: cats};
})

.controller('codename', function ($scope, Categories) {
  // Scope vars
  $scope.categories = Categories.categories;
  $scope.name_parts = [];
  $scope.final_name = '';

  // Scope methods
  $scope.newName = function (name_parts) {
    if (!name_parts || !name_parts.length) {
      return console.error(name_parts, 'is not a list of name parts');
    }
    return name_parts
      .map(Categories.methods.pickRandomFromCategory)
      .join(" ").split(" ")
      .map(Categories.methods.capitalise)
      .join(" ");
  };

  // init: random name
  $scope.initial_selection = (function (array) {
    var l = [];
    var _p;
    for (var i = 0; i < 3; i++) {
      _p = Categories.methods.pickRandom(Object.keys(Categories.categories));
      l[i] = Categories.categories[_p];
      $scope.name_parts[i] = Categories.categories[_p];
    };
    return l;
  })(Categories.categories);

  // generate a name
  var generateName = function () {
    $scope.final_name = $scope.newName($scope.name_parts);
  };

  $scope.$watch($scope.name_parts, generateName);
  generateName();
})

;
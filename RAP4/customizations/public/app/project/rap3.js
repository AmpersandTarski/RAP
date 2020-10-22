angular.module('AmpersandApp')
.config(['$routeProvider', function ($routeProvider) {
    $routeProvider
        .when('/page/home',
            {
                templateUrl: 'app/project/home.html',
            });
}]).requires.push('ui.ace');

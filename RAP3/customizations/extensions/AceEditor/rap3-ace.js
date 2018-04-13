var app = angular.module('AmpersandApp');
app.requires[app.requires.length] = 'ui.ace';
app.directive("fileread", [function () {
    return {
        scope: {
            fileread: "="
        },
        link: function (scope, element, attributes) {
            element.bind("change", function (changeEvent) {
                var reader = new FileReader();
                reader.onload = function (loadEvent) {
                    scope.$apply(function () {
                        scope.fileread = loadEvent.target.result;
                    });
                }
                reader.readAsText(changeEvent.target.files[0]);
            });
        }
    }
}]).controller('static_aceController', function ($scope) {
    console.log('Ace controller loaded');
    $scope.saveAceContent = function(_editor){
        console.log('Editor content saved');
        $scope.saveItem($scope.resource, $scope.ifcName, $scope.patchResource);
    }
});
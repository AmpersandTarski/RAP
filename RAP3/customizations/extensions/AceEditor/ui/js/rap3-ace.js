var app = angular.module('AmpersandApp');
app.requires[app.requires.length] = 'ui.ace';
app.directive("fileread", ['ResourceService', function(ResourceService) {
    return {
        scope: {
            resource: '=',
            ifc: '=',
            patchResource: '='
        },
        link: function(scope, element, attributes) {
            element.bind("change", function(changeEvent) {
                var reader = new FileReader();
                reader.onload = function(loadEvent) {
                    scope.$apply(function() {
                        scope.resource[scope.ifc] = loadEvent.target.result;
                        ResourceService.saveItem(scope.resource, scope.ifc, scope.patchResource); // function(resource, ifc, patchResource)
                    });
                }
                reader.readAsText(changeEvent.target.files[0]);
            });
        }
    }
}]);
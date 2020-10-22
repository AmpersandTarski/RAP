angular.module('AmpersandApp')
.controller('AceEditorController', function ($scope, ResourceService) {
    /*
     * Object to temporary store value/resourceId to add to list
     * Value/resourceId is stored as property of 'selected' obj. This is needed to pass it around by reference
     */
    $scope.selected = {};
    
    $scope.onBlurSave = function(e){
        ResourceService.saveItem($scope.resource, $scope.ifc, $scope.patchResource); // function(resource, ifc, patchResource)
    };

    $scope.onBlurAdd = function (){
        ResourceService.addItem($scope.resource, $scope.ifc, $scope.selected, $scope.patchResource); // function(resource, ifc, selected, patchResource)
    }
    
    $scope.removeItem = ResourceService.removeItem; // function(resource, ifc, index, patchResource)
});

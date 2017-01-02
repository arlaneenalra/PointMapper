# Add coffee script code here
require 'directives'

mod = angular.module 'pointMapperApp', [ 'ngRoute', 'pointMapperDirectives' ]

mod.config ($routeProvider) ->
    $routeProvider
        .when '/', { templateUrl: 'views/file.html', controller: 'MainCtrl' }
        .otherwise { redirectTo: '/' }


mod.controller 'MainCtrl', ($scope, $log) ->
    imageAngle = 0
    points = $scope.loggedPoints = []

    $scope.loadingFile = true
    imageAttributes = $scope.imageAttributes = { height: 0, width: 0}
   
    # setup a good baseline canvas size
    canvas = $scope.canvas = { height: 16, width: 20, aspectRatio: 16/20, validSize: true }
    $scope.sourceRect = false

    # called when the we have a mapping box
    $scope.doneCallback = (rect) ->
        $scope.loadingFile = false
        $scope.sourceRect = rect

    # validate that we have a real size
    $scope.$watchGroup [ 'canvas.width', 'canvas.height' ], () ->
        canvas.validSize = canvas.height > 0 && canvas.width > 0
        
        # Don't attempt to do math with invalid canvas
        return if !canvas.validSize

        canvas.aspectRatio = canvas.height / canvas.width


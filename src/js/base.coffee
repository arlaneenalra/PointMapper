# Add coffee script code here
require 'directives'

mod = angular.module 'pointMapperApp', [ 'ngRoute', 'pointMapperDirectives' ]

mod.config ($routeProvider, $compileProvider) ->
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|data):/)

    $routeProvider
        .when '/', { templateUrl: 'views/file.html', controller: 'MainCtrl' }
        .otherwise { redirectTo: '/' }


mod.controller 'MainCtrl', ($scope, $log) ->
    imageAngle = 0
    points = $scope.loggedPoints = []

    $scope.loadingFile = true
    $scope.drawingPoints = false

    imageAttributes = $scope.imageAttributes = { height: 0, width: 0}
   
    # setup a good baseline canvas size
    canvas = $scope.canvas = { height: 40, width: 50, aspectRatio: 40/50, validSize: true }
    $scope.sourceRect = false

    # called when the we have a mapping box
    $scope.doneCallback = (rect) ->
        $scope.loadingFile = false
        $scope.drawingPoints = true
        $scope.sourceRect = rect
    
    # Show the mapped points!
    $scope.showPoints = (pointList) ->
        $scope.drawingPoints = false
        $scope.pointList = pointList

        # convert list into a csv file
        csv = 'data:text/csv,X%2CY%0A'
        for point in pointList
            csv += point.x + '%2C' + point.y + '%0A'

        $scope.pointCsv = csv

    $scope.startOver = () ->
        $scope.loadingFile = true
        $scope.drawingPoints = false
        $scope.pointList = false
        $scope.imageFile = false

    # validate that we have a real size
    $scope.$watchGroup [ 'canvas.width', 'canvas.height' ], () ->
        canvas.validSize = canvas.height > 0 && canvas.width > 0
        
        # Don't attempt to do math with invalid canvas
        return if !canvas.validSize

        canvas.aspectRatio = canvas.height / canvas.width


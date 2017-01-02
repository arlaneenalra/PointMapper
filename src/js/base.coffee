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

    imageStyle = $scope.imageStyle = { }
    imageAttributes = $scope.imageAttributes = { height: 0, width: 0}
   
    # setup a good baseline canvas size
    canvas = $scope.canvas = { height: 16, width: 20, aspectRatio: 16/20, validSize: true }

#    $scope.readSize = (imgSize) ->
#        if !imgSize then return
#
#        imageAttributes.height = imgSize.height
#        imageAttributes.width = imgSize.width
#
#        image = new Image()
#        image.onload = () ->
#            console.log image.width + ' ' + image.height
#
#        image.src = $scope.imageFile
#

#    newAngle = (left) ->
#        imageAngle = imageAngle + (if left then -90 else 90)
#       
#        offset = (imageAttributes.height - imageAttributes.width) / 2 + 1
#
#        imageStyle.transform = 'rotate(' + imageAngle + 'deg)'
#        imageStyle['margin-top'] = (if Math.abs(imageAngle % 180) > 0 then offset else 0) + 'px'
#
#    $scope.rotLeft = () -> newAngle false
#    $scope.rotRight = () -> newAngle true

   
    # validate that we have a real size
    $scope.$watchGroup [ 'canvas.width', 'canvas.height' ], () ->
        canvas.validSize = canvas.height > 0 && canvas.width > 0
        
        # Don't attempt to do math with invalid canvas
        return if !canvas.validSize

        canvas.aspectRatio = canvas.height / canvas.width


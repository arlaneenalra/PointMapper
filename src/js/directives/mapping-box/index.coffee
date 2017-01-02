mod = angular.module 'pointMapperMappingBox', []

# create the larges box we can of the given aspect ratio inside the canvas
makeBox =  (height, width, aspectRatio) ->
    box = {
        height: width * aspectRatio,
        width: width
    }

    # find the constrained dimension
    if height > width
        scale = width / box.width
    else
        scale = height / box.height

    return {
        height: (Math.floor box.height * scale),
        width: (Math.floor box.width * scale)
    }

mod.directive "mappingBox", () ->
    {
        restrict: 'AE'
        scope: {
            file: '=',
            resetCallback: '=',
            aspectRatio: '='
        },
        templateUrl: 'views/directives/mapping-box.html',
        link: (scope, element, attributes) ->
            imageData = scope.imageData = {}
            canvas = element.find('canvas')[0]
            options = scope.options = {
                darkBackground: false
            }
            
            mappingBox = false 

            stage = new createjs.Stage canvas

            updateMappingBox = () ->
                # remove any old mapping boxes
                if mappingBox
                    stage.removeChild(mappingBox)

                # add our Box!
                boxDimensions = makeBox canvas.height, canvas.width, scope.aspectRatio
                mappingBox = new createjs.Shape()
                
                # setup a sane box color
                boxColor = if options.darkBackground then "white" else "black"

                mappingBox.graphics
                    .ss(5).s(boxColor).r(0,0,boxDimensions.width, boxDimensions.height)

                stage.addChild(mappingBox)

            # make sure we update on changes 
            scope.$watchGroup [ 'options.darkBackground', 'aspectRatio' ], () ->
                updateMappingBox()
                stage.update()

            # Reload canvas when the file changes
            scope.$watch 'file', () ->
                image = new Image()
                image.onload = () ->
                    scope.$apply () ->
                        canvas.height = imageData.height = image.height
                        canvas.width = imageData.width = image.width
                
                        #remove old image if there is one
                        if imageData.bitmap
                            stage.removeChild(imageData.bitmap)

                        imageData.bitmap = new createjs.Bitmap(image)
                        stage.addChild(imageData.bitmap)
                        
                        updateMappingBox()

                        # update the stage
                        stage.update()
                
                        if scope.resetCallback then resetCallback()



               
                image.src = scope.file

            # setup canvase event handlers
    }


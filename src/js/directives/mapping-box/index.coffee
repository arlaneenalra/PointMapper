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

    box.height = (Math.floor box.height * scale)
    box.width = (Math.floor box.width * scale)

    # calculate bounding box for top left corner

    box.maxX = width - box.width
    box.maxY = height - box.height

    return box

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
                hitBox = new createjs.Shape()

                # calculate line width based on the on screen canvas size
                boxWidth = canvas.clientWidth * 0.0075
                boxWidth = Math.max(boxWidth, 1)
                
                # setup a sane box color
                boxColor = if options.darkBackground then "white" else "black"

                mappingBox.graphics
                    .ss(boxWidth).s(boxColor).r(0,0,boxDimensions.width, boxDimensions.height)

                hitBox.graphics.f('#000').r(0,0,boxDimensions.width, boxDimensions.height)

                mappingBox.hitArea = hitBox
               
                # tracks where the mose is inside the mapping box
                mouseOffset = { x: 0, y: 0 }

                # Handle mouse event listeners
                mappingBox.addEventListener 'mousedown', (e) ->
                    # Map mouse position to the upper left corner of the canvas 
                    mouseOffset.x = e.stageX - mappingBox.x
                    mouseOffset.y = e.stageY - mappingBox.y
    
                mappingBox.addEventListener 'pressmove', (e) ->
                    mouseX = e.stageX - mouseOffset.x
                    mouseY = e.stageY - mouseOffset.y
                    
                    mappingBox.x = Math.max(0, Math.min(mouseX, boxDimensions.maxX))
                    mappingBox.y = Math.max(0, Math.min(mouseY, boxDimensions.maxY))

                    stage.update()
                
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
            
            #stage.addEventListener 'pressmove', (e) ->
            #    console.log e
    }


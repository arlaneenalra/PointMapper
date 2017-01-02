mod = angular.module 'pointMapperPointBox', []

mod.directive "pointBox", () ->
    {
        restrict: 'AE'
        scope: {
            file: '=',
            doneCallback: '=',
            canvas: '=',
            sourceRect: '='
        },
        templateUrl: 'views/directives/point-box.html',
        link: (scope, element, attributes) ->
            imageData = scope.imageData = {}
            canvas = element.find('canvas')[0]

            pointList = []
            
            stage = new createjs.Stage canvas

            # Reload canvas when the file changes
            scope.$watch 'file', () ->
                image = new Image()
                image.onload = () ->
                    scope.$apply () ->
                        canvas.height = scope.sourceRect.height
                        canvas.width = scope.sourceRect.width
               
                        cSize = canvas.width * 0.0025
                        cSize = Math.max(cSize,3)

                        #remove old image if there is one
                        if imageData.bitmap
                            stage.removeChild(imageData.bitmap)

                        imageData.bitmap = new createjs.Bitmap(image)
                        imageData.bitmap.sourceRect = scope.sourceRect
                        stage.addChild(imageData.bitmap)
                        
                        # add click listener
                        imageData.bitmap.addEventListener 'click', (e) ->
                            point = new createjs.Shape()
                            point.graphics.ss(cSize / 3).s("white").f("black").dc(0,0, cSize)

                            point.x = e.stageX
                            point.y = e.stageY
                            
                            pointList.push point

                            # allow points to be removed
                            point.addEventListener 'click', (e) ->
                                stage.removeChild(point)
                                stage.update()

                                # find this point in our list and nuke it
                                pointList.splice(pointList.indexOf(point), 1)
                                console.log pointList

                            stage.addChild(point)

                            console.log [e.stageX, e.stageY, cSize ]
                            stage.update()

                        # update the stage
                        stage.update()

                image.src = scope.file

    }


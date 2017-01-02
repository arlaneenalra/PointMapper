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
            
            stage = new createjs.Stage canvas

            # Reload canvas when the file changes
            scope.$watch 'file', () ->
                image = new Image()
                image.onload = () ->
                    scope.$apply () ->
                        canvas.height = scope.sourceRect.height
                        canvas.width = scope.sourceRect.width
                
                        #remove old image if there is one
                        if imageData.bitmap
                            stage.removeChild(imageData.bitmap)

                        imageData.bitmap = new createjs.Bitmap(image)
                        imageData.bitmap.sourceRect = scope.sourceRect
                        stage.addChild(imageData.bitmap)
                        
                        # update the stage
                        stage.update()

                image.src = scope.file

    }


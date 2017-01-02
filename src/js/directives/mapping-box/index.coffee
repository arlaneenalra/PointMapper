mod = angular.module 'pointMapperMappingBox', []

mod.directive "mappingBox", () ->
    {
        restrict: 'AE'
        scope: {
            file: '=',
            resetCallback: '='
        },
        #template: '<canvas style="width:100%"></canvas>'
        templateUrl: 'views/directives/mapping-box.html',
        link: (scope, element, attributes) ->
            imageData = scope.imageData = {}
            canvas = element.find('canvas')[0]

            #ctx = canvas.getContext '2d'

            stage = new createjs.Stage canvas

            # Reload canvas when the file changes
            scope.$watch 'file', () ->
                image = new Image()
                image.onload = () ->
                    scope.$apply () ->
                        canvas.height = imageData.height = image.height
                        canvas.width = imageData.width = image.width
                
                        #ctx.drawImage(image, 0, 0)
                       
                        #remove old image if there is one
                        if imageData.bitmap
                            stage.removeChild(imageData.bitmap)

                        imageData.bitmap = new createjs.Bitmap(image)
                        stage.addChild(imageData.bitmap)
                        
                        # update the stage
                        stage.update()
                
                        if scope.resetCallback then resetCallback()
               
                image.src = scope.file

            # setup canvase event handlers
    }


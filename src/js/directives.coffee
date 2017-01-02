mod = angular.module 'pointMapperDirectives', []

# http://stackoverflow.com/questions/17063000/ng-model-for-input-type-file
mod.directive "fileread", () ->
    {
        scope: { fileread: "=" },
        link: (scope, element, attributes) ->
            element.bind "change", (changeEvent) ->
                reader = new FileReader()

                reader.onload = (loadEvent) ->
                    scope.$apply () ->
                        scope.fileread = loadEvent.target.result
                
                reader.readAsDataURL changeEvent.target.files[0]
    }

mod.directive "imgReader", () ->
    {
        restrict: "A",
        scope: { imgReader: '=' },
        link: (scope, element, attributes) ->
            img = element[0]

            img.onload = () ->
                scope.$apply () ->
                    scope.imgReader {
                            height: img.clientWidth,
                            width: img.clientHeight
                        }

    }

mod.directive "mappingBox", () ->
    {
        restrict: 'AE'
        scope: {
            file: '=',
            resetCallback: '='
        },
        template: '<canvas style="width:100%"></canvas>'
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


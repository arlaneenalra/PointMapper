require 'directives/mapping-box'
require 'directives/point-box'

mod = angular.module 'pointMapperDirectives', [ 'pointMapperMappingBox', 'pointMapperPointBox' ]

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


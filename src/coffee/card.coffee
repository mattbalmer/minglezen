class Card
    @FETCH_URI: '/cards/{card}.xml'

    constructor: (@$) ->
        @extend MingleZen.formatter.extractData(@$)

        MingleZen.formatter.format @$
        MingleZen.formatter.colorize @$

        path = MingleZen.getPath @constructor.FETCH_URI, card: @cardId
        jQuery.ajax(path).done (jqxhr, textStatus, response) => @update parseXml(response.responseText)

    ### =======================
    ===== Primary Methods =====
    ======================= ###

    update: (json)->
        @extend json

    extend: (map, to = @)->
        if map isnt null and 'object' is typeof map
            for attr of map
                to[attr] = map[attr]

    prop: (name)->
        for k, property of @properties
            return property if property.name.toLowerCase() is name.toLowerCase()

    ### ======================
    ===== Helper Methods =====
    ====================== ###

    isBlocked: ->
        (if @prop('blocked').value is 'Yes' then true else false)
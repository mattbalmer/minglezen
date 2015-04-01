class MZFormatter

    constructor: (@cardSelector) ->

    ### =======================
    ===== Primary Methods =====
    ======================= ###

    extractData: ($card) ->
        cardId: $card.find('.card-summary-number a').text().substring(1)
        color: $card.css 'border-left-color'

    format: ($card)->
        $card.addClass 'card'

    createTitleBar: ($card) ->
        bar = $("<div />").addClass('title-bar')
        $card.prepend bar

    movePoints: ($card) ->
        number = $card.find('.card-summary-number')
        numberClone = number.clone()
        number.remove()
        $card.find('.title-bar').append numberClone

    setPoints: ($card, points) ->
        $card.addClass 'points-' + points
        pointsLabel = (points or '?') + ' pt' + (if points == 1 then '' else 's')
        pointsDiv = $("<div />")
            .addClass 'card-points'
            .text pointsLabel
        $card.find('.title-bar').append pointsDiv

    colorize: ($card, c = @extract 'color', $card)->
        c = new RGBColor c

        # if all color values are 51, the card color is not set (the function is
        # picking up on the color attribute) and the background should not be set
        $card.css 'background', 'rgba({0}, {1}, {2}, {3})'.format(c.r, c.g, c.b, .2) unless c.r is 51

    block: ($card, comments = '[no comments]') ->
        $blockedComments = $('<div/>').addClass('blocked-comments').text comments

        $card.addClass('blocked-card').after $blockedComments

    ### ======================
    ===== Helper Methods =====
    ====================== ###

    extract: (prop, $card) ->
        @extractData($card)[prop]
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

        @addBlockBar $card

    addBlockBar: ($card) ->
        if $card.find('.block-bar').length > 0 then return

        blockBar = $('<div/>').addClass('block-bar').text 'Block'
        $card.append blockBar

    createTitleBar: ($card) ->
        if $card.find('.title-bar').length > 0 then return

        bar = $("<div />").addClass('title-bar')
        $card.prepend bar

    movePoints: ($card) ->
        if $card.find('.title-bar').find('.card-summary-number').length > 0 then return

        number = $card.find('.card-summary-number')
        numberClone = number.clone()
        number.remove()
        $card.find('.title-bar').append numberClone

    setPoints: ($card, points) ->
        if $card.find('.title-bar').find('.card-points').length > 0 then return

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

    block: ($card, handleSubmit, comments = '[no comments]') ->
        if $card.find('.blocked-comments').length > 0 then return

        shiftOn = false
        $blockedComments = $('<textarea/>')
            .addClass('blocked-comments')
            .prop 'placeholder', 'Press [Enter] to save'
            .val comments
            .bind 'keyup', (e)=>
                if ((e.keyCode || e.which) == 16 || (e.shiftKey))
                    shiftOn = false
            .bind 'keypress', (e)=>
                if ((e.keyCode || e.which) == 16 || (e.shiftKey))
                    shiftOn = true
                if ((e.keyCode || e.which) == 13 && !shiftOn)
                    e.preventDefault()
                    handleSubmit $blockedComments.val()
                    return false

        $card.addClass('blocked-card').after $blockedComments

    unblock: ($card) ->
        $card.removeClass('blocked-card')
        $card.find('.blocked-comments').remove()

    ### ======================
    ===== Helper Methods =====
    ====================== ###

    extract: (prop, $card) ->
        @extractData($card)[prop]
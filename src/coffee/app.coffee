class MingleZen
    @API_PATH: '{host}/api/v2/projects/{team}{uri}'
    @formatter: null
    @team: null

    cards: []

    constructor: (settings)->
        for k of settings
            @[k] = settings[k]

        @constructor.team = @getTeam()
        @constructor.formatter = new MZFormatter

    ### =======================
    ===== Primary Methods =====
    ======================= ###

    run: ->
        @update()
        setInterval =>
            @update()
        , 500

    update: ->
        count = $('.card').length
        if count is 0 or count isnt @cards.length   # ie. something's changed in the DOM
            @$cards = $(@cardSelector)

            @cards = (new Card $(c) for c in @$cards)

    ### ======================
    ===== Helper Methods =====
    ====================== ###

    getTeam: ->
        window.location.pathname.split('/')[2] # /projects/TEAM_NAME/etc

    ### ======================
    ===== Static Methods =====
    ====================== ###

    @getPath: (uri, values) ->
        @API_PATH.format
            host: window.location.origin
            team: @team
            uri: uri.format values
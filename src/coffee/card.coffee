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

		MingleZen.formatter.createTitleBar @$
		MingleZen.formatter.movePoints @$
		MingleZen.formatter.setPoints @$, @prop('story points'), @color

		if @isBlocked()
			MingleZen.formatter.block @$, @prop('blocked comments')

	extend: (map, to = @)->
		if map isnt null and 'object' is typeof map
			for attr of map
				to[attr] = map[attr]

	prop: (name)->
		for k, property of @properties
			if property.name and property.name.toLowerCase() is name.toLowerCase()
				return (if property.value != undefined then property.value else property)

	### ======================
	===== Helper Methods =====
	====================== ###

	isBlocked: ->
		(if @prop('blocked') is 'Yes' then true else false)
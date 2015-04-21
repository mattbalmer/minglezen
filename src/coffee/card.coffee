class Card
	@FETCH_URI: '/cards/{card}.xml'
	@PUT_URI: '/cards/{card}.xml'

	constructor: (@$) ->
		@extend MingleZen.formatter.extractData(@$)

		MingleZen.formatter.format @$
		MingleZen.formatter.colorize @$

		@$.find('.block-bar').click (e)=>
			e.preventDefault()
#			@block '[no comments]'
			MingleZen.formatter.block @$, @updateBlockedComments, ''
			return false

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
			MingleZen.formatter.block @$, @updateBlockedComments, @prop('blocked comments')
		else
			MingleZen.formatter.unblock @$

	extend: (map, to = @)->
		if map isnt null and 'object' is typeof map
			for attr of map
				to[attr] = map[attr]

	prop: (name)->
		for k, property of @properties
			if property.name and property.name.toLowerCase() is name.toLowerCase()
				return (if property.value != undefined then property.value else property)

	block: (comments) =>
		path = MingleZen.getPath Card.PUT_URI, card: @cardId

		params = MingleZen.queryFromProps
			Blocked: 'Yes'
			'Blocked Comments': comments

		@$.parent().addClass 'operating'
		jQuery.ajax
			method: 'PUT'
			url: path + params
		.done (jqxhr, textStatus, response) =>
			@$.parent().removeClass 'operating'
			@update parseXml(response.responseText)

	unblock: ()=>
		path = MingleZen.getPath Card.PUT_URI, card: @cardId

		params = MingleZen.queryFromProps
			Blocked: 'No'
			'Blocked Comments': ''

		console.log('unblock', params);

		@$.parent().addClass 'operating'
		jQuery.ajax
			method: 'PUT'
			url: path + params
		.done (jqxhr, textStatus, response) =>
			@$.parent().removeClass 'operating'
			@update parseXml(response.responseText)

	### ======================
	===== Helper Methods =====
	====================== ###

	updateBlockedComments: (comments)=>
		console.log 'update blocked comments', comments, comments.length

		if comments.length > 0
			@block comments
		else
			@unblock()

	isBlocked: ->
		(if @prop('blocked') is 'Yes' then true else false)
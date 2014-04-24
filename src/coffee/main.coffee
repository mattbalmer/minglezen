parseXml = (response) ->
	data = $.parseXML(response)
	json = JSON.parse('' + xml2json(data, '\t')).card

	# Change @nil property to just be tha value instead
	for k, v of json.properties
		if v.value && v.value['@nil'] == 'true'
			v.value = null

	return json

$ ->
    # Assume that this is NOT a Thoughtworks Mingle application if 'thoughtworks' isn't present in the HTML
    return if document.body.innerHTML.indexOf('thoughtworks') < 0

	# Initialize
    MZ = new MingleZen
        cardSelector: '.card-inner-wrapper'

    # Start
    MZ.run()
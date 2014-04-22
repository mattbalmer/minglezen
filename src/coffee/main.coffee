parseXml = (response) ->
    data = $.parseXML(response)
    JSON.parse('' + xml2json(data, '\t')).card

$ ->
    # Assume that this is NOT a Thoughtworks Mingle application if 'thoughtworks' isn't present in the HTML
    return if document.body.innerHTML.indexOf('thoughtworks') < 0

	# Initialize
    MZ = new MingleZen
        cardSelector: '.card-inner-wrapper'

    # Start
    MZ.run()
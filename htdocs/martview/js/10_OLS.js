
// Ontology autocomplete using OLS

$(document).ready(function() {
	$("<style type='text/css'> .ui-autocomplete-loading{ background:url('/biomart/mview/images/jquery-ui-loading.gif') no-repeat right center }</style>").appendTo('head');
	$("div[id$='filter\\.go_parent_term']").prepend('<input type="text" id="ols-autocomplete" name="ols-autocomplete" placeholder="Start typing description to lookup GO term..." style="width: 300px; margin-bottom: 15px" /><br />');
	$("textarea[name$='filter\\.go_parent_term']").css('width', '300px');
	$("textarea[name$='filter\\.go_parent_term']").attr('placeholder', 'Search for a GO term above to populate this list');
	$("#ols-autocomplete").autocomplete({
		source: function(request, response) {
			var endPoint;
			var requestData;
			if(request.term.length == 10 && request.term.substring(0,3) == 'GO:') {
				endPoint = 'getTermsByIdResponse';
				requestData = {
					q: 'termname',
					termid: request.term,
					ontologyname: 'GO',
				}; 
			} else {
				endPoint = 'getTermsByName';
				requestData = {
					q: 'termautocomplete',
                                        termname: request.term,
                                        ontologyname: 'GO',
                                };
			}
			$.ajax({
				url: "http://www.ebi.ac.uk/ontology-lookup/ajax.view",
				type: 'GET',
				data: requestData,
				success: function(responseXML) {
					//console.log(responseXML.toString());
					if(endPoint == 'getTermsByName') {
						var data = $('item', responseXML).map(function() {
							var displayVal = $('name', this).text() + ' [' + $('value', this).text() + ']';
							return {
								value: displayVal,
								id: $('value', this).text(),
							};
						}).get();
					} else {
						var data = $('item', responseXML).map(function() {
							return {
								value: $('value', this).text() + ' [' + request.term + ']',
								id: $('value', this).text(),
							};
						}).get();;
					}
					response(data);
				},
				error: function(data) {
					//console.log(data);
				},
			});
		},
		minLength: 3,
		select: function(event, ui) {
			var box = $("textarea[name$='filter\\.go_parent_term']");
			box.val(box.val() + ui.item.id + '\n');
			$('#ols-autocomplete').val('');
			$("input[name$='filtercollection\\.go_filters']").prop('checked', true);
			return false;
		},
	});

});



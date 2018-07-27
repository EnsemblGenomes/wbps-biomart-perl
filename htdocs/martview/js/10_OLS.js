
// Ontology autocomplete using OLS

$(document).ready(function() {
  $("<style type='text/css'> .ui-autocomplete-loading{ background:url('/biomart/mview/images/jquery-ui-loading.gif') no-repeat right center }</style>").appendTo('head');
  $("div[id$='filter\\.go_parent_term']").prepend('<input type="text" id="ols-autocomplete" name="ols-autocomplete" placeholder="Start typing description to lookup GO term..." style="width: 300px; margin-bottom: 15px" /><br />');
  $("textarea[name$='filter\\.go_parent_term']").css('width', '300px');
  $("textarea[name$='filter\\.go_parent_term']").attr('placeholder', 'Search for a GO term above to populate this list');
  $("input[name$='filtercollection\\.go_filters']").change( function() {
    if($(this).is(':checked')) {
      $('#count_button_tag')
        .removeAttr('onclick')
        .removeAttr('onmouseover')
        .removeAttr('onmouseout')
        .removeClass('mart_btn_count')
        .addClass('mart_btn_count_disabled')
        .click( function() {
          alert('Due to the complexity of this query, a count is not possible.  The first ten results can be previewed by clicking "Results".');
        });
    } else {
      $('#count_button_tag')
        .unbind('click')
        .attr('onclick', "if (datasetExists() > 0) { document.getElementById('summarypanel_filter_count_1').innerHTML = 'Loading... '; addLoadingImage('summarypanel_filter_count_1', 'biomart');  if (document.getElementById('summarypanel_filter_count_2') != null){  document.getElementById('summarypanel_filter_count_2').innerHTML = 'Loading... ';  addLoadingImage('summarypanel_filter_count_2', 'biomart'); } document.mainform.formatterMenu.value = 'preView'; document.mainform.do_export.value = 0; document.mainform.track_visible_section.value = document.mainform['mart_mainpanel__current_visible_section'].value; document.mainform.savequery.value = 0; document.mainform.showquery.value = 0; document.mainform.countButton.value = 5; document.mainform.target = 'count_hiddenIFrame'; document.mainform.submit();  document.mainform.countButton.value = 1;   return false; }")
        .attr('onmouseover', "this.className='mart_btn_count mart_btnhov'")
        .attr('onmouseout', "this.className='mart_btn_count'")
        .addClass('mart_btn_count')
        .removeClass('mart_btn_count_disabled');
    }
  })
  $("#ols-autocomplete").autocomplete({
    source: function(request, response) {
      var endPoint;
      var requestData;
      if(request.term.length == 10 && request.term.substring(0,3) == 'GO:') {
        endPoint = 'select';
        requestData = {
          q: request.term,
          ontologyname: 'go',
        }; 
      } else {
        endPoint = 'select';
        requestData = {
          q: request.term,
          ontology: 'go',
                                };
      }
      $.ajax({
        url: "https://www.ebi.ac.uk/ols/api/select",
        type: 'GET',
        data: requestData,
        dataType: 'json',
        success: function(responseJSON) {
          var data = $.map(responseJSON.response.docs, function(obj) {
            var displayVal = obj.label + ' [' + obj.obo_id + ']';
            return {
              value: displayVal,
              id: obj.obo_id,
            };
          });
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
      $("input[name$='filtercollection\\.go_filters']").prop('checked', true).trigger('change');
      return false;
    },
  });

});



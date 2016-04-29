
// Changes to the UI for compara filters

$(document).ready(function() {

  if($('.js_panel').length) {

    // Disallow 'without orthologues' to be selected if the same species is selected in 'with orthologues'
    $("[id$=homolog_with_filter_collection]").change(function() {
      $("[id$=homolog_without_filter_collection] option").each(function() {
        $(this).removeProp('disabled');
      });
      $("[id$=homolog_with_filter_collection] :selected").each(function() {
        $("[id$=homolog_without_filter_collection] option[title='" + $(this).prop('title') + "']").prop('disabled', 'disabled');
      });
    });

    // Disallow 'with orthologues' to be selected if the same species is selected in 'without orthologues'
    $("[id$=homolog_without_filter_collection]").change(function() {
      $("[id$=homolog_with_filter_collection] option").each(function() {
        $(this).removeProp('disabled');
      });
      $("[id$=homolog_without_filter_collection] :selected").each(function() {
        $("[id$=homolog_with_filter_collection] option[title='" + $(this).prop('title') + "']").prop('disabled', 'disabled');
      });
    });

  }

});
     

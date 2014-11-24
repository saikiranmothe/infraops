function validateProjectLinkForm() {
  
    $('#form_project_link').validate({
      debug: true,
      rules: {
        "project_link[link_type]": "required",
        "project_link[url]": "required"
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "project_link[link_type]": "Please specify Link Type",
        "project_link[url]": "Please specify Url"
      },
      highlight: function(element) {
          $(element).parent().parent().addClass("has-error");
      },
      unhighlight: function(element) {
          $(element).parent().parent().removeClass("has-error");
      },
      invalidHandler: function(event, validator) {
        // 'this' refers to the form
        var errors = validator.numberOfInvalids();
        if (errors) {
          
          // Populating error message
          var errorMessage = errors == 1
            ? 'You missed 1 field. It has been highlighted'
            : 'You missed ' + errors + ' fields. They have been highlighted';
          
          // Removing the form error if it already exists
          $("#div_project_link_js_validation_error").remove();
          
          errorHtml = "<div id='div_project_link_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_project_link_details").prepend(errorHtml);  
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);  
          
          // Show error labels
          $("div.error").show();
          
        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_project_link_js_validation_error").remove();
        }
      }
      
    });
    
}

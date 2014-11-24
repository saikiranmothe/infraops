function validateLinkTypeForm() {
  
    $('#form_link_type').validate({
      debug: true,
      rules: {
        "link_type[name]": {
            required: true,
            minlength: 2,
            maxlength: 50
        },
        "link_type[description]": {
            required: true,
            minlength: 2,
            maxlength: 50
        },
        "link_type[theme]": {
            required: true,
            minlength: 2,
            maxlength: 50
        },
        "link_type[button_text]": {
            required: true,
            minlength: 2,
            maxlength: 50
        },
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "link_type[name]": "Please specify Name",
        "link_type[description]": "Please specify Description",
        "link_type[theme]": "Please specify Theme",
        "link_type[button_text]": "Please specify Button Text"
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
          $("#div_link_type_js_validation_error").remove();
          
          errorHtml = "<div id='div_link_type_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_link_type_details").prepend(errorHtml);  
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);  
          
          // Show error labels
          $("div.error").show();
          
        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_link_type_js_validation_error").remove();
        }
      }
      
    });
    
}

function validateClientForm() {
  
    $('#form_client').validate({
      debug: true,
      rules: {
        "client[name]": {
            required: true,
            minlength: 2,
            maxlength: 50
        },
        "client[pretty_url]": "required",
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "client[name]": "Please specify Name",
        "client[pretty_url]": "Please specify Pretty Url",
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
          $("#div_client_js_validation_error").remove();
          
          errorHtml = "<div id='div_client_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_client_details").prepend(errorHtml);  
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);  
          
          // Show error labels
          $("div.error").show();
          
        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_client_js_validation_error").remove();
        }
      }
      
    });
    
}

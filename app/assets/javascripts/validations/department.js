function validateDepartmentForm() {
  
    $('#form_department').validate({
      debug: true,
      rules: {
        "department[name]": {
            required: true,
            minlength: 2,
            maxlength: 50
        }
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "department[name]": "Please specify Name",
        "department[description]": "Please specify Description",
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
          $("#div_department_js_validation_error").remove();
          
          errorHtml = "<div id='div_department_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_department_details").prepend(errorHtml);  
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);  
          
          // Show error labels
          $("div.error").show();
          
        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_department_js_validation_error").remove();
        }
      }
      
    });
    
}

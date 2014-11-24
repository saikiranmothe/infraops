function validateRoleForm() {
  
    $('#form_role').validate({
      debug: true,
      rules: {
        "role[name]": "required",
        "role[member_id]": "required",
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "role[name]": "Please select a Role",
        "role[member_id]": "Please select a user"
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
          $("#div_role_js_validation_error").remove();
          
          errorHtml = "<div id='div_role_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_role_details").prepend(errorHtml);  
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);  
          
          // Show error labels
          $("div.error").show();
          
        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_role_js_validation_error").remove();
        }
      }
      
    });
    
}

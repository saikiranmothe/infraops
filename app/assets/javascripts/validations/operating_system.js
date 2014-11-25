function validateOperatingSystemForm() {

    $('#form_operating_system').validate({
      debug: true,
      rules: {
        "operating_system[name]": {
            required: true,
            minlength: 2,
            maxlength: 56
        },
        "operating_system[short_name]": {
            required: true,
            minlength: 2,
            maxlength: 16
        },
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "operating_system[name]": "Please specify Name a Short Name between 2 and 56 characters",
        "operating_system[short_name]": "Please specify a Short Name between 2 and 16 characters",
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
          $("#div_operating_system_js_validation_error").remove();

          errorHtml = "<div id='div_operating_system_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_operating_system_details").prepend(errorHtml);
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);

          // Show error labels
          $("div.error").show();

        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_operating_system_js_validation_error").remove();
        }
      }

    });

}

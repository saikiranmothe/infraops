function validateOsVersionForm() {

    $('#form_os_version').validate({
      debug: true,
      rules: {
        "os_version[name]": {
            required: true,
            minlength: 2,
            maxlength: 56
        },"os_version[version]": {
            required: true,
            minlength: 2,
            maxlength: 8
        },
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "os_version[name]": "Please specify Name between 2 and 56 characters",
        "os_version[version]": "Please specify the version (2 to 56 characters)",
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
          $("#div_os_version_js_validation_error").remove();

          errorHtml = "<div id='div_os_version_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_os_version_details").prepend(errorHtml);
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);

          // Show error labels
          $("div.error").show();

        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_os_version_js_validation_error").remove();
        }
      }

    });

}

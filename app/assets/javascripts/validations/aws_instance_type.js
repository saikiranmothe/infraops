function validateAwsInstanceTypeForm() {

    $('#form_aws_instance_type').validate({
      debug: true,
      rules: {
        "aws_instance_type[name]": {
            required: true,
            minlength: 6,
            maxlength: 56
        },
        "aws_instance_type[short_name]": {
            required: true,
            minlength: 3,
            maxlength: 16
        }
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "aws_instance_type[name]": "Please specify a Name",
        "aws_instance_type[short_name]": "Short Name is a must and should have minimum 3 characters",
        "aws_instance_type[description]": "Please specify Description",
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
          $("#div_aws_instance_type_js_validation_error").remove();

          errorHtml = "<div id='div_aws_instance_type_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_aws_instance_type_details").prepend(errorHtml);
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);

          // Show error labels
          $("div.error").show();

        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_aws_instance_type_js_validation_error").remove();
        }
      }

    });

}

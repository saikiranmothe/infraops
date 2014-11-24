var status;
var maxPhotoUploadFileSize = 5000000;

// Used to clone photo uploader
function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().before(content.replace(regexp, new_id));
    var upload_label = $('label.upload_image');
    if($(upload_label).length > 0) {
        $(upload_label).text('browse');
    }
}

// Remove a photo uploader
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest("div.add-photos-path").hide();
}

// Remove Option filed
function remove_option_field(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest("div.div-new-field").hide();
}

/* Validate image file extension. The Supported formats are
   .jpg, .jpeg, .ico, .png, .gif
*/
function validate_file_extn(filename) {
    var image_extns = new Array(/^jpg$/i, /^png$/i, /^jpeg$/i, /^ico$/i, /^gif$/i)
    var extn = filename.split('.');
    for(var i = 0; i < image_extns.length; i++) {
        if(extn[1].match(image_extns[i])) {
            status = "true"
            break;
        }
        else {
            status = "false";
        }
    }
    return status;
}

// Client side image preview before uploading to server

function preview_image(input, element_id, width) {
  
  if(width == undefined){
    width = 90;
  }
  
    var filename = $(input).val().split('\\').pop();
    var status = validate_file_extn(filename);
    var reader = '';

    if(status == "false") {
        $(input).val('');
        alert("File type is not supported");
    }
    else {

        if(navigator.userAgent.match(/msie/i) && !navigator.userAgent.match(/msie 10/i)) {
            if($('.div-sg-photo-preview').length > 0) {
                $('.div-sg-photo-preview').css('border', '1px solid lightgray').html(filename);
            }
            else {
                $(input).parents('.add-photos-path').find('.jquery-sg-image-container').
                css('border-top', '1px solid gray').html(filename);
            }
        }
        else if(navigator.userAgent.match(/msie/i) && navigator.userAgent.match(/msie 10/i)) {
            reader = new FileReader();
            reader.onload = function (e) {
                $('#'+element_id)
                .attr('src', e.target.result)
                .width(width);
            };

            reader.readAsDataURL(input.files[0]);
        }

        else {

            if (input.files && input.files[0]) {
                if(input.files[0].size < maxPhotoUploadFileSize) {
                    reader = new FileReader();
                    reader.onload = function (e) {
                        $('#'+element_id)
                        .attr('src', e.target.result)
                        .width(width);
                    };

                    reader.readAsDataURL(input.files[0]);
                }
                else {
                    alert("Maximum Size is " + maxPhotoUploadFileSize + " KB");
                }

            }
        }
    }

}
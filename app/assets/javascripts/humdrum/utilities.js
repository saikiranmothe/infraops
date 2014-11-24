// Write down only those functions which are being used by application.init or any part of the application like ajax event handlers.

// loadANewPage will accept a url and will load a new page
// It can be tuned to show a lightbox showing a loading, please wait message.
function loadANewPage(url){
	// showLightBoxLoading();
	window.location.href=url;
}

// sendAjaxRequest is used to send an xml http request using javascript to a url using a method / get, put, post, delete
function sendAjaxRequest(url, mType){
	methodType = mType || "GET";
	jQuery.ajax({type: methodType, dataType:"script", url:url});
}

// Call this function by passing  model Id, heading and a bodyContent.
// it will pop up bootstrap 3 modal.
var messageModalId = "div_modal_message";
var genericModalId = "div_modal_generic";
function showModal(heading, bodyContent, modalId){
  if(modalId==null){
    var modalId = genericModalId;
  }
	//$('#' + modalId + ' .modal-body').html("<p>"+ message +"</p>");
	$('#' + modalId + ' .modal-header h4.modal-title').text(heading);
	$('#' + modalId + ' div.modal-body-main').html(bodyContent);
	$('#' + modalId).modal('show');
  //$('#' + modalId + ' .modal-footer button.btn-primary').button('reset');
}

// Call this function by passing  heading and a message.
// it will pop up bootstrap 3 modal which shows the heading and message as content body.
function showModalMessage(heading, message, modalId){
  if(modalId==null){
    var modalId = messageModalId;
  }
  var bodyContent = "<p>"+ message +"</p>";
	//$('#' + modalId + ' .modal-body').html("<p>"+ message +"</p>");
	$('#' + modalId + ' .modal-header h4.modal-title').text(heading);
	$('#' + modalId + ' div.modal-body').html(bodyContent);
	$('#' + modalId).modal('show');
  //$('#' + modalId + ' .modal-footer button.btn-primary').button('reset');
}

function closeModal(modalId){
  if(modalId==null){
    var modalId = genericModalId;
  }
  $('#' + modalId).modal('hide');
}

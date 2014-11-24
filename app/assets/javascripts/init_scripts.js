function reset_panels(){
	$('.panel-close').click(function(e){
		e.preventDefault();
		$(this).parent().parent().parent().parent().fadeOut();
	});

	$('.panel-minimize').click(function(e){
		e.preventDefault();
		var $target = $(this).parent().parent().parent().next('.panel-body');
		if($target.is(':visible')) $('i',$(this)).removeClass('icon-chevron-up').addClass('icon-chevron-down');
		else 					   $('i',$(this)).removeClass('icon-chevron-down').addClass('icon-chevron-up');
		$target.slideToggle();
	});
}
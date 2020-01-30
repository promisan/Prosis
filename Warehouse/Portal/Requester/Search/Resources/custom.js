function enlargePicture(selector) {
	var vHeight = parseInt($(selector).height());
	if (vHeight <= 75) {
		$(selector).css('height','300px').css('width','300px').removeClass('img-circle');
	} else {
		$(selector).css('height','75px').css('width','75px').addClass('img-circle');
	}
}
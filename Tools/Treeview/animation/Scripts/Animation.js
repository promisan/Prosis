var cntBG = 1; //default background
var maxBG = 4; //maximum number of backgrounds
var secondsElapsed = 0;

var defaultAnimation = 'ease-in-out';
var defaultAnimationDelay = 5; //in seconds
var crossBrowserList = ['-webkit-','-moz-',''];

//function to set CSS3 animations
function setCSS3Animation(el, definition, aFunction, fillMode, delay, addTime) {
	var cnt = -1;
	$(el).each(function(){		
		var initialCnt = cnt + 1;
		var thisElement = this;
		
		cnt = cnt + 1 + delay;
		$.each(crossBrowserList, function(index, value) {
			$(thisElement).css(value+'animation', definition);
			$(thisElement).css(value+'animation-timing-function', aFunction);
			$(thisElement).css(value+'animation-fill-mode', fillMode);
			$(thisElement).css(value+'animation-delay', initialCnt+'s, '+cnt+'s');
		});
	});
	if (addTime) { secondsElapsed = secondsElapsed + cnt; }
}

//function to set JQuery animations for the image cycle
function setJQueryAnimationImageCicle(el, delay) {
	var cnt = 0;
	$(el).each(function() {
		var thisElement = this;
		setTimeout(function(){
			$(el).fadeOut(250);
			$(thisElement).fadeIn(1000);
		}, cnt*delay*1000);
		cnt = cnt + 1;
	});
}

//function to set JQuery animations for the cycle of the group of images
function setJQueryAnimation(el, delay, addTime, endLefPosition) {
	var bgVal = '';
	
	//replace all images with the png versions
	$(el+'Image').each(function() {
		bgVal = $(this).css('background-image');
		bgVal = bgVal.replace('.gif','.png');
		$(this).css('background-image',bgVal);
	});
	
	//reset the elements position
	$(el).css('display','none').css('left', endLefPosition);
	
	//set the animation cycles
	setJQueryAnimationImageCicle(el, delay);
	setInterval(function() {
		setJQueryAnimationImageCicle(el, delay);
	}, ($(el).length * delay * 1000));
	
	if (addTime) { secondsElapsed = secondsElapsed + (delay * $(el).length); }
}

//function to set animations
function setAnimation(el, definition, aFunction, fillMode, delay, addTime, endLefPosition) {
	if (Modernizr.cssanimations) {
		setCSS3Animation(el, definition, aFunction, fillMode, delay, addTime);
	} else {
		setJQueryAnimation(el, delay, addTime, endLefPosition);
	}
}

//function to replay the animation
function replay(el, parent) {
	var options = $(el);
	$(el).remove();
	$(parent).append(options);
}

//function to change backgrounds
function changeBG(el, delayInSeconds) {
	cntBG = cntBG + 1;
	if (cntBG > maxBG) { cntBG = 1; }
	$(el).fadeOut(delayInSeconds*500).css('background-image','url(Images/'+cntBG+'.png)').fadeIn(delayInSeconds*500);
}

//set animations for images
setAnimation('.clsElement', 'goIn 1s, goOut 1s', defaultAnimation, 'forwards', defaultAnimationDelay, true, '40%');

//set animations for texts
setAnimation('.clsElementText', 'goInText 1s, goOutText 1s', defaultAnimation, 'forwards', defaultAnimationDelay, false, '0');

//on ready
$(document).ready(function() {
	
	//set repetitions
	setInterval(function() {
		//replay images
		replay('.clsElement', 'body');
		
		//replay texts
		replay('.clsElementText', 'body');
		
		//Change backgrounds
		changeBG('.clsCurtain', 1);
	}, (secondsElapsed * 1000));
	
});
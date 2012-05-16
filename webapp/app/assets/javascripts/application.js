// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require private_pub
//= require_tree .
//= require chosen.jquery.min

jQuery.expr[':'].regex = function(elem, index, match) {
    var matchParams = match[3].split(','),
        validLabels = /^(data|css):/,
        attr = {
            method: matchParams[0].match(validLabels) ? 
                        matchParams[0].split(':')[0] : 'attr',
            property: matchParams.shift().replace(validLabels,'')
        },
        regexFlags = 'ig',
        regex = new RegExp(matchParams.join('').replace(/^\s+|\s+$/g,''), regexFlags);
    return regex.test(jQuery(elem)[attr.method](attr.property));
}

$('document').ready(function(){
	
	$('.chzn-select').chosen();
	
	$('#flash_notice').animate({
			'opacity':'0',
			'height' : '0px'
	}, 2000);
	$('#flash_error').animate({
			'opacity':'0',
			'height' : '0px'
	}, 2000);
	$('form').submit(function(event){
			$('#flash_notice','#flash_error').css('display','block');
	});	
});
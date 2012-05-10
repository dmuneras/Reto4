// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require private_pub
//= require_tree .


$('document').ready(function(){
	
	$('#flash_error').css('display', 'none');
	$('#flash_notice, #flash_error').animate({
			'opacity':'0',
			'height' : '0px'
	}, 2000);
	$('form').submit(function(event){
			event.preventDefault();
			$('#flash_notice').css('display','block');
			$('#flash_error').css('display','block');
			$('#flash_error').css('opacity','1');
			$('#flash_error').css('height','25px');
			$('#flash_error').animate({
				'opacity':'0',
				'height' : '0px'
			}, 2000);
	});	
});
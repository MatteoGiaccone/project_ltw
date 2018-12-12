/* ----------------------------------------------------------------------------
 *	Project for 'Linguaggi e Tecnologie per il Web'
 *	Authors: Matteo Giaccone, Paolo Lucchesi
 *	Sticky navigation bar script
 * ------------------------------------------------------------------------- */
$(document).ready(function(){

  $('body').scrollspy({ target: '#navbar' });

  $(".navbar-collapse ul li a[href^='#'], .scroll-animate").on('click',function(e){

	target = this.hash;
	e.preventDefault();

	$('html,body').animate({
	  scrollTop : $(this.hash).offset().top
	}, 600, function(){
	  window.location.hash = target;
	});

	$(".navbar-collapse").collapse('hide');

  });

  var scroll = 0;
  $(document).scroll(function(){
	scroll = $(this).scrollTop();

	if(scroll > 200) {		// Scrolled page
	  $(".navbar").css({
		  "background-color": "#486f8b",
		  "margin-top" : "0px"
	  });
	}
	else {		// Top
	  $(".navbar").css({
		  "background-color": "transparent",
		  "margin-top" : "20px"
	  });
	}
  });
});

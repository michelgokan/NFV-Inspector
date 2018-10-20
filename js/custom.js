 //Backstretch - Background slideshow
 $('.wrapper').backstretch([
     "images/background.jpg"
 ], {
     duration: 3000,
     fade: 750
 });

 $(document).ready(function() {

     //Page Loading
     $(".animsition").animsition({
         inClass: 'fade-in',
         outClass: 'fade-out',
         inDuration: 300,
         outDuration: 800,
         linkElement: '.a-link',
         // e.g. linkElement: 'a:not([target="_blank"]):not([href^="#"])'
         loading: true,
         loadingParentElement: 'body', //animsition wrapper element
         loadingClass: 'animsition-loading',
         loadingInner: '', // e.g '<img src="loading.svg" />'
         timeout: false,
         timeoutCountdown: 5000,
         onLoadEvent: true,
         browser: ['animation-duration', '-webkit-animation-duration'],
         // "browser" option allows you to disable the "animsition" in case the css property in the array is not supported by your browser.
         // The default setting is to disable the "animsition" in a browser that does not support "animation-duration".
         overlay: false,
         overlayClass: 'animsition-overlay-slide',
         overlayParentElement: 'body',
         transition: function(url) {
             window.location.href = url;
         }
     });

     $('body').on('animsition.inEnd', function() {
         $('#particles-js').addClass('instate');
         setTimeout(function() {
             $('.pageContent').addClass('instate');
             $('h1.logo').addClass('animated fadeInDown');
             $('.pageContent h2').addClass('animated zoomIn');
             $('.pageContent h5, .pageContent p, .countdownHolder').addClass('animated fadeInUp');
             $('.subscribeButton').addClass('animated fadeInLeft');
             $('.infoButton').addClass('animated fadeInRight');
         }, 300);
     });

     //Subsscripbe Form - Mailchimp
     $('#mc_embed_signup').find('form').ajaxChimp();

     //Countdown
     var note = $('#note'),
         ts = new Date(2012, 0, 1),
         newYear = true;

     if ((new Date()) > ts) {
         // The new year is here! Count towards something else.
         // Notice the *1000 at the end - time must be in milliseconds
         ts = ((new Date("12/1/2018")) - Date.now());
         newYear = false;
     }

     $('#countdown').countdown({
         timestamp: ts
     });

     //Sidebar Contents - 3D Transition Effect 
     $(".infoButton").on("click",function() {
         $('body').addClass("active");
         $('.infoClose').delay(300).fadeIn();
     });
     $(".infoClose").on("click",function() {
         $('body').removeClass("active");
         $(this).fadeOut('fast');
     });

     //Magnific Popup
     $('.portfolio').magnificPopup({
         type: 'image',
         removalDelay: 300,
         mainClass: 'mfp-with-zoom',
         gallery: {
             enabled: true
         },
         zoom: {
             enabled: true,
             duration: 300,
             easing: 'ease-in-out',
             opener: function(openerElement) {
                 return openerElement.is('img') ? openerElement : openerElement.find('img');
             }
         }
     });

     //Custom Scrollbar
     $('.sidebar').mCustomScrollbar({
         scrollInertia: 100,
         theme: "dark"
     });

 });
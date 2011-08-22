$(document).ready(
    function() {
      $('#popup').hide();
      $('#overlay').hide();
      $('#wait_1').hide();
      $('#wait_2').hide();
      $('#wait_3').hide();
      $('.retailer_logo').hide();

      $('.next-button').click(
        function()
        {
          $('#popup').toggle();
          $('#overlay').toggle();
          $('#wait_1').delay(50).fadeIn('slow');
          $('#wait_2').delay(200).fadeIn('slow');
          $('#wait_3').delay(300).fadeIn('slow');
          var currentDelay = 300;
          if ($.browser.msie ) {
            $('.retailer_logo').show();
          }
          else {
            var retailers = $('.retailer_logo');
            for (var i=0; i<retailers.length; i++) {
              currentDelay += 50 + 150 * Math.random();
              $('.retailers .retailer_logo:nth-child('+(i+1).toString()+')').delay(currentDelay).fadeIn('Slow');
            }
          }
        }
      );
    }
);


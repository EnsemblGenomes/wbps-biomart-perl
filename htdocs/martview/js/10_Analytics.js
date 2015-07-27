$(document).ready(function() {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  // Tell Google who we are    
  ga('create', 'UA-24717231-5', 'auto');
  // Trigger a pageview event
  ga('send', 'pageview');
  
  // Some listeners to track events
  $('.mart_btn_count').click(function() {
    ga('send', 'event', 'biomart', 'count', 'click count on biomart');
  });
  $('.mart_btn_results').click(function() {
    ga('send', 'event', 'biomart', 'results', 'click results on biomart');
  });
  $('.mart_btn_new').click(function() {
    ga('send', 'event', 'biomart', 'new', 'click new on biomart');
  });
  $('.mart_btn_go').click(function() {
    ga('send', 'event', 'biomart', 'file', 'download file on biomart');
  });
});


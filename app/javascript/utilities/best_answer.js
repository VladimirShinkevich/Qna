$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.best-answer-link', function(e) {
    e.preventDefault();
    var answerId = $(this).data('answerId');
    $.ajax({
      type: 'POST',
      url: '/answers/'+answerId+'/mark_as_best',
    });
  });
}); 

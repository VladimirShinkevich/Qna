$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.delete-answer-link', function(e) {
    e.preventDefault();
    var answerId = $(this).data('answerId');
    $.ajax({
      type: 'DELETE',
      url: '/answers/'+answerId,
    })
  })
}) 

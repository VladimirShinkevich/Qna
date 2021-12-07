$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    let questionId = $(this).data('questionId');
    console.log(questionId);
    $('form#edit-question-' + questionId).removeClass('hidden');
  })
});

$(document).on('turbolinks:load', function () {

  $('.question').on('ajax:success', function (event) {
    
    vote = event.detail[0].vote;
    rating = event.detail[0].rating;
    
    $('.question p.vote-link-like').remove();
    $('.question p.vote-link-dislike').html('<p> You ' + vote.status + ' this ' + vote.votable_type.toLowerCase() + '</p>');
    $('.question h4.vote-rating').html('Current rating: ' + rating);
  })

  $('.question').on('ajax:error', function (e) {
      errors = e.detail[0];

      $.each(errors, function (index, value) {
        $('.question-errors').append('<p>' + value + '</p>');
      })

    })

  $('.question').on('ajax:success', function (event) {
    rating = event.detail[0].rating;

    $('.question p.cancel-vote-link').html('<p> You delete your vote! </p>')
    $('.question p.vote-rating').html('Current rating: ' + rating);
  })
})
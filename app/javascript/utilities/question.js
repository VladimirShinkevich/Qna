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

  $('.question .vote').on('ajax:success', function (event) {
    
    vote = event.detail[0].vote;
    rating = event.detail[0].rating;
    
    $('.question .vote p.vote-link-like').remove();
    $('.question .vote p.vote-link-dislike').html('<p> You ' + vote.status + ' this ' + vote.votable_type.toLowerCase() + '</p>');
    $('.question .vote h4.vote-rating').html('Current rating: ' + rating);
  })

  $('.question .vote').on('ajax:error', function (e) {
      errors = e.detail[0];

      $.each(errors, function (index, value) {
        $('.question-errors').append('<p>' + value + '</p>');
      })

    })

  $('.question .vote .cancel-vote-link').on('ajax:success', function (event) {
    rating = event.detail[0].rating;

    $('.question .vote .cancel-vote-link').html('<p> You delete your vote! </p>')
    $('.question .vote h4.vote-rating').html('Current rating: ' + rating);
  })
})
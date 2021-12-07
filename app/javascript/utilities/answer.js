$(document).on('turbolinks:load', function(){
	$('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    console.log(answerId);
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
});

$(document).on('turbolinks:load', function () {
  $('.answers').on('ajax:success', function (event) {

    vote = event.detail[0].vote;
    rating = event.detail[0].rating;
    answer_id = vote.votable_id;
    
    $('#answer-' + answer_id + ' p.vote-link-like').remove();
    $('#answer-' + answer_id + ' p.vote-link-dislike').html('<p> You ' + vote.status + ' this ' + vote.votable_type.toLowerCase() + '</p>');
    $('#answer-' + answer_id + ' h4.vote-rating').html('Current rating: ' + rating);
  })

  $('.answers p.cansel-vote-link').on('ajax:success', function (event) {
    rating = event.detail[0].rating;
    answer_id = event.detail[0].votable_id;

    $('#answer-' + answer_id + ' p.cancel-vote-link').html('You delete your vote!')
    $('#answer-' + answer_id + ' h4.vote-rating').html('Current rating: ' + rating);
  })
})
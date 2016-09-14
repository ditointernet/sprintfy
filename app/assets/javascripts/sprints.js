$(function() {
  $('#show-add-goal-form-btn').on('click', function(event) {
    event.preventDefault();

    $('.sprintfy-add-goal-form').removeClass('is-hidden');
    $(this).addClass('is-hidden');
  });

  $('#show-add-sprint-user-form-btn').on('click', function(event) {
    event.preventDefault();

    $('.sprintfy-add-sprint-user-form').removeClass('is-hidden');
    $(this).addClass('is-hidden');
  });
});

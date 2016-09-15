$(function() {
  $('#show-add-goal-form-btn').on('click', function(event) {
    event.preventDefault();

    $('.sprintfy-add-goal-form').removeClass('is-hidden');
    $(this).addClass('is-hidden');
  });

  $('#show-add-sprint-user-form-btn').on('click', function(event) {
    event.preventDefault();

    $('.sprintfy-add-sprint-user-form').removeClass('is-hidden');
    $('#sprint-users-menu').addClass('is-hidden');
  });

  $('#show-edit-sprint-story-points-form-btn').on('click', function(event) {
    event.preventDefault();

    $('.sprintfy-sprint-users').addClass('is-hidden');
    $('#sprintfy-edit-sprint-story-points-form').removeClass('is-hidden');
  });
});

$(function() {
  $('#show-add-goal-form-btn').on('click', function(event) {
    event.preventDefault();

    $('.sprintfy-add-goal-form').removeClass('is-hidden');
    $(this).addClass('is-hidden');
  });

  $('#show-add-sprint-user-form-btn').on('click', function(event) {
    event.preventDefault();

    $('.sprintfy-add-sprint-user-form').toggleClass('is-hidden');
  });

  $('#show-edit-sprint-story-points-form-btn').on('click', function(event) {
    event.preventDefault();

    $('#sprint-users-table').toggleClass('is-hidden');
    $('#sprintfy-edit-sprint-story-points-form').toggleClass('is-hidden');
  });
});


$(function() {
  function showWhatToChangeBox() {
    var squadId = $('#sprint_squad_id').val();

    $('.what-to-change-box').addClass('is-hidden');
    $('#what-to-change-' + squadId).removeClass('is-hidden');
  }

  $('#sprint_squad_id').on('change', function(event) {
    event.preventDefault();
    showWhatToChangeBox();
  });

  showWhatToChangeBox();
});


$(function() {
  $('#show-update-sprint-dates-btn').on('click', function(event) {
    event.preventDefault();

    $('#edit-sprint-btns').addClass('is-hidden');
    $('#update-sprint-dates-form').removeClass('is-hidden');
  });
});

$(function() {
  function getDailyMeetingParams(form) {
    return {
      done: form.find('[name="daily_meeting[done]"]'),
      skip: form.find('[name="daily_meeting[skip]"]'),
      reason: form.find('[name="daily_meeting[reason]"]'),
    };
  }

  $('.sprintfy-dm-form .dm-done').on('click', function(event) {
    event.preventDefault();

    var form = $(this).parent().parent();

    getDailyMeetingParams(form).done.val(true);
    form.submit();
  });

  $('.sprintfy-dm-form .dm-not-done').on('click', function(event) {
    event.preventDefault();

    var modal = $('#sprintfy-dm-not-done-reason-modal');

    modal.addClass('is-active');
    modal.data('form-count', $(this).data('form-count'));
  });

  $('.sprintfy-dm-form .dm-skip').on('click', function(event) {
    event.preventDefault();

    var form = $(this).parent().parent();

    getDailyMeetingParams(form).skip.val(true);
    form.submit();
  });


  $('#sprintfy-dm-not-done-reason-modal .delete, #sprintfy-dm-not-done-reason-modal .cancel-button').on('click', function(event) {
    event.preventDefault();

    var modal = $('#sprintfy-dm-not-done-reason-modal');

    modal.find('.reason-textarea').val('');
    modal.removeClass('is-active');
  });

  $('#sprintfy-dm-not-done-reason-modal .send-button').on('click', function(event) {
    event.preventDefault();

    var modal = $('#sprintfy-dm-not-done-reason-modal');
    var reasonTextarea = modal.find('.reason-textarea');
    var form = $('#sprintfy-dm-form-' + $(modal).data('form-count'));

    getDailyMeetingParams(form).reason.val(reasonTextarea.val());

    reasonTextarea.val('');
    modal.removeClass('is-active');

    form.submit();
  });
});

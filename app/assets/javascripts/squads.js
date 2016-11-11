$(function() {
  $('#sprintfy-squad-add-manager-btn').on('click', function(event) {
    event.preventDefault();

    $(this).addClass('is-hidden');
    $('#sprintfy-squad-add-manager-form').removeClass('is-hidden');
  });
});

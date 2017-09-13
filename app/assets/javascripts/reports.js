$( window ).load(function() {
  users = $('#report-group');
  periods = $('#report-period');
  squads = $('#squad_squad_id');
  person = $('#user_user_id');

  periods.prop( "disabled", true );
  squads.prop( "disabled", true );
  person.prop( "disabled", true );

  users.change(function() {
    if(users.val() == 'everyone')
    {
      periods.prop( "disabled", true );
      squads.prop( "disabled", true );
      person.prop( "disabled", true );
    }
    else if(users.val() == 'squad') {
      periods.prop( "disabled", false  );
      squads.prop( "disabled", false );
      person.prop( "disabled", true );
    }
    else if(users.val() == 'user') {
      periods.prop( "disabled", false  );
      squads.prop( "disabled", true );
      person.prop( "disabled", false );
    }
  });

  $('#report-form').submit(function(e) {
    periods.prop( "disabled", false );
    squads.prop( "disabled", false );
    person.prop( "disabled", false );
    if(users.val() == 'squad' && squads.val() == '')
    {
      e.preventDefault();
      alert('Select a squad to continue');
      return false;
    }
    if(users.val() == 'user' && person.val() == '')
    {
      e.preventDefault();
      alert('Select a user to continue');
      return false;
    }
  });
});

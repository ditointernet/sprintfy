$( window ).load(function() {
  users = $('#filter_user');
  periods = $('#filter_period');
  squads = $('#filter_squad');

  if(users.val() == 'Todos')
  {
    periods.prop( "disabled", true );
    squads.prop( "disabled", true );
  }

  users.change(function() {
    if(users.val() == 'Todos')
    {
      periods.prop( "disabled", true );
      squads.prop( "disabled", true );
    }
    else if(users.val() == 'Equipe') {
      periods.prop( "disabled", false  );
      squads.prop( "disabled", false );
    }
  });

  $('#report-form').submit(function(e) {
    if(users.val() == 'Equipe' && squads.val() == '')
    {
      e.preventDefault();
      alert('Select a squad to continue');
      return false;
    }
  });
});

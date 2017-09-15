$( window ).load(function() {
  users = $('#filter_user');
  periods = $('#filter_period');
  squads = $('#filter_squad');
  person = $('#filter_person');

  if(users.val() == 'Todos')
  {
    periods.prop( "disabled", true );
    squads.prop( "disabled", true );
    person.prop('disabled',true)
  }
  else if(users.val() == 'Equipe')
  {
    periods.prop( "disabled", false );
    squads.prop( "disabled", false );
    person.prop('disabled',true)
  }
  else if(users.val() == 'Individual')
  {
    periods.prop( "disabled", false );
    squads.prop( "disabled", true );
    person.prop('disabled',false)
  }

  users.change(function() {
    if(users.val() == 'Todos')
    {
      periods.prop( "disabled", true );
      squads.prop( "disabled", true );
      person.prop( "disabled", true );
    }
    else if(users.val() == 'Equipe') {
      periods.prop( "disabled", false  );
      squads.prop( "disabled", false );
      person.prop( "disabled", true );
    }
    else if(users.val() == 'Individual') {
      periods.prop( "disabled", false  );
      squads.prop( "disabled", true );
      person.prop( "disabled", false );
    }
  });

  $('#report-form').submit(function(e) {
    if(users.val() == 'Equipe' && squads.val() == '')
    {
      e.preventDefault();
      alert('Select a squad to continue');
      return false;
    }
    if(users.val() == 'Individual' && person.val() == '')
    {
      e.preventDefault();
      alert('Select a user to continue');
      return false;
    }
  });
});

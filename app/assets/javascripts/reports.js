$( window ).load(function() {
  users = $('#filter_user');
  periods = $('#filter_period');
  squads = $('#filter_squad');
  person = $('#filter_person');

  if(users.val() == 'Todos')
  {
    squads.prop( "disabled", true );
    person.prop('disabled',true);
    periods.val('Mensal');
  }
  else if(users.val() == 'Equipe')
  {
    squads.prop( "disabled", false );
    person.prop('disabled',true);
  }
  else if(users.val() == 'Individual')
  {
    squads.prop( "disabled", true );
    person.prop('disabled',false);
  }

  users.change(function() {
    if(users.val() == 'Todos')
    {
      squads.prop( "disabled", true );
      person.prop( "disabled", true );
      periods.val('Mensal');
    }
    else if(users.val() == 'Equipe') {
      squads.prop( "disabled", false );
      person.prop( "disabled", true );
    }
    else if(users.val() == 'Individual') {
      squads.prop( "disabled", true );
      person.prop( "disabled", false );
    }
  });

  periods.change(function(){
    if(users.val() == 'Todos')
    {
      periods.val('Mensal');
    }
  });

  $('#report-form').submit(function(e) {
    if(users.val() == 'Equipe' && (squads.val() == '' || period.val() == ''))
    {
      e.preventDefault();
      alert('Selecione todas as opções para continuar');
      return false;
    }
    else if(users.val()=='Individual' && (person.val()=='' || period.val()==''))
    {
      e.preventDefault();
      alert('Selecione todas as opções para continuar');
      return false;
    }
    else if (user.val() == 'Todos')
    {
      periods.val('Mensal');
    }
  });
});

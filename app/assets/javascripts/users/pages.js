$(function() {
  var rolesEl = $('#roles');

  rolesEl
    .select2({ placeholder: 'Permissões' })
    .select2('val', [rolesEl.data('default-role-id')]);
});

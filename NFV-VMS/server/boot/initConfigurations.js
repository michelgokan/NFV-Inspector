'use strict';

module.exports = function(app) {
  /*
   * The `app` object provides access to a variety of LoopBack resources such as
   * models (e.g. `app.models.YourModelName`) or data sources (e.g.
   * `app.datasources.YourDataSource`). See
   * https://loopback.io/doc/en/lb3/Working-with-LoopBack-objects.html
   * for more info.
   */

  app.models.configuration.find().then(function(configs){
    if(configs.length == 0 || configs == undefined){
      const system_name = "NFV-VMS";
      const version = "1.0.0";

      console.log("Adding system information...");
      console.log("System name: "+system_name);
      console.log("Version: "+version);
      app.models.system_information.create({
        name: system_name,
        version: version
      });

      var User = app.models.User;
      var Role = app.models.Role;
      var RoleMapping = app.models.RoleMapping;

      var filtered = User.settings.hidden.filter(function(item)
        {
          return item !== 'password' && item != 'verificationToken';
        }
      );
      User.settings.hidden = filtered;

      User.create([
        {username: 'admin', email: 'admin@admin.admin', password: 'opensesame'}
      ], function(err, users) {
        if (err) return console.debug('%j', err);

        Role.create({
          name: 'admin'
        }, function(err, role) {
          if (err) return console.debug(err);
          console.debug(role);

          role.principals.create({
            principalType: RoleMapping.USER,
            principalId: users[0].id
          }, function(err, principal) {
            if (err) return console.debug(err);
            console.debug(principal);

            User.login({email: 'admin@admin.admin', password: 'opensesame'});
          });
        });
      });

    }
  });
};

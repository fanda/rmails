Changelog
=========

v0.2.4 - 2013-06-16
--------------------

 - Changed rake task name. system:install -> rmails:install.

### Features and improvements ###

 - New rake task. rmails:publish. Task for developer. Increase version and distribute application on Rubygems and Github

### Bug fixes ###

 - Added application helper for publication release. Fixes broken installation process.




v0.2.3 - 2013-06-14
--------------------


### Features and improvements ###

 - Added data_yml gem and rmails param --clear, so install procedure saves data in the beginning and restores database in the end.
 - Domains management use routes to edit, delete and manage actions.


 - Script bin/rmails had bad condition in param check.


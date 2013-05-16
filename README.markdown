Rmails
============

A Ruby on Rails application which automates an installation and initial configuration of mail server which consists of freely available program components and which enables its additional configuration via interactive web interface.

For Debian based servers. CentOs, Fedora and Gentoo support will be added in near future.




Requirements
------------

Tested with ruby 1.8.7 and 1.9.3.


Rubygems required.


Project Maturity
----------------

It is not a mature project and small modifications in configuration may be needed. Application tests have not been created yet.


Installation
------------

Via rubygems.org:

    gem install rmails


Using git (recommended as in development)

    git clone https://github.com/fanda/rmails.git


Getting Started
---------------

### GIT (recommended)


Use git for installation:

    git clone https://github.com/fanda/rmails.git

Then install all dependencies with bundler

    cd rmails; bundle install


And finally run rake task as the root or with sudo

    sudo rake system:install


to install all necessary programs, make initial configuration and start system services.

Web application for administration can be started with

    bin/rmails --start-app

or

    rails server


### Rubygems

There may still be some errors with install script, but *rmails* script would be added in your PATH, so all you have to do is:

    sudo rmails  --install

to install all necessary programs, make initial configuration and start system services.

Web application for administration can be started with

    bin/rmails --start-app


License
-------

Rmails is released under the [MIT License](https://github.com/fanda/rmails/blob/devel/LICENSE.txt)

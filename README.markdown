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


Using git:

    https://github.com/fanda/rmails.git


Getting Started
---------------

Script rmails should be added, then

    rmails --install


to install all necessary programs, make initial configuration and start system services.

Web application for administration can be started with

    rmails --start-app



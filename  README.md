Lamepress
=========

Lamepress is a Content Managment System for issuing magazines/newspapers. It's written in Ruby language and rails framework. The deal of Lamepress is to make building and managing of magazines/newspapers as simple and easy as possible, also to give readers an easy way to browse current and older issues.

###Demo
Give a try to [Lamepress](http://press.lamezor.gr/admin)
email: demo@email.com
password: lamepress 

###Installation
1. `git@github.com:mikezaby/Lamepress.git`
2. Run `bundle install` in project folder
3. Make a database.yml like database.yml.example in config folder with your credentials
4. Type rake db:create:all to create your databases
5. Type rake db:schema:load to create database schema
6. Type rake db:seed to load basic data
7. Run passenger start or rails s

For admin login, go to localhost:3000/admin
email: demo@email.com
password: lamepress

###License
MIT License. Copyright &copy; 2012 Michael Zamparas



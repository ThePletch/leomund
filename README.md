# Leomund
Leomund is a room reservation manager and automator for Northeastern University student organizations.

Leomund exposes a web interface that lets club members submit room requests and club officers approve them, handling all interactions with Northeastern's scheduling department behind the scenes.

## Folder structure

### api
All Lambda functions go in the correspondingly-named Coffeescript file. `template.coffee` contains a template for new Lambda functions. Run `api/compile_lambdas.bash` to compile lambda functions.

### auto-filler
Contains the code that automatically fills out the reservations form

### helpers
Contains helper modules that are compiled and pulled into `node_modules` before Lambda functions are packaged.

### www
Contains static website files.

##### www/src
Contains the source code for the website (Pug/SASS/Coffeescript). Edit this to make changes to the site. Run `www/compile_website.bash` to build into HTML/CSS/JS.

##### www/compiled
Contents are gitignored by default. Compiled files from `src` will be copied here.

### spec
Unit tests.

## To do
* Investigate unit tests for Lambda functions
* Set up JS unit testing library
* Replace compilation bash files with Grunt tasks
* Grunt task to run unit tests
* Set up NPM to allow easy cloning of above
* Write up docs on setting up on AWS from scratch

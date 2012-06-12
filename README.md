Description
===========

ProjectMonitor is a CI display aggregator. It displays the status of multiple
Continuous Integration builds on a single web page.  The intent is that you
display the page on a big screen monitor or TV so that the status of all your
projects' builds are highly visible/glanceable (a "Big Visible Chart").
ProjectMonitor currently supports:

  * [Cruise Control](http://cruisecontrolrb.thoughtworks.com/)
  * [Jenkins](http://jenkins-ci.org/)
  * [TeamCity](http://www.jetbrains.com/teamcity/)

We use ProjectMonitor internally at Pivotal Labs to display the status of the
builds for all our client projects. We also have an instance of ProjectMonitor
running at [ci.pivotallabs.com](http://ci.pivotallabs.com) that we use for
displaying the status of the builds of various open source projects - both of
projects Pivotal Labs maintains (such as Jasmine) and of non-Pivotal projects
(such as Rails).

## Installation

### Get the code

ProjectMonitor is a Rails application. To get the code, execute the following:

    git clone git://github.com/pivotal/projectmonitor.git
    cd projectmonitor
    bundle install

### Initial Setup

We have provided example files for `database.yml`, `auth.yml`, and
`site_keys.rb`.  Run the following to automatically generate these files for
you:

    rake setup

You likely need to edit the generated files.  See below.

### Set up the database

You'll need a database. Create it with whatever name you want.  If you have not
run `rake setup`, copy `database.yml.example` to `database.yml`.  Edit the
production environment configuration so it's right for your database:

    cp config/database.yml.example config/database.yml
    <edit database.yml>
    RAILS_ENV=production rake db:create
    RAILS_ENV=production rake db:migrate

### Auth support

Adding, editing and removing projects through the UI requires authentication.

If you have not run `rake setup`, copy `auth.yml.example` to `auth.yml`.

    cp config/auth.yml.example config/auth.yml

The site can be configured to use Google OpenId or to use the
RestfulAuthentication plugin.

#### Google OpenId setup

This setup requires you to have Google apps set up for your domain. 

In your `config/auth.yml` set the `auth_strategy` to `openid`. Then set the
`openid_identifier`, `openid_realm`, and `openid_return_to` fields as
appropriate for your domain.

#### Restful Authentication (`password`) setup 

In the `config/auth.yml` set the `auth_strategy` to `password`, and edit the
`rest_auth_site_key` to be something secret.

### Set up cron

Add a cron job at whatever frequency you like for the following command:

    RAILS_ENV=production rake cimonitor:fetch_statuses > fetch_statuses.log 2>&1

This is what goes out and hits the individual builds. We find that if you do
this too frequently it can swamp the builds. On the other hand, you don't want
ProjectMonitor displaying stale information. At Pivotal we set it up to run
every 3 minutes.  Also, make sure that you set your PATH correctly in crontab
to include the 'bundle' executable.

### Start workers

The cron job above will add jobs to the queue, which workers will execute.  To
start running the workers, use the following command:

    rake start_workers

The default number of workers is 2, but if you wanted 3 you would call it like this:

    rake start_workers[3]

These workers need only be started once per system reboot, and must be running
for your project statuses to update.  To stop the workers, run this command:

    rake stop_workers

The workers are implemented using the [delayed_job
gem](http://github.com/collectiveidea/delayed_job).  The workers are configured
to have a maximum timeout of 1 minute when polling project status.  If you want
to change this setting, you can edit `config/initializers/delayed_job_config.rb`

### Start the application

Execute:

    nohup script/server -e production &> cimonitor.log

## Configuration

Each build that you want ProjectMonitor to display is called a "project" in
ProjectMonitor. You need to login to set up projects.


### Create a user

ProjectMonitor can use either the [Restful Authentication
plugin](http://github.com/technoweenie/restful-authentication), or Google
OpenId for user security. If you are using Google OpenId, users will be
automatically provisioned.  All users from your domain will be permitted to
edit projects. Otherwise, use the following steps to add users by hand.

Your first user must be created at the command line.

    script/console production
    User.create!(login: 'john', name: 'John Doe', email: 'jdoe@example.com', password: 'password', password_confirmation: 'password')

After that, you can login to ProjectMonitor with the username and password you
specified and use the "New User" link to create additional users.

### Log in

Open a browser on ProjectMonitor. Login by clicking on "Login" in the upper-right corner.

### Add projects

Click on "Projects" in the upper-right corner. Click on "New Project" and enter
the details for a build you want to display on ProjectMonitor. The "Name",
"Project Type", and "Feed URL" are required. If your Feed URL is
http://myhost.com:3333/projects/MyProject, then your RSS URL is probably
http://myhost.com:3333/projects/MyProject.rss.

#### TeamCity
To configure TeamCity:

*   Choose Team City Rest Project for the project type
*   URL looks like: http://teamcity:8111/app/rest/builds?locator=running:all,buildType:(id:bt*) where * is the buildTypeId from the TeamCity Build Configuration.
*   Requires a username and password that match a valid account in TeamCity with access to the Build Configuration.

NOTE: The Cradiator-TeamCity-Plugin is deprecated. Please use the Team City
Rest Project configuration, which is natively supported by TeamCity 5+.

Optionally, if your Build system is behind Basic Authentication or Digest
Authentication, you can enter the credentials.

If you want to temporarily hide your build on ProjectMonitor, you can uncheck
the "Enable" checkbox.

ProjectMonitor's main display page is at `/`. You can always get back there by
choosing the number of tiles you want at the lower left.

### Auto-start for Ubuntu

In order to have cimonitor starts when the machine boots, modify the startup
scripts.  In the following example, we have modified /etc/rc.local on an Ubuntu
10.04 server (change paths & userids as needed):

    # need to set PS1 so that rvm is in path otherwise .bashrc bails too early
    su - pivotal -c 'PS1=ps1; . /home/pivotal/.bashrc; cd ~/cimonitor/current; bundle exec thin -e production start -c /home/pivotal/cimonitor/current -p7990 -s3; bundle exec rake start_workers[6]'

## Display

Just open a browser on `/`. The page will refresh every 60 seconds. When it
refreshes, it shows whatever status was last fetched by the cron job. That is,
a refresh doesn't cause the individual builds to be polled.

### Layout

The new layout consists of a grid of tiles representing the projects.  The
number of projects that need to be displayed is determined automatically, but
can also be set explicitly.  There are views available for 15 tiles, 24 tiles,
48 tiles, or 63 tiles, and a 6-project view with larger tiles is coming soon.

### Tile colors

Tiles are green for green projects, red for red projects, and light gray if the
project's build server cannot be reached.

### Project Ticker Codes

Each tile shows the project's brief ticker code.  If not chosen explicitly,
this will be the first 4 letters of the project. The name of the project
appears below in a smaller font.

### Build Statuses

To the right of the ticker and name, each project lists the amount of time
since the last build, followed by the build status history.  The last 10 builds
are displayed from left to right, in reverse chronological order -- the most
recent build will be on the top left and the least recent on the bottom right.
Successful builds are marked with a filled in circle, and unsuccessful builds
are marked with an x.  Builds in progress are shown with an oscillating motion.

### Aggregate Projects

Striped tiles indicate the aggregate status of several projects.  Click on an
aggregate project to see the status of its component projects.

### Admin Interface

Click 'manage projects' at the lower right to edit project details.

## Notifications

ProjectMonitor can inform you of builds that have been red for more than 24 hours. Set up cron to daily execute:

    RAILS_ENV=production rake cimonitor:red_over_one_day_notification > red_over_one_day_notification.log 2>&1

## Tags

You can enter tags for a project (separated by commas) on the project edit page.  You can then have ProjectMonitor display
only projects that match a set of tags by going to /?tags=tag1,tag2

## CI

CI for ProjectMonitor is [here](http://cibuilder.pivotallabs.com:3333/builds/ProjectMonitor), and it's aggregated at [ci.pivotallabs.com](http://ci.pivotallabs.com)
(that's an instance of ProjectMonitor, of course).

## Development

The public Tracker project for ProjectMonitor is [here](http://www.pivotaltracker.com/projects/2872).

To run tests, run:

    rake setup
    rake spec

To run a local development server and worker, run:

    foreman start

## Ideas /Improvements

Got a burning idea that just needs to be implemented? Join the google group and share it with the team.

The google group for Project Monitor is [projectmonitor_pivotallabs](http://groups.google.com/group/projectmonitor_pivotallabs)

Copyright (c) 2012 Pivotal Labs. This software is licensed under the MIT License.

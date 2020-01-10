# gaedkeeper

# Getting Started

## Setup (Manual)

 - `bundle install` (if yarn install is giving issues, delete yarn.lock and run yarn install again)
 - `cp ./config/application.yml.example ./config/application.yml` (fill up missing field details accordingly, some items may need to be obtained from the admin)
 - `bundle exec rake db:create db:schema:load db:seed`
 - Please go to admin menu in `/admin` and login with your admin credentials. Select "Solar PV System" and add in a plan to allow residential property to be saved

## Development

 - Always create a new branch prior to starting new development
 - Please pull the latest changes by running `git pull --rebase origin master` before pushing branch


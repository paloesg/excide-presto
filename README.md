# Excide-presto

Excide Presto is an office procurement platform to allow businesses to purchase products and services conveniently.

## System Dependencies

The following are needed by this project:

* [PostgreSQL](http://www.postgresql.org/)

## Getting Started

Clone this repository and bundle.

    git clone https://github.com/hschin/excide-presto.git
    cd excide-presto
    bundle install

Create and initialize the database using this command:

    rails db:setup

After creating, it will prompt you to type in email and password.

Next, in your command prompt, install `imagemagick` using:

    brew install imagemagick

Load the sample data using `rails spree_sample:load`

Start the application server.

    rails server

Access the application at [http://localhost:3000/](http://localhost:3000/).

## Testing

Run the test suite with [RSpec](https://github.com/rspec/rspec-rails).

    bin/rspec spec

Or have them run automatically with [Guard](https://github.com/guard/guard-rspec).

    bundle exec guard

## Branching

* `master` is the active development branch

Make a new branch to work on your development:

    git checkout -b <name_of_branch>

You can check the location of your branch using `git branch` command.

All local development should be done in the appropriately named branches:

* `feature/<branch_name>` for substantial new features or functions
* `enhance/<branch_name>` for minor feature or function enhancement
* `refactor/<branch_name>` for code refactoring of existing functions
* `bugfix/<branch_name>` for bug fixes

**WARNING: Do not merge your changes directly into your local master
branch and push to GitHub!!!**

If you are done developing the component you are working on, push your branch to github
and open a [pull request](https://help.github.com/articles/creating-a-pull-request/) to the `master` branch.

Give your pull request a title and describe what you are trying to
achieve with your code. The branch or release manager will review your
code and take the next appropriate actions.



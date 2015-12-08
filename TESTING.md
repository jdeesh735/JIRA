This cookbook uses a variety of testing components:

- Unit tests: [ChefSpec](https://github.com/acrmp/chefspec)
- Integration tests: [Test Kitchen](https://github.com/opscode/test-kitchen)
- Chef Style lints: [Foodcritic](https://github.com/acrmp/foodcritic)
- Ruby Style lints: [Rubocop](https://github.com/bbatsov/rubocop)

Prerequisites
-------------

This repo is prepared for testing via one of two `test-kitchen` drivers,
**Vagrant** or **DigitalOcean**.

To develop on this cookbook, you must have a sane Ruby 1.9+ environment. Given the nature of this installation process (and it's variance across multiple operating systems), we will leave this installation process to the user.

You must also have `bundler` installed:

    $ gem install bundler

Further prerequisites depend on which driver you will use.

#### Vagrant

You must also have Vagrant and VirtualBox installed:

- [Vagrant](https://vagrantup.com)
- [VirtualBox](https://virtualbox.org)

Once installed, you must install the `vagrant-berkshelf` plugin:

    $ vagrant plugin install vagrant-berkshelf

#### DigitalOcean

You must acquire and set the proper environment variables for the active
shell:

    $ export DIGITALOCEAN_ACCESS_TOKEN=<your-access-token>
    $ export DIGITALOCEAN_SSH_KEY_IDS=<numeric-key-id-1>,<numeric-key-id-2>

And then copy or symlink the `.kitchen.digitalocean.yml` file as your
local override:

    $ ln -s .kitchen.digitalocean.yml .kitchen.local.yml

Development
-----------
1. Clone the git repository from GitHub:

        $ git clone git@github.com:afklm/chef_COOKBOOK.git

2. Install the dependencies using bundler:

        $ bundle install

3. Create a branch for your changes:

        $ git checkout -b my_bug_fix

4. Make any changes
5. Write tests to support those changes. It is highly recommended you write both unit and integration tests.
6. Run the tests:
    - `bundle exec rspec`
    - `bundle exec foodcritic .`
    - `bundle exec rubocop`
    - `bundle exec kitchen test`

7. Assuming the tests pass, open a Pull Request on GitHub

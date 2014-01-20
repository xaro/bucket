# Bucket

A Command Line Interface for [BitBucket](https://bitbucket.org).
*For now, only `git` is supported. Mercurial support is planned.*

## Installation

Add this line to your application's Gemfile:

~~~ sh
gem 'bucket-cli'
~~~

And then execute:

~~~ sh
$ bundle
~~~

Or install it yourself as:

~~~ sh
$ gem install bucket-cli
~~~

## Usage

### Setup
After the installation, you can run

~~~ sh
$ bucket setup
~~~

to start the configuration.

You need to add your BitBucket username and password (for now it's saved in *plaintext* in `~/.bucket` with a permission bit of `0600`, in the future this will change for oauth authorization).

### Init repository
You can initialize a new repository (as in doing `git init`), and automagically creating the repository on BitBucket and adding the remote to `origin`.

~~~ sh
$ bucket init DIRECTORY
~~~

This will create a new (private) repository in `DIRECTORY` (can be `.` for current directory), and create a repository named after the destination folder (or as specified in the options) in your BitBucket account.

#### Options

    --name        NAME  A name for the repository in BitBucket
    --description DESC  A description for the repository in BitBucket
    --public            Mark the repository as public (private by default)

### Cloning
You can clone a repository directly from BitBucket with

~~~ sh
$ bucket clone [USER]/REPOSITORY
~~~

where `REPOSITORY` is the repository name.

If `[USER]` is not supplied, it's assumed you want a repository from your own account. For example, if you want to clone the `bucket-cli` repository from your own account you can just use

~~~ sh
$ bucket clone bucket-cli
~~~

but if it's from another account you need to specify it

~~~ sh
$ bucket clone xaro/bucket-cli
~~~

### Listing repositories
You can list the repositories associated with your account by using

~~~ sh
$ bucket repos
~~~

## TODO
* Change direct git calls to ruby git gem
* Improve error reporting (easier with the git gem)
* Add more commands
* Shallow redirect commands to git / mercurial
* Replace bitbucket api gem (it has too many dependencies and is not complete)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

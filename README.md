# Pseudocephalopod #

## About ###

Pseudocephalopod is a simple slug library for ActiveRecord 3.0 plus.

It's main features are:

1. A very simple and tested codebase
2. Support for slug history (e.g. if a users slug changes, it will record the old slug)
3. Simple defaulting for slugs to UUID's (to avoid showing ID's.)
4. Built on ActiveRecord 3.0
5. If stringex is installed, uses stringex's transliteration stuff

Also, it's name is inspired by the Jason Wander series of books which I just happened to be
reading when I had the need for this.

### Why? ###

I love the idea of friendly\_id, and most of the implementation but it felt bloated
to me and my experiences on getting it to work correctly with Rails 3 left a base taste
in my mouth / was altogether hacky.

Pseudocephalopod is very much inspired by friendly id but with a much simpler codebase
and built to work on Rails 3 from the start.

## Usage ##

Using Pseudocephalopod is simple. In Rails, simply drop this in your Gemfile:

    gem 'pseudocephalopod'
    
Optionally restricting the version.

Next, if you wish to use slug history run:

    $ rails generate pseudocephalopod:slugs
    
Otherwise, when calling is\_sluggable make sure to include :history => false

Next, you need to add a cached slug column to your model and add an index. In your migration,
you'd usually want something like:

    add_column :users, :cached_slug, :string
    add_index :users,  :cached_slug
    
Or, using our build in generator:

    $ rails generate pseudocephalopod:slug_migration Model
    
Lastly, in your model, call is\_sluggable:

    class User
      is_sluggable :name
    end
    
is\_sluggable accepts the source method name as a symbol, and an optional has of options including:

* _:sync_ - when source column changes, save the result. Defaults to true.
* _:convertor_ - a symbol (for a method) or block for how to generate the base slug. Defaults to :to\_url if available, parameterize otherwise.
* _:history_ - use slug history (e.g. if the name changes, it records the previous version in a slugs table). Defaults to true
* _:uuid_ - If the slug is blank, uses a generated uuid instead. Defaults to true
* _:slug\_column_ - the column in which to store the slug. Defaults to _:cached\_slug_
* _:to\_param_ - if true (by default), overrides to_param to use the slug
* _:use\_cache_ - uses Pseudocephalopod.cache if available to cache any lookups e.g. in memcache.

Once installed, it provides the following methods:

### User.find\_using\_slug "some-slug" ###

Finds a user from a slug (which can be the record's id, it's cached slug or, if enabled, slug history)

### User.other\_than(record) ###

Returns a relationship which returns records other than the given.

### User.with\_cached\_slug(record) ###

Returns a relationship which returns records with the given cached slug.

### User#generate\_slug ###

Forces the generation of a current slug

### User#generate\_slug! ###

Forces the generation of a current slug and saves it

### User#autogenerate\_slug ###

Generates a slug if not already present.

### User#has\_better\_slug? ###

When found via Model.find\_using\_slug, it will return try
if there is a better slug available. Intended for use in redirects etc.

## Working on Pseudocephalopod ##

To run tests, simply do the following:

    bundle install
    rake

And it's ready!

## Contributors ##

Thanks to the following who contributed functionality / bug fixes:

* [Matt Pruitt](http://github.com/guitsaru)

## Note on Patches/Pull Requests ##
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright ##

Copyright (c) 2010 Darcy Laycock. See LICENSE for details.

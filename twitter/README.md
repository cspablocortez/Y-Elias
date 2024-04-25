# Y

Y is a microblogging platform like X built in Ruby on Rails.

### Installation

We will install Ruby on Rails in our local development environment.

Go to the Github directory created by `Github Desktop`:

```bash
cd ~/Documents/Github
```

Install Rails:

```bash
gem install rails
```

Check installed version:

```bash
rails -v
```

### A New App

Create a new Rails app:

```bash
rails new myapp --database=postgresql
```

```bash
cd myapp
```

Create a local database:

```bash
bin/rails db:create
```

**After removing the default welcome page**, create a `Procfile`: 

Deploying a Rails 7 app without a Procfile executes the following command, but Heroku [recommends](https://devcenter.heroku.com/articles/getting-started-with-rails7#create-a-procfile) explicitly declaring how to boot the server process.

```bash
echo "web: bundle exec puma -C config/puma.rb" > Procfile
```

### Deployment (IGNORE)

Create a Heroku app:

```bash
heroku create
```

Add the `x86_64-linux` and `ruby` platforms to `Gemfile.lock`.

```bash
bundle lock --add-platform x86_64-linux --add-platform ruby
```

Create a database addon for your Heroku app:

```bash
heroku addons:create heroku-postgresql:mini
```

Deploy:

```bash
git push heroku main
```

Migrate the database:
```bash
heroku run rake db:migrate
```

Done!

### Adding Users with the `devise` gem

1. Add the [devise](https://github.com/heartcombo/devise) gem to your `Gemfile`.

```bash
gem 'devise'
```

Then run `bundle install` in the terminal.

2. Set up `devise`:

```bash
rails generate devise:install
```

Carefully read the instructions provided to configure your environment. 

3. Generate the User Model

```bash
rails generate devise User
```

This creates a migration, a model, and the Devise routes.

4. Add additional fields to the app by going to the newest file created inside the `migrate`/`mature` directory of `db`.

5. Run the Rails database migrations to create the users with the new fields:

```bash
rails db:migrate
```

6. Configure Devise Parameters

Since we added new paramaters (`username` and `name`), we have to update the `application_controller.rb` file:

```ruby
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name])
  end
end
```

7. Finally: Update Views

```bash
rails g devise:views
```

Then, modify the `app/views/devise/registrations/new.html.erb` and `app/views/devise/registrations/edit.html.erb` to include input fields for the additional attributes.

### Class Friday 26 April -- Making Tweets belong to Users

1. Delete all current tweets.

2. Create a migration to add a user_id column to the Tweets database:

```bash
rails generate migration AddUserToTweets user:references
```

3. Update Models

In your `Tweet` model (`app/models/tweet.rb`):

```ruby
class Tweet < ApplicationRecord
  belongs_to :user
end
```

In your `User` model (`app/models/user.rb`):

```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets
end
```

4. Adjust `TweetsController` to ensure tweets are created with an associated user:

```ruby
class TweetsController < ApplicationController
  
  # previous code ... 

  def create
    @tweet = current_user.tweets.new(tweet_params)
    if @tweet.save
      redirect_to tweets_path, notice: 'Tweet was successfully created.'
    else
      render :new
    end
  end  

  # more code ...
end
```

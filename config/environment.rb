# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
    :user_name => 'apikey',
    :password => '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',
    :domain => 'localhost',
    :address => 'smtp.sendgrid.net',
    :port => 465,
    :authentication => :plain,
    :enable_starttls_auto => true,
    :ssl        => true,
    :tls        => true

}
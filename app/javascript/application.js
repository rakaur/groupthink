// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// TODO: Disable turbo until we need it in the future
Turbo.session.drive = false

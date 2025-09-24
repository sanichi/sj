class PagesController < ApplicationController
  # see https://github.com/CanCanCommunity/cancancan/wiki/Non-RESTful-Controllers
  authorize_resource class: false

  def env
    @passenger_version = `env -i /usr/bin/passenger-config --version`.scan(/\d+\.\d+\.\d+/).first if Rails.env.production?
    psql = ActiveRecord::Base.connection.execute('select version();').values[0][0] rescue "oops"
    @postgres_version = psql.match(/PostgreSQL (1[4-8]\.\d+)/)? $1 : "not found"
    @puma_version = Puma::Const::VERSION if Rails.env.development?
    @host = ENV["HOSTNAME"] || `hostname`.chop.sub(".local", "")
  end
end

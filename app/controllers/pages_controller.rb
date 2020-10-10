class PagesController < ApplicationController
  # see https://github.com/CanCanCommunity/cancancan/wiki/Non-RESTful-Controllers
  authorize_resource class: false
end

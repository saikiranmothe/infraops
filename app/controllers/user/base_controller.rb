class User::BaseController < ApplicationController
  
  layout 'admin'

  before_filter :require_user, :set_navs, :parse_pagination_params
  
end

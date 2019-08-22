class StaticPagesController < ApplicationController
  def home
    @teams = Team.all
    
  end
end

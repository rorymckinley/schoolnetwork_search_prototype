class SitesController < ApplicationController
  def index
    @sites = Site.all
  end

  def new
    
  end

  def bulk_create
    params[:sites].split("\n").each do |site_name|
      Site.create name: site_name.chomp
    end
    redirect_to :sites
  end
end

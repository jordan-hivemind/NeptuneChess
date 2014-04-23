class PathController < ApplicationController

  def index
    @paths = Path.where(:processed => nil)
    respond_to do |format|
      format.xml  # index.builder
    end
    @paths.each do |p|
      update_attribute(:processed => true)
    end
  end  
end
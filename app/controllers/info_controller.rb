class InfoController < ApplicationController
  skip_before_filter :authenticate_user!

  def homepage
    render layout: "homepage"
  end

  def docs

  end

  def stats

  end

  def about

  end
end
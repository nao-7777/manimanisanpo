class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, hide: true, only: [:terms, :privacy], raise: false

  layout false
  def terms; end
  def privacy; end
end
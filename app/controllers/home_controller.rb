class HomeController < ApplicationController
  skip_before_filter :authenticate!

  def index
    return unless current_user
    if can?(:create, Course)
      redirect_to courses_path
    elsif current_user.courses.empty?
      redirect_to new_enrollment_path
    else
      redirect_to course_path(current_user.courses.first)
    end
  end
end

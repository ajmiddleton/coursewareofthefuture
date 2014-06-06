require 'spec_helper'

feature "Instructor manages courses", js: true do

  scenario "Creating a course" do
    signin_as(:instructor)
    visit root_path
    click_link "Create New Course"
    fill_in "Title", with: "Cohort 4"
    fill_in "Syllabus", with: "Foobar"
    fill_in "Start Date", with: "2014/01/24"
    fill_in "End Date", with: "2014/03/24"
    fill_in "Source Repository", with: "elizabrock/source"
    click_button "Create Course"
    page.should have_content "Course successfully created"
    Course.where(title: "Cohort 4", syllabus: "Foobar",
                 start_date: "2014/01/24", end_date: "2014/03/24").count.should == 1
  end

  scenario "Failing to create a course" do
    signin_as(:instructor)
    visit root_path
    click_link "Create New Course"
    click_button "Create Course"
    page.should have_content "Course couldn't be created"
    page.should have_error_message("can't be blank", on: "Title")
    page.should have_error_message("can't be blank", on: "Syllabus")
    page.should have_error_message("can't be blank", on: "Source Repository")
    fill_in "Title", with: "Cohort 4"
    fill_in "Syllabus", with: "Foobar"
    fill_in "Start Date", with: "2014/01/24"
    fill_in "End Date", with: "2014/03/24"
    fill_in "Source Repository", with: "elizabrock/source"
    click_button "Create Course"
    page.should have_content "Course successfully created"
    Course.where(title: "Cohort 4", syllabus: "Foobar",
                 start_date: "2014/01/24", end_date: "2014/03/24").count.should == 1
    end

  scenario "Only the information for the active course is shown to students" do
    Timecop.travel(Time.new(2013, 02, 24))
    Fabricate(:course, title: "Cohort 3", end_date: "2013/01/14")
    Fabricate(:course, title: "Cohort 4", end_date: "2014/02/28")
    Fabricate(:course, title: "Cohort 5", end_date: "2014/04/14")
    signin_as :student
    visit root_path
    page.should have_button("Join Cohort 4")
    page.should have_button("Join Cohort 5")
  end

  scenario "Students see markdown formatted syllabus" do
    course = Fabricate(:course, title: "Cohort 4", syllabus: "This is *awesome*.")
    signin_as :student, courses: [course]
    visit root_path
    page.should have_css("em", text: "awesome")
  end
end

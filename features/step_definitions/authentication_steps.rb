Given(/^I am signed in as (.*)$/) do |name|
  if name == "an instructor"
    user = Fabricate(:instructor)
    user.courses << Course.active_or_future.all
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name =~ /instructor for that course/
    user = Fabricate(:instructor)
    @course.users << user
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name == "an instructor for a course"
    user = Fabricate(:instructor)
    @course = Fabricate(:course)
    @course.users << user
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name == "a student in that course"
    user = Fabricate(:student)
    @course.users << user
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name == "a student"
    user = Fabricate(:student)
    sign_into_github_as(user.github_username, user.github_uid)
  else
    user = User.where(name: name).first
    sign_into_github_as(user.github_username, user.github_uid)
  end
  visit '/users/auth/github'
  @user = User.find_by_github_username(user.github_username)
end

Given(/^I am signed in to Github as "(.*?)"$/) do |username|
  sign_into_github_as(username)
end

When(/^I sign out$/) do
  click_link "Sign Out"
end

When(/^sign in as a student in that course$/) do
  step "I am signed in as a student in that course"
end

def sign_into_github_as(username, uid = nil)
  if uid.nil?
    user = User.find_by_github_username(username)
    uid = user.try(:github_uid) || '12345'
  end
  OmniAuth.config.add_mock(:github, {
    uid: uid,
    credentials: {
      token: "d141ef15f79ca4c6f43a8c688e0434648f277f20",
    },
    info: {
      nickname: username,
      email: "#{username}smith@example.com",
      name: "#{username.capitalize} Smith",
      image: "http://avatars.github.com/#{username}",
    },
    extra: {
      raw_info: {
        location: 'San Francisco',
        gravatar_id: '123456789'
      }
    }
  })
end

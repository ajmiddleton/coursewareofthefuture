class User < ActiveRecord::Base
  attr_accessor :viewing_as_student
  mount_uploader :photo, PhotoUploader
  devise :rememberable, :trackable, :omniauthable, :omniauth_providers => [:github]

  scope :instructors, ->{ where(instructor: true) }
  scope :observers, ->{ where(observer: true) }

  scope :except_instructors, ->{ where("instructor = false or instructor is null") }
  scope :except_observers, ->{ where("observer = false or observer is null") }
  scope :students, ->{ except_instructors.except_observers }

  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :milestones, through: :milestone_submissions
  has_many :milestone_submissions
  has_many :read_materials
  has_many :self_reports, inverse_of: :user
  has_many :quiz_submissions
  has_many :quizzes, through: :quiz_submissions

  validates_format_of :email, with: /\A[^@]+@[^@]+\z/, message: "must be an email address"
  validates_presence_of :github_access_token

  default_scope { order(name: :asc) }

  def become_instructor!
    self.instructor = true
    self.observer = false
    self.save!
  end

  def become_observer!
    self.instructor = false
    self.observer = true
    self.save!
  end

  def has_confirmed_photo?
    self.photo.present? && self.photo_confirmed?
  end

  def repositories
    octoclient.all_repositories(self.github_username)
  end

  def viewing_as_student?
    instructor? && @viewing_as_student
  end

  def self.find_or_create_for_github_oauth(auth)
    auth_token = auth.credentials.token
    user = User.where(github_uid: auth.uid).first_or_create do |user|
      user.github_access_token = auth_token
      user.github_uid = auth.uid
      user.github_username = auth.info.nickname
      user.name = auth.info.name
      user.email = auth.info.email
      user.remote_photo_url = auth.info.image
    end
    unless user.github_access_token == auth_token
      user.update_attribute(:github_access_token, auth_token)
    end
    user
  end

  def octoclient
    Octokit::Client.new(access_token: github_access_token)
  end
end

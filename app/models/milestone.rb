class Milestone < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :milestones
  has_many :milestone_submissions

  validate :deadline_must_be_appropriate, if: :deadline
  validates_presence_of :assignment
  validates_presence_of :deadline, if: ->{ assignment.published? }

  default_scope ->{ order("deadline ASC") }

  before_create :set_default_corequisite_fullpaths

  def corequisites
    corequisite_fullpaths.find_all{|fp| !fp.blank? }.map{ |fp| Corequisite.new(fp) }
  end

  private

  def deadline_must_be_appropriate
    if assignment.course.start_date > deadline or deadline > assignment.course.end_date.end_of_day
      errors.add(:deadline, "Must be in the course timeframe of #{assignment.course.start_date} to #{assignment.course.end_date}")
    end
  end

  def set_default_corequisite_fullpaths
    self.corequisite_fullpaths ||= []
  end
end

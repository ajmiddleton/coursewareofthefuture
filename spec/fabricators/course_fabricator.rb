Fabricator(:course) do
  title "Test Course"
  syllabus "Foo Bar and Plan"
  source_repository "elizabrock/inquizator-test-repo"
  start_date { Date.today }
  end_date { Date.today + 90 }
end

Fabricator(:past_course, from: :course) do
  start_date { Date.today - 120 }
  end_date { Date.today - 30 }
end

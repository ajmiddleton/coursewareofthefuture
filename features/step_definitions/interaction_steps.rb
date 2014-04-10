When(/^I (?:follow|click) "(.*?)"$/) do |text|
  click_link text
end

When(/^I fill in "(.*?)" for "(.*?)"$/) do |value, label|
  fill_in(label, with: value)
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |label, value|
  fill_in(label, with: value)
end

Then(/^"(.*?)" should be filled in for "(.*?)"$/) do |value, field|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should =~ /#{value}/
end


When(/^I press "([^"]*)"$/) do |text|
  click_button text
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  page.should_not have_content(text)
end

Then(/^I should not see:$/) do |table|
  table.raw.each do |content|
    page.should_not have_content(content[0])
  end
end

Then(/^I should see:$/) do |table|
  table.raw.each do |content|
    page.should have_content(content[0])
  end
end

Then /^(?:|I )should see the following list:$/ do |table|
  table.raw.each_with_index do |content, row|
    page.should have_xpath("//ul/li[#{row+1}][contains(normalize-space(.), '#{content[0]}')] | //ol/li[#{row+1}][contains(normalize-space(.), '#{content[0]}')] ")
  end
end

Then /^I should see the following options for "(.*?)":$/ do |field, option_texts|
  field = page.find_field(field)
  options = field.all("option")
  option_texts.diff!(options.map{|o| [o.text]})
end

When /^(?:|I )choose "([^"]*)" (?:for|from) "([^"]*)"$/ do |value, field|
  input = page.find(:xpath, "//div[contains(normalize-space(.), '#{field}')]/label[contains(text(), '#{value}')]/input")
  input.set(true)
end

Then(/^"(.*?)" should be choosen for "(.*?)"$/) do |value, field|
  parent = find(:css, "label", text: field).parent
  within(parent) do
    page.should have_checked_field(value)
  end
end

When /^(?:|I )select "([^"]*)" (?:for|from) "([^"]*)"$/ do |value, field|
  options = page.find_field(field).all("option")
  filtered_options = options.select{ |x| x.text =~ /#{value}$/ }
  raise 'too many options matched' if filtered_options.count > 1
  raise 'no options matched' if filtered_options.count == 0
  filtered_options.first.select_option
end

When(/^I select (\d+) (\w+) (\d+) from "(.*?)"$/) do |year, month, day, label|
  tag = page.find(:css, "label", text: label)[:for].gsub("_1i","")
  select year, from: "#{tag}_1i"
  select month, from: "#{tag}_2i"
  select day, from: "#{tag}_3i"
end

When(/^(\d+) (\w+) (\d+) should be selected for "(.*?)"$/) do |year, month, day, label|
  tag = page.find(:css, "label", text: label)[:for].gsub("_1i","")
  step %{"#{year}" should be selected for "#{tag}_1i"}
  step %{"#{month}" should be selected for "#{tag}_2i"}
  step %{"#{day}" should be selected for "#{tag}_3i"}
end

Then(/^"(.*?)" should be selected$/) do |descriptor|
  find(:option, descriptor).should be_selected
end

Then /^"([^"]*)" should be selected for "([^"]*)"$/ do |value, field|
  field_id = find(:field, field)[:id]
  page.should have_xpath "//select[@id = '#{field_id}']/option[@selected]"
end

When(/^I choose "([^"]*)"$/) do |label|
  choose label
end

When(/^I select "([^"]*)"$/) do |label|
  select label
end

When(/^I check "(.*?)"$/) do |label|
  check label
end

Then(/^I should see a "(.*?)" tag with the content "(.*?)"$/) do |tag, text|
  page.should have_css(tag, text: text)
end

Then /^(?:|I )should see the following:$/ do |table|
  table.raw.each_with_index do |content, row|
    page.should have_content(content[0])
  end
end

Then(/^I should see the following buttons:$/) do |table|
  table.raw.each_with_index do |content, row|
    page.should have_button(content[0])
  end
end

Then(/^I should not see the following buttons:$/) do |table|
  table.raw.each_with_index do |content, row|
    page.should_not have_button(content[0])
  end
end

Then(/^I should see the following calendar entries:$/) do |table|
  table.raw.each do |row|
    date = row[0]
    notice = row[1]
    page.should have_css("td[data-date='#{date}']", text: notice)
  end
end

Then /^I should see the error message "([^"]*)" on "([^"]*)"$/ do |text, field|
  selector = ".//div[contains(@class,'error') and ./label[contains(text(),'#{field}')]]/small[contains(text(),\"#{text}\")]"
  page.should have_xpath(selector)
end

When (/^I upload a file "(.*?)"$/) do |file|
  attach_file("user_photo", File.join(Rails.root, "/features/support/files/#{file}"))
end

Then(/^I should receive the image "(.*?)"$/) do |filename|
  page.response_headers['Content-Type'].should == "image/png"
  page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")
end

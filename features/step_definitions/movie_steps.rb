Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
end

# ============================================================================================= #

When /^I follow "(.*)"$/ do |link|
  click_link link
end

When /^I press "(.*)"$/ do |button|
  click_button button
end

When /^I (un)?check "(.*)"$/ do |uncheck, field|
  if uncheck
    uncheck field
  else
    check field
  end
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(', ').each do |field|
    if uncheck
      step "I uncheck \"ratings_#{field}\""
      step "the \"ratings_#{field}\" checkbox should not be checked"
    else
      step "I check \"ratings_#{field}\""
      step "the \"ratings_#{field}\" checkbox should be checked"
    end
  end
end

# ============================================================================================= #

Then /^the "(.*)" checkbox should( not)? be checked$/ do |label, unchecked|
  rating = label.split('_').last

  if unchecked
    assert !find_field(label)['checked'],
      "expected to find unchecked the option '#{rating}' in the form to filter by rating"
  else
    assert find_field(label)['checked'],
      "expected to find checked the option '#{rating}' in the form to filter by rating"
  end
end

Then /^I should (not )?see the following ratings: (.*)/ do |unseen, rating_list|
  ratings = page.all('table#movies tbody tr td[2]').map(&:text)

  rating_list.split(', ').each do |rating|
    if unseen
      assert !ratings.include?(rating), "expected to not see movies with rating '#{rating}' in the page"
    else
      assert ratings.include?(rating), "expected to see all movies with rating '#{rating}' in the page"
    end
  end
end

Then /^I should see (none|all) of the movies$/ do |quantity|
  rows = page.all('table#movies tbody tr td[1]').map(&:text)

  if quantity == 'none'
    assert rows.size.zero?, 'expected to not see any movie in the page'
  else
    assert rows.size == Movie.all.count, 'expected to see all movies in the page'
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  pending
end

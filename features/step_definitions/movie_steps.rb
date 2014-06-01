def values_from_column(column_name)
  position = "count(//thead/tr/th[text() = '#{column_name}']/preceding-sibling::th) + 1"

  all(:xpath, "//tbody/tr/td[#{position}]").map(&:text)
end

def movie_with(title)
  Movie.find_by_title(title)
end

# ============================================================================================= #

Given /^the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
end

Given /^I check the following ratings: (.*)/ do |rating_list|
  rating_list.split(', ').each do |rating|
    step "I check \"#{rating}\""
  end
end

Given /^I uncheck the following ratings: (.*)/ do |rating_list|
  rating_list.split(', ').each do |rating|
    step "I uncheck \"#{rating}\""
  end
end

Given /^I am on the details page for "(.*)"$/ do |title|
  visit movie_path(movie_with(title))
end

# ============================================================================================= #

When /^I follow "(.*)"$/ do |link|
  click_link link
end

When /^I press "(.*)"$/ do |button|
  click_button button
end

When /^I check "(.*)"$/ do |rating|
  check "ratings_#{rating}"
end

When /^I uncheck "(.*)"$/ do |rating|
  uncheck "ratings_#{rating}"
end

When /^I go to the edit page for "(.*)"$/ do |title|
  click_link "More about #{title}"
  click_link 'Edit'
end

When /^I fill in "(.*)" with "(.*)"$/ do |field, value|
  fill_in field, with: value
end

# ============================================================================================= #

Then /^I should see the following ratings: (.*)/ do |rating_list|
  rating_list.split(', ').each do |rating|
    expect(values_from_column('Rating')).to include rating
  end
end

Then /^I should not see the following ratings: (.*)/ do |rating_list|
  rating_list.split(', ').each do |rating|
    expect(values_from_column('Rating')).not_to include rating
  end
end

Then /^I should see all of the movies$/ do
  expect(values_from_column('Title').size).to eq(Movie.all.count),
    'expected to see all movies in the page'
end

Then /^I should see none of the movies$/ do
  expect(values_from_column('Title').size).to be_zero,
    'expected to not see any movie in the page'
end

Then /^"(.*)" should appear before "(.*)"$/ do |title1, title2|
  titles = values_from_column 'Title'

  expect(titles.index(title1)).to be < titles.index(title2),
    "expected '#{title1}' to appears before '#{title2}' in the page"
end

Then /^the director of "(.*)" should be "(.*)"$/ do |title, director|
  movie = movie_with(title)

  expect(movie.director).to eq(director),
    "expected director to be #{director}, but is #{movie.director}"
end

Then /^I should be on the Similar Movies page for "(.*)"$/ do |title|
  expect(current_path).to eq(from_same_director_movie_path(movie_with(title))),
    "expected current page to be movies from same director page"
end

Then /^I should see "(.*)"$/ do |title|
  expect(page).to have_content(title)
end

Then /^I should not see "(.*)"$/ do |title|
  expect(page).not_to have_content(title)
end

Then /^I should be on the home page$/ do
  expect(current_path).to eq(movies_path),
    "expected current page to be home page"
end

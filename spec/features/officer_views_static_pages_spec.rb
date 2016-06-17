require "rails_helper"

feature "Static pages" do
  scenario "Officer visits 'about' page" do
    visit response_plans_path
    click_on "About"

    expect(page).to have_content("Field Tester Background Information")
  end

  scenario "Officer visits 'about' page" do
    visit response_plans_path
    click_on "App Updates"

    expect(page).to have_content("0.0.1")
  end
end

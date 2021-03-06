# frozen_string_literal: true

require "rails_helper"

feature "Response Plan Form" do
  context "Creating a new response plan" do
    scenario "Officer fills in minimum information" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      person = create(:person)

      visit person_path(person)
      click_on t("people.show.draft.new")
      fill_in "First name", with: "John"
      fill_in "Last name", with: "Doe"
      fill_in "DOB", with: "01-30-1980"
      click_on "Update Response plan"

      expect(page).to have_content t("drafts.update.success", name: "John Doe")
      expect(page).to have_content t("drafts.show.title")
      expect(page).to have_content("John")
      expect(page).to have_content("Doe")
      expect(page).to have_content(l(Date.new(1980, 1, 30)))
    end

    scenario "Officer fills in all information" do
      officer = create(:officer, :owner)
      sign_in_officer(officer)
      person = create(:person, height_in_inches: 3)

      visit person_path(person)
      click_on t("people.show.draft.new")
      fill_in "First name", with: "John"
      fill_in "Middle initial", with: "Q"
      fill_in "Last name", with: "Doe"
      fill_in "DOB", with: "01-02-1980"
      fill_in "Weight", with: 160
      fill_in :response_plan_person_attributes_height_feet, with: 5
      fill_in :response_plan_person_attributes_height_inches, with: 3
      select "Blue", from: "Eye color"
      select "Brown", from: "Hair color"
      fill_in "Scars, Marks, and Tattoos", with: "Spider tattoo on neck"
      select "White", from: "Race"
      select "Male", from: "Sex"
      fill_in "Background info", with: "Lorem Ipsum Dolor Si Amet"
      fill_in "Baseline", with: "Baseline behavior"
      fill_in "Elevated", with: "Elevated behavior"
      fill_in(
        t("simple_form.labels.person.location_name"),
        with: "The Morrison Hotel",
      )
      fill_in "Location address", with: "509 3rd Ave"
      check t("simple_form.labels.person.location_supportive_housing")
      choose officer.name
      fill_in(
        t("simple_form.labels.response_plan.private_notes"),
        with: "These notes should be private",
      )
      click_on "Update Response plan"

      expect(page).
        to have_content t("drafts.update.success", name: "John Doe")
      expect(page).to have_content t("drafts.show.title")
      expect(page).to have_content("John")
      expect(page).to have_content("Q")
      expect(page).to have_content("Doe")
      expect(page).to have_content(l(Date.new(1980, 1, 2)))
      expect(page).to have_content("160 lb")
      expect(page).to have_content("5'3\"")
      expect(page).to have_content("Blue")
      expect(page).to have_content("Brown")
      expect(page).to have_content("Spider tattoo on neck")
      expect(page).to have_content("Lorem Ipsum Dolor Si Amet")
      expect(page).to have_content("Baseline behavior")
      expect(page).to have_content("Elevated behavior")
      expect(page).not_to have_content("These notes should be private")
    end

    scenario "Officer fills out form with errors" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      person = create(:person)

      visit person_path(person)
      click_on t("people.show.draft.new")
      fill_in "First name", with: ""
      click_on "Update Response plan"

      expect(page).to have_content "can't be blank"
    end

    scenario "Non-admin officer is not allowed access" do
      sign_in_officer
      person = create(:person)

      visit person_path(person)
      expect(page).not_to have_content t("people.show.draft.new")
    end
  end

  feature "nested forms", :js do
    scenario "adding a nested safety concern" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      plan = create(:response_plan)
      person = plan.person

      visit edit_draft_path(plan)
      click_on "+ Add safety concern"
      within(".safety_concern-fields") do
        select("Aslt. to Law Enforcement", from: "Category")
        fill_in("Title", with: "Spit at an officer")
        fill_in("Occurred on", with: "01-02-2016")
        fill_in("Description", with: "Spit at an officer")
        fill_in("Go number", with: "2016010101")
      end
      click_on "Update Response plan"

      person.reload
      new_plan = person.response_plans.last
      expect(page).to have_content("Aslt. to Law Enforcement".upcase)
      find(".profile-safety-concerns .toggle").trigger(:click)
      expect(page).to have_content("01-02-2016")
      expect(new_plan.safety_concerns.first.description).
        to eq("Spit at an officer")
    end

    scenario "removing a nested alias" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      plan = create(:response_plan)
      create(:alias, name: "Foo", person: plan.person)

      visit edit_draft_path(plan)
      click_on "Remove alias"
      expect(first(".alias-field input")).to be_nil
      click_on "Update Response plan"

      expect(page).not_to have_content("Foo")
    end

    scenario "removing a nested response strategy" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      title = "Call case manager"
      plan = create(:response_plan)
      create(:response_strategy, response_plan: plan, title: title)

      visit edit_draft_path(plan)
      click_on "Remove strategy"
      click_on "Update Response plan"

      expect(page).not_to have_content(title)
    end

    scenario "updating a nested response strategy" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      original_title = "Call case manager"
      new_title = "Response strategy 1"
      plan = create(:response_plan)
      create(:response_strategy, response_plan: plan, title: original_title)

      visit edit_draft_path(plan)
      first("input[name*='[title]']").set(new_title)
      click_on "Update Response plan"

      expect(page).not_to have_content(original_title)
      expect(page).to have_content(new_title)
    end
  end
end

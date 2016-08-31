require "rails_helper"

RSpec.feature "Response Plan Lifecycle" do
  include Permissions

  describe "creating a draft" do
    context "when the officer is not an admin" do
      scenario "they cannot create a draft"
    end

    context "when the officer is an admin" do
      scenario "they can draft a plan for a person who doesn't have one" do
        officer = create(:officer)
        sign_in_officer(officer)
        stub_admin_permissions(officer)
        person = create(:person)

        visit person_path(person)
        click_on t("response_plans.new.action")

        expect(page).to have_content t("response_plans.create.success.from_scratch")
      end

      scenario "they can draft a new plan for a person who already has one" do
        officer = create(:officer)
        stub_admin_permissions(officer)
        sign_in_officer(officer)
        person = create(:response_plan, :approved).person

        visit person_path(person)
        click_on t("response_plans.draft.new")

        expect(page).to have_content t("response_plans.create.success.from_previous")
      end

      xscenario "they cannot create multiple drafts for a person at the same time" do
        officer = create(:officer)
        stub_admin_permissions(officer)
        sign_in_officer(officer)
        plan = create(:response_plan, :draft)

        visit person_path(plan.person)
        click_on t("response_plans.edit.current_draft")

        # TODO confirm this redirect path
        expect(current_path).to eq(edit_draft_path(plan))
      end

      scenario "updating a draft" do
        person = create(:person, first_name: "Jane", last_name: "Doe")
        plan = create(:response_plan, :approved, person: person)
        officer = create(:officer)
        stub_admin_permissions(officer)
        sign_in_officer(officer)

        visit person_path(person)
        click_on t("response_plans.draft.new")
        fill_in "Background info", with: "Lorem Ipsum dolor si amet."
        click_on "Update Response plan"

        expect(page).to have_content t("response_plans.draft.title")
        # expect(page).
        #   to have_content(t("response_plans.draft.update.success", name: "Mary Doe"))
      end
    end
  end

  describe "managing drafts" do
    context "when the officer is not an admin" do
      scenario "they cannot view drafts"
    end

    context "when the officer is an admin" do
      scenario "they can edit a draft that they created" do
        officer = create(:officer)
        stub_admin_permissions(officer)
        sign_in_officer(officer)
        plan = create(:response_plan, :draft, author: officer)

        visit drafts_path
        click_on plan.person.shorthand_description
        click_on t("response_plans.draft.edit")

        expect(current_path).to eq(edit_draft_path(plan))
      end

      # Not sure if we want to do this or not
      scenario "they can(not?) edit a draft that someone else has created"

      scenario "they can submit a draft for approval" do
        officer = create(:officer)
        stub_admin_permissions(officer)
        sign_in_officer(officer)
        plan = create(:response_plan, :draft, author: officer)

        visit drafts_path
        click_on plan.person.shorthand_description
        click_on t("response_plans.draft.submit")

        # TODO confirm this redirect path
        expect(current_path).to eq(drafts_path)
        expect(page).to have_content(t("response_plans.draft.submitted"))
        expect(page).not_to have_content(plan.person.shorthand_description)
      end

      scenario "they can delete a draft that they've created"

      scenario "they can not delete a draft that another officer created"
    end
  end

  describe "approval" do
    context "when the officer is not an admin" do
      scenario "they cannot approve drafts"
    end

    context "when the officer is an admin" do
      scenario "they cannot delete a plan"
      scenario "they cannot approve a plan"
    end

    context "when the officer is a super admin" do
      scenario "they can approve submitted response plans" do
        officer = create(:officer)
        stub_admin_permissions(officer)
        sign_in_officer(officer)
        person = create(:response_plan, :submission).person

        visit submissions_path
        click_on person.shorthand_description
        click_on t("response_plans.submission.approve")

        # TODO confirm this redirect path
        expect(current_path).to eq(person_path(person))
        expect(page).to have_content t("response_plans.submission.approval.success", name: person.name)
        expect(page).not_to have_content t("response_plans.submission.title")
      end

      scenario "they cannot approve response plans that are still being drafted"
    end

    scenario "the author cannot approve it" do
      admin = create(:officer, username: "admin")
      stub_admin_permissions(admin)
      sign_in_officer(admin)
      plan = create(:response_plan, approver: nil, author: admin)

      visit submissions_path
      click_on plan.person.shorthand_description
      click_on t("response_plans.submission.approve")

      expect(plan.reload).not_to be_approved
      expect(page).to have_content(t("response_plans.submission.approval.failure"))
    end
  end
end

require "rails_helper"
include Warden::Test::Helpers

describe "Admin downloads CSV reports" do
  let!(:admin) { create(:admin) }
  before { login_admin(admin) }

  it "downloads CSV report" do
    visit admin_dashboard_index_path

    within first(".list-unstyled") do
      all("a", text: "Download").each do |link|
        link.click
        expect(page.response_headers["Content-Type"]).to eq("text/csv")
      end

      log = AuditLog.last
      expect(log.subject).to eq(admin)
      expect(log.action_type).to eq("reception-buckingham-palace")
    end
  end
end

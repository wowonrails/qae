class QAE2014Forms
  class << self
    def innovation_step1
      @innovation_step1 ||= Proc.new {
        options :applying_for, "Are you applying on behalf of your:" do
          ref 'A 1'
          required
          option 'organisation', 'Whole organisation'
          option 'division branch subsidiary', 'A division, branch or subsidiary'
        end

        header :business_division_header, '' do
          context %Q{
            <div class="application-notice help-notice">
              <p>Where the form refers to your organisation, please enter the details of your division, branch or subsidiary.</p>
            </div>
          }
          conditional :applying_for, 'division branch subsidiary'
        end

        text :company_name, 'Full/legal name of your organisation' do
          required
          ref 'A 2'
          context %Q{
            <p>If applicable, include 'trading as', or any other name your organisation uses.</p>
          }
        end

        options :principal_business, 'Does your organisation operate as a principal?' do
          required
          ref 'A 3'
          context %Q{
            <p>A principal invoices its customers (or their buying agents) and is the body to receive those payments. We recommend that you apply as a principal.</p>
          }
          yes_no
        end

        textarea :invoicing_unit_relations, 'Please explain your relationship with the invoicing unit, and the arrangements made.' do
          classes "sub-question"
          required
          conditional :principal_business, :no
          words_max 200
          rows 5
        end

        number :registration_number, 'Company/Charity Registration Number' do
          required
          ref 'A 4'
          context %Q{
            <p>If you don't have a Company/Charity Registration Number please enter 'N/A'. If you're an unregistered subsidiary, please enter your parent company's number.</p>
          }
          style "small"
        end

        date :started_trading, 'Date started trading' do
          required
          ref 'A 5'
          context "<p>Organisations that began trading after 01/10/2012 aren't eligible for this award.</p>"
          date_max '01/10/2012'
        end

        options :queen_award_holder, "Are you a current Queen's Award holder (2010-2014)?" do
          required
          ref 'A 6'
          yes_no
        end

        queen_award_holder :queen_award_holder_details, "List the Queen's Award(s) you currently hold" do
          classes "sub-question"

          conditional :queen_award_holder, :yes

          category :innovation_2, 'Innovation (2 years)'
          category :innovation_5, 'Innovation (5 years)'
          category :international_trade_3, 'International Trade (3 years)'
          category :international_trade_6, 'International Trade (6 years)'
          category :sustainable_development_2, 'Sustainable Development (2 years)'
          category :sustainable_development_5, 'Sustainable Development (5 years)'

          year 2010
          year 2011
          year 2012
          year 2013
          year 2014
        end

        options :business_name_changed, 'Have you changed the name of your organisation since your last entry?' do
          classes "sub-question"

          conditional :queen_award_holder, :yes

          yes_no
        end

        text :previous_business_name, 'Name used previously' do
          classes "regular-question"
          required
          conditional :business_name_changed, :yes
        end

        textarea :previous_business_ref_num, 'Reference number used previously' do
          classes "regular-question"
          required
          conditional :business_name_changed, :yes
          rows 5
          words_max 100
        end

        options :other_awards_won, 'Have you won any other business awards in the past?' do
          ref 'A 7'
          required
          yes_no
        end

        textarea :other_awards_desc, 'Please describe them' do
          classes "sub-question"
          required
          context "<p>If you can't fit all of your awards below, then choose those you're most proud of.</p>"
          conditional :other_awards_won, :yes
          rows 5
          words_max 300
        end

        options :innovation_any_contributors, 'Did any external organisation or individual contribute to your innovation?' do
          ref 'A 8'
          required
          context %Q{
            <p><span class='text-underline'>Excluding</span> suppliers and consultants.</p>
          }
          yes_no
        end

        options :innovation_joint_contributors, 'Is this application part of a joint entry with the contributing organisation(s)?' do
          classes "sub-question"
          required
          context %Q{
            <p>If you two or more organisations made a significant contribution to the innovation, and achieved commercial success, then you should make a joint entry. Each organisation should submit separate, cross-referenced, entry forms.</p>
          }
          conditional :innovation_any_contributors, :yes
          yes_no
        end

        textarea :innovation_contributors, 'Please enter their name(s)' do
          classes "sub-question"
          required
          conditional :innovation_any_contributors, :yes
          conditional :innovation_joint_contributors, :yes
          rows 5
          words_max 500
        end

        options :innovation_contributors_aware, 'Are they at least aware that you are applying for this award?' do
          classes "sub-question"
          required
          conditional :innovation_any_contributors, :yes
          conditional :innovation_joint_contributors, :no
          option :yes, 'Yes, they are aware'
          option :no, "No, they aren't aware"
          option :some, 'Some are aware'
        end

        header :innovation_contributors_aware_header_no, "" do
          context %Q{
            <p>We recommend that you notify all the contributors to your innovation of this entry.</p>
          }
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :no
          conditional :innovation_joint_contributors, :no
        end

        header :innovation_contributors_aware_header_some, "" do
          context %Q{
            <p>We recommend that you notify all the contributors to your innovation of this entry.</p>
          }
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :some
          conditional :innovation_joint_contributors, :no
        end

        options :innovation_under_license, 'Is your innovation under license from another organisation?' do
          ref 'A 9'
          yes_no
        end

        textarea :innovation_license_terms, 'Briefly describe the licensing arrangement.' do
          classes "sub-question"
          required
          conditional :innovation_under_license, :yes
          rows 5
          words_max 100
        end

        address :principal_address, 'Principal address of your organisation' do
          required
          ref 'A 10'
        end

        text :org_telephone, 'Main telephone number' do
          required
          ref 'A 11'
          style "small"
        end

        text :website_url, 'Website URL' do
          required
          ref 'A 12'
        end

        dropdown :business_sector, 'Business Sector' do
          required
          ref 'A 13'
          option "business_sector", 'Business Sector'
          option :other, 'Other'
        end

        text :business_sector_other, 'Please specify' do
          classes "regular-question"
          required
          conditional :business_sector, :other
        end

        header :parent_company_header, 'Parent Companies' do
          ref 'A 14'
          conditional :applying_for, :true
        end

        text :parent_company, 'Name of immediate parent company' do
          classes "sub-question"
          conditional :applying_for, 'division branch subsidiary'
        end

        country :parent_company_country, 'Country of immediate parent company' do
          classes "regular-question"
          conditional :applying_for, 'division branch subsidiary'
        end

        options :parent_ultimate_control, 'Does your immediate parent company have ultimate control?' do
          classes "sub-question"
          conditional :applying_for, 'division branch subsidiary'
          yes_no
        end

        text :ultimate_control_company, 'Name of organisation with ultimate control' do
          classes "regular-question"
          conditional :parent_ultimate_control, :no
          conditional :applying_for, 'division branch subsidiary'
        end

        country :ultimate_control_company_country, 'Country of organisation with ultimate control' do
          classes "regular-question"
          conditional :parent_ultimate_control, :no
          conditional :applying_for, 'division branch subsidiary'
        end

        options :parent_group_entry, 'Are you a parent company making a group entry?' do
          classes "sub-question"
          conditional :applying_for, 'organisation'
          context %Q{
            <p>A 'group entry' is when you are applying on behalf of multiple divisions/branches/subsidiaries under your control. </p>
          }
          yes_no
        end

        options :pareent_group_excluding, 'Are you excluding any members of your group from this application?' do
          classes "sub-question"
          conditional :applying_for, 'organisation'
          conditional :parent_group_entry, 'yes'
          yes_no
        end

        upload :org_chart, 'Upload an organisational chart (optional).' do
          ref 'A 15'
          context %Q{
            <p>You can submit files in all common formats, as long as they're less than 5mb.</p>
          }
          max_attachments 1
        end
      }
    end
  end
end

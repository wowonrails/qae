require "rails_helper"

describe FormAnswerStatistics::Picker do
  subject { described_class.new(award_year) }

  context "for current awarding year" do
    let(:award_year) { AwardYear.current }

    describe "#applications_table" do
      it "calculates proper stats" do
        pending "Fix because of changes with current year implementation"
        create(:user)
        create(:form_answer)
        Timecop.freeze(Date.today - 2.years) do
          fa = create(:form_answer)
          fa.state_machine.perform_transition(:submitted, nil, false)
        end

        fa1 = create(:form_answer, :trade)
        fa1.state_machine.perform_transition(:not_eligible, nil, false)
        Timecop.freeze(Date.today - 1.month) do
          create(:user)
        end

        expect(subject.applications_table[:registered_users][:counters]).to eq([3, 3, 4])
        expect(subject.applications_table[:applications_not_eligible][:counters]).to eq([1, 1, 1])
        expect(subject.applications_table[:applications_in_progress][:counters]).to eq([1, 1, 1])
        expect(subject.applications_table[:applications_submitted][:counters]).to eq([0, 0, 0])
      end
    end

    describe "#applications_submissions" do
      it "calculates proper stats" do
        create(:form_answer, :trade)
        fa1 = create(:form_answer, :trade)
        fa1.state_machine.perform_transition(:submitted, nil, false)

        Timecop.freeze(Date.today - 3.days) do
          fa2 = create(:form_answer, :trade)
          fa2.state_machine.perform_transition(:submitted, nil, false)
        end

        Timecop.freeze(Date.today - 8.days) do
          fa3 = create(:form_answer, :trade)
          fa3.state_machine.perform_transition(:submitted, nil, false)
        end

        expect(subject.applications_submissions["trade"]).to eq([1, 2, 3])
      end

      context "multiple submissions" do
        it "counts the submitted records only once" do
          Timecop.freeze(Date.today - 4.days) do
            fa1 = create(:form_answer, :trade)
            fa1.state_machine.perform_transition(:submitted, nil, false)
            fa1.state_machine.perform_transition(:submitted, nil, false)
          end
          expect(subject.applications_submissions["trade"]).to eq([0, 1, 1])
        end
      end
    end

    describe "#applications_completions" do
      it "calculates proper stats" do
        populate_application_completions
        expect(subject.applications_completions["trade"]).to eq([1, 1, 0, 1, 1, 0, 4])
      end
    end
  end

  context "for next awarding year" do
    let(:award_year) { AwardYear.where(year: AwardYear.current.year + 1).first_or_create }

    describe "#applications_table" do
      it "calculates the proper stats" do
        pending "Fix because of changes with current year implementation"
        fa1 = create(:form_answer)
        fa1.state_machine.perform_transition(:not_eligible, nil, false)

        create(:form_answer)
        fa2 = create(:form_answer)
        fa2.state_machine.perform_transition(:submitted, nil, false)

        date = Date.today.month == 12? Date.today + 12.months : Date.today + 12.months

        Timecop.freeze(date) do
          2.times do
            fa1 = create(:form_answer)
            fa1.state_machine.perform_transition(:not_eligible, nil, false)
            fa2 = create(:form_answer)
            fa2.state_machine.perform_transition(:submitted, nil, false)
            create(:form_answer) # application_in_progress
          end
        end
        expect(subject.applications_table[:applications_not_eligible][:counters]).to eq(["-", "-", 2])
        expect(subject.applications_table[:applications_in_progress][:counters]).to eq(["-", "-", 2])
        expect(subject.applications_table[:applications_submitted][:counters]).to eq(["-", "-", 2])
      end
    end

    describe "#applications_submissions" do
      it "calculates the proper stats" do
        create(:form_answer, :trade)
        fa1 = create(:form_answer, :trade)
        fa1.state_machine.perform_transition(:submitted, nil, false)

        date = Date.today.month == 12? Date.today + 12.months : Date.today + 12.months
        Timecop.freeze(date) do
          fa2 = create(:form_answer, :trade)
          fa2.state_machine.perform_transition(:submitted, nil, false)
          fa3 = create(:form_answer, :trade)
          fa3.state_machine.perform_transition(:submitted, nil, false)
        end
        expect(subject.applications_submissions["trade"]).to eq(["-", "-", 2])
      end
    end

    describe "#applications_completions" do
      it "calculates proper stats" do
        expect(subject.applications_completions["trade"]).to eq([0, 0, 0, 0, 0, 0, 0])

        date = Date.today.month == 12? Date.today + 12.months : Date.today + 12.months
        Timecop.freeze(date) do
          populate_application_completions
        end
        expect(subject.applications_completions["trade"]).to eq([1, 1, 0, 1, 1, 0, 4])
      end
    end
  end
end

def populate_application_completions
  create(:form_answer, :trade, state: "application_in_progress").update_column(:fill_progress, 0.0)
  create(:form_answer, :trade, state: "application_in_progress").update_column(:fill_progress, 0.25)
  create(:form_answer, :trade, state: "application_in_progress").update_column(:fill_progress, 0.50)
  create(:form_answer, :trade, state: "application_in_progress").update_column(:fill_progress, 1)
  create(:form_answer, :trade, state: "not_eligible").update_column(:fill_progress, 0.99)
end

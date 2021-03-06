class AggregatedAwardYearPdf < ActiveRecord::Base

  TYPES = %w(case_summary feedback)

  belongs_to :award_year

  validates :award_year_id, uniqueness: { scope: [:award_category, :type_of_report, :sub_type] },
                            presence: true

  validates :file,
            :award_category,
            :sub_type,
            :type_of_report, presence: true

  mount_uploader :file, FormAnswerPdfVersionUploader
end

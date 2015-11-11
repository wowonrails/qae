class QAEFormBuilder

  class QAEFormDecorator < QAEDecorator

    def form_name
      @decorator_options[:form_name] || 'form'
    end

    def progress
      required_visible_questions_filled.to_f / required_visible_questions_total
    end

    def required_visible_questions_filled
      count_questions :required_visible_questions_filled
    end

    def required_visible_questions_total
      count_questions :required_visible_questions_total
    end

    private

    def count_questions meth
      steps.map{|step| step.send meth}.reduce(:+)
    end

  end
end

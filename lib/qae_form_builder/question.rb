class QAEFormBuilder

  class QuestionBuilder
    def initialize q
      @q = q
    end

    def context text
      @q.context = text
    end

    def classes text
      @q.classes = text
    end

    def ref id
      @q.ref = id
    end

    def required
      @q.required = true
    end

    def help title, text
      @q.help << QuestionHelp.new(title, text)
    end

    def conditional key, value
      @q.condition = QuestionCondition.new key, value
    end

    def header header
      @q.header = header
    end

    def header_context header_context
      @q.header_context = header_context
    end
  end

  QuestionCondition = Struct.new(:question_key, :question_value)

  QuestionHelp = Struct.new(:title, :text)

  class Question
    attr_accessor :step, :key,  :title, :context, :opts,
      :required, :help, :ref, :condition, :header, :header_context, :classes

    def initialize step, key, title, opts={}
      @step = step
      @key = key
      @title = title
      @opts = opts
      @required = false
      @help = []
      self.after_create if self.respond_to?(:after_create)
    end

    def form
      step.form
    end

    def parameterized_title
      key.to_s + "-" + title.parameterize
    end

    def condition_value
      condition.question_value if condition
    end

    def condition_question
      form[condition.question_key] if condition
    end

  end

end


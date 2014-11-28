#= require jquery
#= require jquery_ujs
#= require ./frontend/textarea-autoResize
#= require ./frontend/text-character-count
#= require_tree .

jQuery ->
  # Hidden hints as seen on
  # https://www.gov.uk/service-manual/user-centred-design/resources/patterns/help-text
  # Creates the links and adds the arrows
  $(".hidden-link").wrap("<a href='#'></a>")
  # Adds the arrows
  $(".hidden-link").closest("a").prepend("<span class='hidden-arrow-right'>▶</span><span class='hidden-arrow-down'>▼</span>")
  # Adds click event to links
  $(document).on "click", ".hidden-hint a", (e) ->
    e.preventDefault()
    $(this).closest(".hidden-hint").toggleClass("show-hint")

  # Conditional questions that appear depending on answers
  $(".js-conditional-question, .js-conditional-drop-question").addClass("conditional-question")
  # Simple conditional using a == b
  $(".js-conditional-answer input, .js-conditional-answer select").change () ->
    answer = $(this).closest(".js-conditional-answer").attr("data-answer")
    question = $(".conditional-question[data-question='#{answer}']")
    answerVal = $(this).val()

    if $(this).attr('type') == 'checkbox'
      answerVal = $(this).is(':checked').toString()

    question.each () ->
      if $(this).attr('data-value') == answerVal || ($(this).attr('data-value') == "true" && answerVal != false)
        $(this).addClass("show-question")
      else
        $(this).removeClass("show-question")
  # Numerical conditional that checks that trend doesn't ever drop
  $(".js-conditional-drop-answer input").change () ->
    drop_question = $(this).closest(".js-conditional-drop-answer").attr('data-drop-question')
    drop = false

    $(".js-conditional-drop-answer[data-drop-question='#{drop_question}']").each () ->
      drop_answers = $(this).closest(".js-conditional-drop-answer")
      last_val = 0

      drop_answers.find("input").each () ->
        if $(this).val()
          value = parseFloat $(this).val()
          if value < last_val
            drop = true
          last_val = value

    question = $(".js-conditional-answer[data-answer='#{drop_question}']").closest(".js-conditional-drop-question")
    if drop
      question.addClass("show-question")
    else
      question.removeClass("show-question")

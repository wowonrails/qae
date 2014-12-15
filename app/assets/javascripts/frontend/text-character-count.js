// Gets character limit and allows no more
$(function() {
  // Creates the character count elements
  $(".js-char-count").wrap("<div class='char-count'></div>");
  $(".js-char-count").after("<div class='char-text'>Word count: <span class='current-count'>0</span></div>");

  // Includes charact limit if there is one
  $(".js-char-count").each(function(){
    var maxlength = parseInt($(this).attr('data-word-max'));
    if (maxlength) {
      $(this).before("<div class='char-text-limit'>Word limit: <span class='total-count'>" +maxlength+ "</span></div>");
      $(this).closest(".char-count").find(".char-text").append("/<span class='total-count'>" +maxlength+ "</span>");

      // hard limit to word count
      var maxlengthlimit = maxlength *0.1;
      if (maxlengthlimit < 5) {
        maxlengthlimit = 5;
      }
      $(this).attr("data-word-max-limit", (maxlengthlimit));
    }
  });

  function counting (counter) {
    textInput = $(this);

    textInput.closest(".char-count").find(".char-text .current-count").text(counter.words);

    // If character count is over the limit then show error
    if (counter.words > textInput.attr('data-word-max')) {
      textInput.closest(".char-count").addClass("char-over");

      // hard limit to word count using maxlength
      if (((typeof(textInput.attr("maxlength")) !== typeof(undefined)) && textInput.attr("maxlength") !== false) == false) {
        // Set through typing
        var char_limit = textInput.val().length + (textInput.attr("data-word-max-limit")*6);
        textInput.attr("maxlength", char_limit);
      }
    } else {
      textInput.closest(".char-count").removeClass("char-over");

      textInput.removeAttr("maxlength");
    }
  }

  // Maxlength for pasting text
  $('.js-char-count').bind("paste", function(e){
    e.preventDefault();
    var paste_this = ((e.originalEvent || e).clipboardData.getData('text/plain'))

    for (c = 0; c<paste_this.length; c++) {
      if (((typeof($(this).attr("maxlength")) !== typeof(undefined)) && $(this).attr("maxlength") !== false) == false || $(this).val().length <= $(this).attr("maxlength")) {
        $(this).val($(this).val() + paste_this[c]);
        Countable.once(this, counting);
      }
    }
  });

  $(".js-char-count").each(function() {
    // Goes through each letter of inputs so that maxlength is triggered by Countable
    var loaded_text = $(this).val();
    $(this).val("");
    for (c = 0; c<loaded_text.length; c++) {
      if (((typeof($(this).attr("maxlength")) !== typeof(undefined)) && $(this).attr("maxlength") !== false) == false || $(this).val().length <= $(this).attr("maxlength")) {
        $(this).val($(this).val() + loaded_text[c]);
        Countable.once(this, counting);
      }
    }

    // Makes word count dynamic
    Countable.live(this, counting)
  });
});

$.fn.charcount = function() {
  // Adds class to parent so that we can position the question and input closer
  var prevElement = this.closest(".question-group").prev();
  prevElement.addClass("char-spacing");
  if (prevElement.hasClass("errors-container")) {
    prevElement.prev().append("<span class='char-space'></div>");
  }

  // Creates the character count elements
  this.wrap("<div class='char-count'></div>");
  this.after("<div class='char-text'>Word count: <span class='current-count'>0</span></div>");

  // Includes character limit if there is one
  this.each(function(){
    var maxlength = parseInt($(this).attr("data-word-max"));
    if (maxlength) {
      $(this).before("<div class='char-text-limit'>Word limit: <span class='total-count'>" +maxlength+ "</span></div>");
      $(this).closest(".char-count").addClass("char-max-shift");
      $(this).closest(".char-count").find(".char-text").append("/<span class='total-count'>" +maxlength+ "</span>");

      // hard limit to word count
      var maxlengthlimit = maxlength *0.1;
      if (maxlengthlimit < 5) {
        maxlengthlimit = 5;
      }
      // Strict limit with no extra words
      if ($(this).closest(".word-max-strict").size() > 0) {
        maxlengthlimit = 0;
      }
      $(this).attr("data-word-max-limit", (maxlengthlimit));
    }
  });

  var counting = function(counter) {
    textInput = $(this);

    textInput.closest(".char-count").find(".char-text .current-count").text(counter.words);

    // If character count is over the limit then show error
    var characterOver = function(textInput) {
      var lastLetter = textInput.val()[textInput.val().length - 1];

      if (counter.words > textInput.attr("data-word-max")) {
        return true;
      } else if (counter.words == textInput.attr("data-word-max") && lastLetter == " ") {
        return true;
      }
    };

    if (characterOver(textInput)) {
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
  this.bind("paste", function(e){
    e.preventDefault();
    var paste_this = ((e.originalEvent || e).clipboardData.getData("text/plain"))

    for (c = 0; c<paste_this.length; c++) {
      if (((typeof($(this).attr("maxlength")) !== typeof(undefined)) && $(this).attr("maxlength") !== false) == false || $(this).val().length <= $(this).attr("maxlength")) {
        $(this).val($(this).val() + paste_this[c]);
        Countable.once(this, counting);
      }
    }
  });

  this.each(function() {
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

  return this;
}
// Gets character limit and allows no more
$(function() {
  // Creates the character count elements
  $(".js-char-count").charcount();
});


$.fn.removeCharcountElements = function() {
  // Removes the character count elements
  $(this).unwrap();
  $(".char-text, .char-text-limit", $(this).closest("li")).remove();
}

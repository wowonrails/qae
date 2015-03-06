ready = ->
  changeRagStatus()
  editFormAnswerAutoUpdate()
  bindRags("#section-appraisal-form-primary form")
  bindAppraisalFields("#section-appraisal-form-primary form")
  bindRags("#section-appraisal-form-secondary form")
  bindAppraisalFields("#section-appraisal-form-secondary form")

  $('#new_form_answer_attachment').fileupload
    success: (result, textStatus, jqXHR)->
      $('.document-list .p-empty').remove()
      $('.document-list ul').append(result)

  formClass = '.edit_form_answer_attachment'

  $(document).on 'click', "#{formClass} a", (e) ->
    form = $(this).parents(formClass)
    $.ajax
      url: form.attr('action'),
      type: 'DELETE'
    form.parents('.form_answer_attachment').remove()
    if $('.form_answer_attachment').length == 0
      noDoc = $("<p class='p-empty'></p>")
      noDoc.text('No documents have been attached to this case.')
      $('.document-list').prepend(noDoc)


  $(document).on "click", ".js-switch-admin-view", (e) ->
    e.preventDefault()
    $(".applicant-view").toggleClass("hidden")
    $(".submitted-view").toggleClass("hidden")

  $(document).on "click", ".form-edit-link", (e) ->
    e.preventDefault()
    $(this).closest(".form-group").addClass("form-edit")

changeRagStatus = ->
  $(document).on "click", ".btn-rag .dropdown-menu a", (e) ->
    e.preventDefault()
    rag_clicked = $(this).closest("li").attr("class")
    rag_status = $(this).closest(".btn-rag").find(".dropdown-toggle")
    rag_status.removeClass("rag-neutral")
              .removeClass("rag-positive")
              .removeClass("rag-average")
              .removeClass("rag-negative")
              .removeClass("rag-blank")
              .addClass(rag_clicked)
    rag_status.find(".rag-text").text($(this).find(".rag-text").text())

editFormAnswerAutoUpdate = ->
  $("#form_answer_sic_code").on "change", ->
    that = $(this)
    form = that.parents("form")
    $.ajax
      action: form.attr("action")
      data: form.serialize()
      method: "PATCH"
      dataType: "json"

      success: (result) ->
        formGroup = that.parents(".form-group")
        formGroup.removeClass("form-edit")
        formGroup.find(".form-value p").text(that.find("option:selected").text())
        sicCodes = result["form_answer"]["sic_codes"]
        counter = 1
        for row in $(".sector-average-growth td")
          $(row).text(sicCodes[counter.toString()])
          counter += 1
        $(".avg-growth-legend").text(result["form_answer"]["legend"])
bindRags =(klass) ->
  $(document).on "click", "#{klass} .btn-rag .dropdown-menu a", (e) ->
    e.preventDefault()
    ragClicked = $(this).closest("li").attr("class")
    ragClicked = ragClicked.replace("rag-", "")
    ragSection = $(this).parents(".form-group")
    ragSection.find("option").each ->
      if $(this).val() == ragClicked
        $(this).parents("select").val(ragClicked)
    $(klass).submit()
bindAppraisalFields=(klass)->
  $("body").on "click", (e) ->
    if e.target.nodeName != "TEXTAREA"
      area = $(klass).find("textarea:visible")
      if area.length
        parent = area.parents(".form-group")
        parent.removeClass("form-edit")
        parent.find(".form-value p").text(area.val())
        $(klass).submit()

$(document).ready(ready)

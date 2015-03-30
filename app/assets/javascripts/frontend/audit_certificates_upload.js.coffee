window.AuditCertificatesUpload =
  init: ->
    $('.js-audit-certificate-file-upload').each (idx, el) ->
      AuditCertificatesUpload.fileupload_init(el)
    AuditCertificatesUpload.remove_attachment_init()

  fileupload_init: (el) ->
    form = $(el).closest('form')
    $el = $(el)

    parent = $el.closest('div.js-upload-wrapper')
    list = parent.find('.js-uploaded-list')
    form = parent.find('form')

    progress_all = (e, data) ->
      # TODO

    upload_started = (e, data) ->
      form.addClass('visuallyhidden') #TODO: show progressbar

    upload_done = (e, data, link) ->
      file_url = data.result["attachment"]["url"]
      list.removeClass('visuallyhidden')
      list.find(".js-audit-certificate-title").attr("href", file_url)

    failed = (e, data) ->
      console.log("cool")
      error_message = data.jqXHR.responseText
      parent.find(".errors-container").html("<li>" + error_message + "</li>")
      list.addClass('visuallyhidden')
      form.removeClass('visuallyhidden')

    $el.fileupload(
      url: form.attr("action")
      formData: () -> {}
      done: upload_done
      progressall: progress_all
      send: upload_started
      fail: failed
    )

  remove_attachment_init: ->
    $(document).on "click", ".js-upload-wrapper .js-remove-audit-certificate-link", (e) ->
      e.preventDefault()

      parent = $(this).closest('.js-upload-wrapper')
      list = parent.find('.js-uploaded-list')
      form = parent.find('form')

      parent.find(".errors-container").html("")
      list.addClass('visuallyhidden')
      form.removeClass('visuallyhidden')

      false
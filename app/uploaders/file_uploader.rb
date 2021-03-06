class FileUploader < CarrierWave::Uploader::Base
  POSSIBLE_IMG_EXTENSIONS = %w(jpg jpeg gif png)
  POSSIBLE_DOC_EXTENSIONS = %w(chm csv diff doc docx dot dxf eps gml ics kml odp ods odt pdf ppt pptx ps rdf rtf sch txt wsdl xls xlsm xlsx xlt xml xsd xslt zip msg)

  def extension_white_list
    POSSIBLE_IMG_EXTENSIONS + POSSIBLE_DOC_EXTENSIONS
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end

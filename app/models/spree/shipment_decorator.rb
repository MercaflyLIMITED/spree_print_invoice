Spree::Shipment.class_eval do
  has_many :bookkeeping_documents, as: :printable, dependent: :destroy

  delegate :number, :date, to: :invoice, prefix: true

  # Create a new invoice before transitioning to complete
  #
  state_machine.before_transition to: :complete, do: :invoice_for_order

  # Backwards compatibility stuff. Please don't use these methods, rather use the
  # ones on Spree::BookkeepingDocument
  #
  def pdf_file
    ActiveSupport::Deprecation.warn('This API has changed: Please use order.invoice.pdf instead')
    invoice.pdf
  end

  def pdf_filename
    ActiveSupport::Deprecation.warn('This API has changed: Please use order.invoice.file_name instead')
    invoice.file_name
  end

  def pdf_file_path
    ActiveSupport::Deprecation.warn('This API has changed: Please use order.invoice.pdf_file_path instead')
    invoice.pdf_file_path
  end

  def pdf_storage_path(template)
    ActiveSupport::Deprecation.warn('This API has changed: Please use order.{packaging_slip, invoice}.pdf_file_path instead')
    bookkeeping_documents.find_by!(template: template).file_path
  end

  def packaging_slip_for_shipment
    bookkeeping_documents.create(template: 'packaging_slip')
  end
end

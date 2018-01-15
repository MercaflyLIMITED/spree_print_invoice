Spree::Order.class_eval do
  has_many :bookkeeping_documents, as: :printable, dependent: :destroy
  has_one :invoice, -> { where(template: 'invoice') },
          class_name: 'Spree::BookkeepingDocument',
          as: :printable
  has_one :packaging_slip, -> { where(template: 'packaging_slip') },
          class_name: 'Spree::BookkeepingDocument',
          as: :printable

  delegate :number, :date, to: :invoice, prefix: true

  # Create a new invoice before transitioning to complete
  #
  state_machine.before_transition to: :complete, do: :invoice_for_order

  def generate_invoice_for_order
    bookkeeping_documents.create(template: 'list')
  end
end

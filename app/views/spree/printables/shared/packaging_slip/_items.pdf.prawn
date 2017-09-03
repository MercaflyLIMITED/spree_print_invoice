header =  [
  pdf.make_cell(content: Spree.t(:sku)),
  pdf.make_cell(content: Spree.t(:item_description, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:qty, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:position, scope: :print_invoice)  ),
  pdf.make_cell(content: Spree.t(:left, scope: :print_invoice))
]
data = [header]

printable.items.each do |item|
  row = [
    item.sku,
    item.name,
    item.quantity,
    item.position,
    item.left
  ]
  data += [row]
end

column_widths = [0.15, 0.45, 0.1, 0.2, 0.1].map { |w| w * pdf.bounds.width }

pdf.table(data, header: true, position: :center, column_widths: column_widths) do
  row(0).style align: :center
  column(0..2).style align: :left
  column(3..5).style align: :center
end

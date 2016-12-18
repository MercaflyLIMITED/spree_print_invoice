header = [
  pdf.make_cell(content: Spree.t(:sku)),
  pdf.make_cell(content: Spree.t(:item_description, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:options, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:price, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:qty, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:total, scope: :print_invoice))
]
data = [header]

invoice.items.each do |item|
  row = [
    item.sku,
    item.name,
    item.options_text,
    item.display_price.to_s,
    item.quantity,
    item.display_total.to_s
  ]
  data += [row]
end

column_widths = [0.13, 0.37, 0.185, 0.12, 0.075, 0.12].map { |w| w * pdf.bounds.width }

pdf.table(data, header: true, position: :center, column_widths: column_widths) do
  row(0).style align: :center, font_style: :bold
  column(0..2).style align: :left
  column(3..6).style align: :right
end

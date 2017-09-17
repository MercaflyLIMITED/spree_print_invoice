# TOTALS
totals = []

# Subtotal
totals << [pdf.make_cell(content: Spree.t(:subtotal, scope: :print_invoice)), invoice.display_item_total.to_s]

# Adjustments
total_iva = 0
invoice.ivas.each do |iva|
  total_iva += iva.iva
end
totals << [pdf.make_cell(content: 'Total IVA'), '€' + total_iva.to_s ]

# Shipments
invoice.shipments.each do |shipment|
  totals << [pdf.make_cell(content: shipment.shipping_method.name), shipment.display_cost.to_s]
end

# Totals
totals << [pdf.make_cell(content: Spree.t(:order_total, scope: :print_invoice)), invoice.display_total.to_s]

totals_table_width = [0.875, 0.125].map { |w| w * pdf.bounds.width }
pdf.table(totals, column_widths: totals_table_width) do
  row(0..6).style align: :right
  column(0).style borders: [], font_style: :bold
end
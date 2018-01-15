# TOTALS
totals = []

# Subtotal
#totals << [pdf.make_cell(content: Spree.t(:subtotal, scope: :print_invoice)), invoice.display_item_total.to_s]

# Totals
totals << [pdf.make_cell(content: Spree.t(:order_total, scope: :print_invoice)), printable.shipment.order.display_total.to_s]

totals_table_width = [0.875, 0.125].map { |w| w * pdf.bounds.width }
pdf.table(totals, column_widths: totals_table_width) do
  row(0..6).style align: :right
  column(0).style borders: [], font_style: :bold
end

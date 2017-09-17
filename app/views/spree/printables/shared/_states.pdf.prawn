states = []

# Payments
@doc.printable.payments.each do |payment|
  states << [pdf.make_cell(content: payment.payment_method.display_name), payment.state]
end

states << [pdf.make_cell(content: 'Payment state'), @doc.printable.payment_state]

states_table_width = [0.875, 0.125].map { |w| w * pdf.bounds.width }
pdf.table(states, column_widths: states_table_width) do
  row(0..6).style align: :right
  column(0).style borders: [], font_style: :bold
end

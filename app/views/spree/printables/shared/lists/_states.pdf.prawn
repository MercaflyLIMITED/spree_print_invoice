states = []

# Payments
@doc.printable.payments.valid.each do |payment|
  states << [pdf.make_cell(content: payment.payment_method.display_name), @doc.printable.payment_state]
end

states_table_width = [0.875, 0.125].map { |w| w * pdf.bounds.width }
pdf.table(states, column_widths: states_table_width) do
  style(row(0..-1).columns(0..-1), :padding => [4, 5, 4, 5], :borders => [:bottom], :border_color => 'dddddd')
  style(row(0).columns(-1), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
  row(0..6).style align: :right
  column(0).style borders: [], font_style: :bold
end

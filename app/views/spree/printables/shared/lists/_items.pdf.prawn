header = [
  pdf.make_cell(content: Spree.t(:index)),
  pdf.make_cell(content: Spree.t(:sku)),
  pdf.make_cell(content: Spree.t(:item_description, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:options, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:price, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:qty, scope: :print_invoice)),
  pdf.make_cell(content: Spree.t(:total, scope: :print_invoice))
]
data = [header]

row_colors = []

invoice.items.each_with_index do |item, index|
  row = [
    item.index,
    item.sku,
    item.name,
    item.options_text,
    item.display_price.to_s,
    item.quantity,
    item.display_total.to_s
  ]
  data += [row]
  if index%2 == 0
    row_colors << 'ffffff'
  else
    row_colors << 'e9e9e9'
  end
end

column_widths = [0.07, 0.18, 0.35, 0.09, 0.12, 0.1, 0.09].map { |w| w * pdf.bounds.width }

pdf.table(data, header: true, position: :center, column_widths: column_widths, :row_colors => row_colors) do
  style(row(1..-1).columns(0..-1), :padding => [4, 5, 4, 5], :borders => [:bottom], :border_color => 'e9e9e9')
  style(row(0), :background_color => 'e9e9e9', :border_color => 'e9e9e9', :font_style => :bold)
  style(row(0).columns(0..-1), :borders => [:top, :bottom])
  style(row(0).columns(0), :borders => [:top, :left, :bottom])
  style(row(0).columns(-1), :borders => [:top, :right, :bottom])
  style(row(4).filter { |cell| cell.row/2 == 0 }, :border_width => 2)
  style(row(-1), :border_width => 2)
  style(column(2..-1), :align => :right)
  row(0).style align: :center, font_style: :bold
  column(0..2).style align: :left
  column(3..6).style align: :right
end

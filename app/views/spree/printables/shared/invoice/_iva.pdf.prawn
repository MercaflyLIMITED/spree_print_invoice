# IVA
ivas = []

header = [
  pdf.make_cell(content: ''),
  pdf.make_cell(content: 'Base'),
  pdf.make_cell(content: 'Descuento'),
  pdf.make_cell(content: '% IVA'),
  pdf.make_cell(content: 'IVA'),
]
ivas = [header]

# Adjustments
invoice.ivas.each do |iva|
  row = [
      '',
      iva.display_base.to_s,
      iva.display_discount.to_s,
      iva.rate.to_s,
      iva.display_iva.to_s,
    ]
  ivas += [row]
end

ivas_table_width = [0.6, 0.1 , 0.1, 0.1, 0.1].map { |w| w * pdf.bounds.width }
pdf.table(ivas, column_widths: ivas_table_width) do
  row(0..6).style align: :right
  column(0).style borders: [], font_style: :bold
end
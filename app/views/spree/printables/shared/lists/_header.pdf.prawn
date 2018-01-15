path = image_path('logo/spree_50.png')

if File.exist?(path)
  pdf.image path, vposition: :top, height: 40, scale: Spree::PrintInvoice::Config[:logo_scale]
end

pdf.grid([0,3], [1,4]).bounding_box do
  pdf.text Spree.t(printable.document_type, scope: :print_invoice), align: :right, style: :bold, size: 18
  pdf.move_down 4
  pdf.text 'Ref:' + printable.number, align: :right, style: :bold

  pdf.text Spree.t(:list_date, scope: :print_invoice, date: I18n.l(printable.date)), align: :right
end

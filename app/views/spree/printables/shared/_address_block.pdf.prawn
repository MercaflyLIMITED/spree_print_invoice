ship_address = printable.ship_address

pdf.move_down 2
address_cell_shipping = pdf.make_cell(content: Spree.t(:shipping_address, scope: :print_invoice), font_style: :bold)

shipping =  "#{ship_address.firstname} #{ship_address.lastname}"
shipping << "\n#{ship_address.address1}"
shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
shipping << "\n#{ship_address.city}, #{ship_address.state_text} #{ship_address.zipcode}"
shipping << "\n#{ship_address.country.name}"
shipping << "\n#{ship_address.phone}"
shipping << "\n\n#{Spree.t(:via, scope: :print_invoice)} #{printable.shipping_methods.join(", ")}"

data = [[address_cell_shipping], [shipping]]

pdf.table(data, position: :center, column_widths: [pdf.bounds.width])

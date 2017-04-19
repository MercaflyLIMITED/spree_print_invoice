ship_address = printable.ship_address

address_cell = pdf.make_cell(content: "Dirección de la empresa", font_style: :bold)
address_cell_shipping = pdf.make_cell(content: Spree.t(:shipping_address, scope: :print_invoice), font_style: :bold)

address =  "MERCAFLY SOCIEDAD LIMITADA"
address << "\ncarretera cogullada 20 nave16"
address << "\nZaragoza 50014"
address << "\nCIF: B99478125"


shipping =  "#{ship_address.firstname} #{ship_address.lastname}"
shipping << "\n#{ship_address.address1}"
shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
shipping << "\n#{ship_address.city}, #{ship_address.state_text} #{ship_address.zipcode}"
shipping << "\n#{ship_address.country.name}" unless ship_address.country.nil?
shipping << "\n#{ship_address.phone}"
shipping << "\n\n#{Spree.t(:via, scope: :print_invoice)} #{printable.shipping_methods.join(", ")}"

data = [[address_cell, address_cell_shipping], [address, shipping]]

pdf.table(data, position: :center, column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2])

ship_address = printable.printable.order.ship_address

address_cell = pdf.make_cell(content: "Dirección de la empresa", font_style: :bold)
address_cell_shipping = pdf.make_cell(content: Spree.t(:shipping_address, scope: :print_invoice), font_style: :bold)

address =  "MERCAFLY SOCIEDAD LIMITADA"
address << "\nCalle Primavera 29-30 Arganda del Rey"
address << "\nMadrid 28500"
address << "\nCIF: B99478125"


shipping =  "#{ship_address.firstname} #{ship_address.lastname}"
shipping << "\n#{ship_address.address1}"
shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
shipping << "\n#{ship_address.city}, #{ship_address.try(:state).try(:name)} #{ship_address.zipcode} #{ship_address.try(:country).try(:name)}"
shipping << "\n#{ship_address.phone}"
shipping << "\n\n#{Spree.t(:via, scope: :print_invoice)} #{printable.shipment.shipping_method.name}"

data = [[address_cell_shipping, address_cell], [shipping, address]]

pdf.table(data, position: :center, column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2])

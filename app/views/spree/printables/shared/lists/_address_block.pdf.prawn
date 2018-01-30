ship_address = printable.ship_address

address =  "MERCAFLY SOCIEDAD LIMITADA"
address << "\nCalle Primavera 29-30 Arganda del Rey"
address << "\nMadrid 28500"
address << "\nVAT: ESB99478125"


shipping =  "#{ship_address.firstname} #{ship_address.lastname}"
shipping << "\n#{ship_address.address1}"
shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
shipping << "\n#{ship_address.city}, #{ship_address.state_text} #{ship_address.zipcode}"
shipping << "\n#{ship_address.country.name}" unless ship_address.country.nil?
shipping << "\n#{ship_address.phone}"

data = [[shipping, address]]

pdf.table(data, position: :center, column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2]) do
    style(row(0).columns(0..-1), :padding => [0, 5, 4, 5], :borders => [], :border_color => 'dddddd')
end

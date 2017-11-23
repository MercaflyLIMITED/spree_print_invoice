@font_style = {
  face: 'arial',
  size: Spree::PrintInvoice::Config[:font_size]
}

prawn_document(force_download: true) do |pdf|
  pdf.define_grid(columns: 5, rows: 8, gutter: 10)

  pdf.font_families.update(
  "arial" => {
        :normal => Rails.root.join("app/assets/fonts/arial.ttf"),
        :italic => Rails.root.join("app/assets/fonts/arial.ttf"),
        :bold => Rails.root.join("app/assets/fonts/arial.ttf"),
        :bold_italic => Rails.root.join("app/assets/fonts/arial.ttf")
   },
  "msyh" => {
      :normal => Rails.root.join("app/assets/fonts/msyh.ttf"),
      :italic => Rails.root.join("app/assets/fonts/msyh.ttf"),
      :bold => Rails.root.join("app/assets/fonts/msyh.ttf"),
      :bold_italic => Rails.root.join("app/assets/fonts/msyh.ttf")
  },
  "simhei" => {
          :normal => Rails.root.join("app/assets/fonts/simhei.ttf"),
          :italic => Rails.root.join("app/assets/fonts/simhei.ttf"),
          :bold => Rails.root.join("app/assets/fonts/simhei.ttf"),
          :bold_italic => Rails.root.join("app/assets/fonts/simhei.ttf")
      })

  pdf.fallback_fonts(["simhei", "msyh"])

  pdf.font @font_style[:face], size: @font_style[:size]

  pdf.repeat(:all) do
    render 'spree/printables/shared/packaging_slip/header', pdf: pdf, printable: @doc
  end

  # CONTENT
  pdf.grid([1,0], [6,4]).bounding_box do

    # address block on first page only
    if pdf.page_number == 1
      render 'spree/printables/shared/packaging_slip/address_block', pdf: pdf, printable: @doc
    end

    pdf.move_down 10

    render 'spree/printables/shared/packaging_slip/items', pdf: pdf, printable: @doc

    pdf.move_down 20

    render 'spree/printables/shared/packaging_slip/totals', pdf: pdf, printable: @doc

    pdf.move_down 20

    render 'spree/printables/shared/packaging_slip/states', pdf: pdf, printable: @doc
  end

  # Footer
  if Spree::PrintInvoice::Config[:use_footer]
    render 'spree/printables/shared/packaging_slip/footer', pdf: pdf
  end

  # Page Number
  if Spree::PrintInvoice::Config[:use_page_numbers]
    render 'spree/printables/shared/page_number', pdf: pdf
  end
end

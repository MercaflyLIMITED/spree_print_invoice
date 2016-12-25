@font_style = {
  face: 'simhei',
  size: Spree::PrintInvoice::Config[:font_size]
}

prawn_document(force_download: true) do |pdf|
  pdf.define_grid(columns: 5, rows: 8, gutter: 10)

  pdf.font_families.update("simhei" => {
        :normal => Rails.root.join("app/assets/fonts/simhei.ttf"),
        :italic => Rails.root.join("app/assets/fonts/simhei.ttf"),
        :bold => Rails.root.join("app/assets/fonts/simhei.ttf"),
        :bold_italic => Rails.root.join("app/assets/fonts/simhei.ttf")
    })

  pdf.font @font_style[:face], size: @font_style[:size]

  pdf.repeat(:all) do
    render 'spree/printables/shared/header', pdf: pdf, printable: @doc
  end

  # CONTENT
  pdf.grid([1,0], [6,4]).bounding_box do

    # address block on first page only
    if pdf.page_number == 1
      render 'spree/printables/shared/address_block', pdf: pdf, printable: @doc
    end

    pdf.move_down 10

    render 'spree/printables/shared/packaging_slip/items', pdf: pdf, printable: @doc

    pdf.move_down 20
    pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: 100) do
      pdf.transparent(0.5) { pdf.stroke_bounds }
      pdf.text @doc.order_note
    end

    pdf.move_down 10

    render 'spree/printables/shared/totals', pdf: pdf, invoice: @doc
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

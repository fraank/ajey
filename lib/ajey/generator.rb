module Jekyll

  class AjeyGenerator < Generator
    safe true

    def generate(site)
      product_pages = {}
      if site.data && site.data['ajey'] && site.data['ajey']['product_pages']
        site.data['ajey']['product_pages'].each do |item|
          if item['amazon_id']
            product_data = item

            save_path = "products"
            unless product_data['template']
              template_path = '_layouts/ajey_product_default.html'
              product_data['template'] = template_path
            end
            
            if (site.in_theme_dir(template_path) && File.exists?(site.in_theme_dir(template_path))) || (site.in_source_dir(template_path) && File.exists?(site.in_source_dir(template_path)))
              
              product_data['filename'] ||= "#{item['amazon_id']}.html"
              save_path = File.join("products", product_data['filename'])

              # save in links array
              product_pages["amazon_#{item['amazon_id']}"] = save_path
              
              site.pages << Ajey::AjeyProductPage.new(site, save_path, product_data)
            else
              Jekyll.logger.error "Product Template '#{product_data['template']}' not found."
            end

          end
        end
      end

      # overwrite larger page data with small hash pf links
      site.data['_ajay_product_pages'] = product_pages

    end

  end
end
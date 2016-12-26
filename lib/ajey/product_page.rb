module Jekyll
  class AjeyProductPage < Page
    
    def initialize(site, path, product_data)
      @site = site

      # where is the source located?
      @dir = File.dirname(path)
      @dir = "" if @dir == "."

      @name = File.basename(path)
      self.ext = File.extname(@name)
      self.basename = File.basename(@name)

      # this has to be the source file
      if File.exists?(site.in_theme_dir(product_data['template']))
        template_path = site.in_theme_dir(product_data['template'])
      else File.exists?(site.in_source_dir(product_data['template']))
        template_path = site.in_source_dir(product_data['template'])
      end

      source_dir = File.dirname(template_path)
      source_file = File.basename(template_path)
      self.read_yaml(source_dir, source_file)
      
      self.data = self.data.merge(product_data)
      if product_data['title'] && product_data['title'] != ""
        self.data['title'] = product_data['title']
      else 
        self.data['title'] = product_data['amazon_id']
      end

      self.data['amazon_id'] = product_data['amazon_id']
    end

    def destination(dest)
      File.join(dest, @dir, @name)
    end

  end

end
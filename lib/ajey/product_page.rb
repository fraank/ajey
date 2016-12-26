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
      source_dir = File.dirname(product_data['template'])
      source_file = File.basename(product_data['template'])
      self.read_yaml(source_dir, source_file)
      
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
module Jekyll
  class AjeyAmazonProductBlock < Liquid::Block

    def initialize(tag, markup, tokens)
      super
      @product_id, @language = determine_arguments(markup)
      @product_id = @product_id.to_s
    end

    def determine_arguments(input)
      elems = input.strip.split(" ")
      ret = [elems[0], false] if elems.size == 1
      ret = [elems[0], elems[1].upcase] if elems.size == 2
      return ret
    end

    def render(context)      
      
      # search in context for variable
      @product_id = context[@markup.strip].to_s
      if !@language
        @language = ((context.registers[:site].config['lang'] && !context.registers[:site].config['lang'].empty?)? context.registers[:site].config['lang'].upcase : "GB")
      end
      
      # use cache if available for product
      if context.registers[:site].data['_ajey_products'] && context.registers[:site].data['_ajey_products'][@product_id]
        context['product'] = context.registers[:site].data['_ajey_products'][@product_id]
        context['product']['from_cache'] = true
      
      # load and save cache
      else
        @ajay = Jekyll::Ajey.new(context.registers[:site].config['ajey'], @language)
        context['product'] = @ajay.get_amazon_product(@product_id)
        context.registers[:site].data['_ajey_products'] = {} unless context.registers[:site].data['_ajey_products']
        context.registers[:site].data['_ajey_products'][@product_id] = context['product']
        context['product']['from_cache'] = false
        
        # check if an extra page for product exists and if neccessary add link to product
        if context.registers[:site].data['_ajay_product_pages'] && context.registers[:site].data['_ajay_product_pages']["#{context['product']['id']}"] && context.registers[:site].data['_ajay_product_pages']["#{context['product']['id']}"] != ""
          context['product']['page_link'] = "/" + context.registers[:site].data['_ajay_product_pages']["#{context['product']['id']}"]
        end

      end

      return super
    end

  end
end
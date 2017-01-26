# encoding: utf-8
require "jekyll"
require "vacuum"
require 'yaml'

require "ajey/version"
require "ajey/amazon_product_block"
require "ajey/generator"
require "ajey/product_page"


class Hash
  def dig(*path)
    path.inject(self) do |location, key|
      location.respond_to?(:keys) ? location[key] : nil
    end
  end
end

module Jekyll
  class Ajey
    
    # default config for pagination
    DEFAULTS = {
      'language' => 'DE',
      'aws_access_key_id' => '',
      'aws_secret_access_key' => '',
      'aws_associate_tag' =>'tag-21'
    }

    def initialize config = {}, language = false
      @config = DEFAULTS.merge(config)

      @config['language'] = language if language
      @config['language'] = @config['language'].upcase

      @request = Vacuum.new(@config['language'])
      @request.configure(
        aws_access_key_id: @config['aws_access_key_id'],
        aws_secret_access_key: @config['aws_secret_access_key'],
        associate_tag: @config['aws_tracking_id']
      )
    end

    # find one product and store
    def get_amazon_product product_id
      retry_current = 0
      retry_max = 5

      product = false
      
      try = 0
      retry_max = 5

      while product == false && try < retry_max
        try = try + 1
        
        begin
          product = @request.item_lookup(
            query: {
              'ItemId' => product_id,
              # http://docs.aws.amazon.com/AWSECommerceService/latest/DG/RG_ItemAttributes.html
              # http://docs.aws.amazon.com/AWSECommerceService/latest/DG/RG_Offers.html
              'ResponseGroup' => 'ItemAttributes, Images, Offers' #Large
            }
          ).to_h
        rescue
          product = false
          sleep 1
        end
      end

      if product['ItemLookupResponse']['Items']['Request']['IsValid'] == "True"
        product_info = product['ItemLookupResponse']['Items']['Item']
        
        # basic information         
        if product_info
          product = {}
          product['language'] = @config['language']
          product['id'] = "amazon_#{product_id}"
          #p product_info['ItemAttributes']
          product['title'] = product_info['ItemAttributes']['Title'].gsub(/<\/?[^>]*>/, "") if product_info.dig('ItemAttributes', 'Title')
          product['features'] = product_info['ItemAttributes']['Feature'] if product_info.dig('ItemAttributes', 'Feature')
          
          product['images'] = {}
          product['images']['small'] = product_info['SmallImage']['URL'] if product_info.dig('SmallImage', 'URL')
          product['images']['medium'] = product_info['MediumImage']['URL'] if product_info.dig('MediumImage', 'URL')
          product['images']['large'] = product_info['LargeImage']['URL'] if product_info.dig('LargeImage', 'URL')

          if @config['language'] == "DE"
            product['link'] = "http://www.amazon.de/gp/product/#{product_id}?tag=#{@config['aws_tracking_id']}"
          elsif @config['language'] == "GB"
            product['link'] = "http://www.amazon.co.uk/gp/product/#{product_id}?tag=#{@config['aws_tracking_id']}"
          end

          product['price'] = {}
          product['price']['amount'] = product_info['OfferSummary']['LowestNewPrice']['Amount'] if product_info.dig('OfferSummary', 'LowestNewPrice', 'Amount')
          product['price']['formatted'] = product_info['OfferSummary']['LowestNewPrice']['FormattedPrice'] if product_info.dig('OfferSummary', 'LowestNewPrice', 'FormattedPrice')
          product['price']['currency'] = product_info['OfferSummary']['LowestNewPrice']['CurrencyCode'] if product_info.dig('OfferSummary', 'LowestNewPrice', 'CurrencyCode')
        else
          Jekyll.logger.error "Product '#{product_id}' not valid."
        end
        Jekyll.logger.info "Product '#{product_id}' [#{product['title']}] processed."
      else
        Jekyll.logger.error "Product '#{product_id}' not found."
      end

      return product
    end

  end
end

Liquid::Template.register_tag('ajey_amazon_product', Jekyll::AjeyAmazonProductBlock)

# make ajey accessable in templates
Jekyll::Hooks.register :pages, :pre_render do |jekyll_page, payload|
  if jekyll_page.data && jekyll_page.data['ajay']
    payload['ajay'] = jekyll_page.data['ajey_products']
  end
end
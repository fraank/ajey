# encoding: utf-8
require 'rexml/document'
require_relative '../spec_helper'

describe 'load dyn. amazon products', :type => :controller do

  before :all do
    @test = JekyllUnitTest.new
    @site = Site.new(@test.site_configuration)
    @site.read
    @site.generate
    @site.render

    # which layout do we wanna use?
    @layouts = {
      "default" => Layout.new(@site, @test.source_dir("_layouts"), "default.html")
    }
  end

  it 'loads amazon product and caches temp. result' do

    page = @site.pages.select{|item| item.path == "ajey_amazon_product.html" }.first
    page.render(@layouts, @site.site_payload)
    doc = REXML::Document.new(page.content)

    product_iter = 1
    doc.elements.each('results/product') do |product_info|
      title = product_info.elements['title'].text
      expect(title).not_to eq ""

      price = product_info.elements['price'].text
      expect(price).not_to eq ""

      if product_iter == 1
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
      elsif product_iter == 2
        cache = product_info.elements['cache'].text
        expect(cache).to eq "true"
      end
      product_iter = product_iter+1
    end
    # do we have 2 Products?
    expect(product_iter).to eq 3
    
    page = @site.pages.select{|item| item.path == "ajey_amazon_product_2.html" }.first
    page.render(@layouts, @site.site_payload)
    doc = REXML::Document.new(page.content)
    got_product = false
    doc.elements.each('results/product') do |product_info|
      got_product = true

      title = product_info.elements['title'].text
      expect(title).not_to eq ""

      # check if it was loaded from cache
      cache = product_info.elements['cache'].text
      expect(cache).to eq "true"
    end
    expect(got_product).to eq true

  end

  it 'checks variable assignment' do
    page = @site.pages.select{|item| item.path == "ajey_amazon_dynamic_product.html" }.first
    page.render(@layouts, @site.site_payload)
    doc = REXML::Document.new(page.content)

    product_iter = 1
    product_name_1 = ""
    product_name_2 = ""
    product_name_3 = ""
    product_name_4 = ""
    product_name_5 = ""

    doc.elements.each('results/product') do |product_info|
      title = product_info.elements['title'].text
      expect(title).not_to eq ""

      price = product_info.elements['price'].text
      expect(price).not_to eq ""

      if product_iter == 1
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        product_name_1 = title
      elsif product_iter == 2
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        product_name_2 = title
      elsif product_iter == 3
        cache = product_info.elements['cache'].text
        expect(cache).to eq "true"
        product_name_3 = title
      elsif product_iter == 4
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        product_name_4 = title
      elsif product_iter == 5
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        product_name_5 = title
      end
      product_iter = product_iter+1
    end
    #p [product_name_1, product_name_2, product_name_3, product_name_4, product_name_5]
    expect(product_iter).to eq 6
  end


  it 'checks assignment loop' do
    page = @site.pages.select{|item| item.path == "ajey_amazon_products_from_data.html" }.first

    page.render(@layouts, @site.site_payload)
    doc = REXML::Document.new(page.content)

    product_iter = 1
    product_name_1 = ""
    product_name_2 = ""
    product_name_3 = ""
    product_name_4 = ""
    product_name_5 = ""
    product_name_6 = ""

    doc.elements.each('results/product') do |product_info|
      title = product_info.elements['title'].text
      expect(title).not_to eq ""

      price = product_info.elements['price'].text
      expect(price).not_to eq ""

      if product_iter == 1
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        expect(title).not_to eq ""
        product_name_1 = title
      elsif product_iter == 2
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        expect(title).not_to eq ""
        product_name_2 = title
      elsif product_iter == 3
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        expect(title).not_to eq ""
        product_name_3 = title
      elsif product_iter == 4
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        expect(title).not_to eq ""
        product_name_4 = title
      elsif product_iter == 5
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        expect(title).not_to eq ""
        product_name_5 = title
      elsif product_iter == 6
        cache = product_info.elements['cache'].text
        expect(cache).to eq "false"
        expect(title).not_to eq ""
        product_name_6 = title
      end
      product_iter = product_iter+1
    end

    #p [product_name_1, product_name_2, product_name_3, product_name_4, product_name_5, product_name_6]
    expect(product_iter).to eq 7
  end

  it 'creat page for product without layout with static name' do
    page = @site.pages.select{|item| item.name == "3827329892.html" }.first

    page.render(@layouts, @site.site_payload)
    doc = REXML::Document.new(page.content) 
    expect(doc.elements.size > 0).to eq true
    
    doc.elements.each('results/product') do |product_info|
      title = product_info.elements['title'].text
      expect(title).not_to eq ""

      price = product_info.elements['price'].text
      expect(price).not_to eq ""
    end

  end


end
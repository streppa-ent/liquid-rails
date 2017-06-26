require 'spec_helper'
require 'liquid-rails/partial_resolver'

describe 'Request', type: :feature do
  context 'render with partial' do
    before do

      ApplicationController.class_eval do
        before_filter :prepend_view_path_if_param_present
        def prepend_view_path_if_param_present
          prepend_view_path Rails.root.join('vendor/theme') if params[:prepend_view_path]
        end
      end
    end

    it 'no full path for the current controller' do
      visit '/index_partial?prepend_view_path=true'

      expect(page.body).to eq("Application Layout\nLiquid on Rails\n\nVendor Theme Home Partial\n\nVendor Theme Shared Partial\n")
    end

    it 'full path' do
      visit '/index_partial_with_full_path?prepend_view_path=true'

      expect(page.body).to eq("Application Layout\nLiquid on Rails\n\nVendor Theme Home Partial\n\nVendor Theme Shared Partial\n")
    end

    it 'respects namespace of original template for partials path' do
      visit '/foospace/bar/index_partial?prepend_view_path=true'

      expect(page.body.strip).to eq("Foospace::BarController\n\nVendor Theme Bar Partial")
    end

    it 'will resolve non-liquid partial paths' do
      visit '/index_with_html_erb_partial'

      expect(page.body.strip).to eq("Application Layout\nLiquid on Rails\n\nHome HTML ERB Partial\n\nShared HTML ERB Partial")
    end
  end
end

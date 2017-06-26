require 'spec_helper'

module Liquid
  module Rails
    describe TranslateFilter do
      let(:context) { ::Liquid::Context.new }

      options = ParseContext.new

      before do
        context.registers[:view] = ActionView::Base.new
      end

      it 'translate with default locale' do
        expect(::Liquid::Variable.new("'welcome' | translate", options).render(context)).to eq('Welcome everyone!')
      end

      it 'translate with specified locale' do
        expect(::Liquid::Variable.new("'welcome' | translate: locale: 'km'", options).render(context)).to eq('សូមស្វាគមន៍')
      end

      it 'translate with scope' do
        expect(::Liquid::Variable.new("'home' | translate: locale: 'km', scope: 'links'", options).render(context)).to eq('ទំព័រដើម')
      end

      it 'translate with interpolation' do
        expect(::Liquid::Variable.new("'welcome_name' | translate: locale: 'en', name: 'Jeremy'", options).render(context)).to eq('Welcome, Jeremy')
      end
    end
  end
end
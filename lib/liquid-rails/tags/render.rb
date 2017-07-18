module Liquid
  module Rails
    class Render < ::Liquid::Tag
      Syntax = /(#{::Liquid::QuotedFragment}+)/
      def initialize(tag_name, markup, context)
        super

        markup =~ Syntax || raise(SyntaxError.new, 'no template name provided to #render')

        template_name = Regexp.last_match(1)

        @template_name_expr = Liquid::Expression.parse(template_name)
      end

      def render(context)
        template_name = context.evaluate(@template_name_expr)
        context.registers[:view].render template_name
      end
    end
  end
end

Liquid::Template.register_tag('render'.freeze, Liquid::Rails::Render)

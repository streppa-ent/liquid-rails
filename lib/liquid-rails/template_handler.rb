module Liquid
  module Rails
    class TemplateHandler

      def self.call(template)
        "Liquid::Rails::TemplateHandler.new(self).render(#{template.source.inspect}, local_assigns)"
      end

      def initialize(view)
        @view = view
        @controller = @view.controller
        @helper = ActionController::Base.helpers
      end

      def render(template, local_assigns = {})
        @controller.headers['Content-Type'] ||= 'text/html; charset=utf-8'

        assigns = if @controller.respond_to?(:liquid_assigns, true)
                    @controller.send(:liquid_assigns)
                  else
                    @view.assigns
                  end || {}

        assigns['content_for_layout'] = @view.content_for(:layout) if @view.content_for?(:layout)
        assigns.merge!(local_assigns.stringify_keys)

        template_resolver = Liquid::Rails::PartialResolver.new(@view)
        liquid = Liquid::Template.parse(template)
        render_method = (::Rails.env.development? || ::Rails.env.test?) ? :render! : :render

        registers = {
            view: @view,
            controller: @controller,
            helper: @helper,
            file_system: template_resolver
        }

        liquid.send(render_method, assigns, filters: filters, registers: registers).html_safe
      end

      def filters
        if @controller.respond_to?(:liquid_filters, true)
          @controller.send(:liquid_filters)
        else
          [@controller._helpers]
        end
      end

      def compilable?
        false
      end
    end
  end
end

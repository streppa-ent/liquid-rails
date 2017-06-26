module Liquid
  module Rails
    class PartialResolver

      attr_accessor :controller

      def initialize(controller)
        @controller = controller
      end

      # Return a valid liquid template string for requested partial path
      def read_template_file(template_path)
        controller_path = controller.controller_path
        template_path   = "#{controller_path}/#{template_path}" unless template_path.include?('/')

        name = template_path.split('/').last
        prefix = template_path.split('/')[0...-1].join('/')

        result = controller.view_paths.find_all(name, prefix, true, details(controller))

        raise FileSystemError, "No such template '#{template_path}'" unless result.present?

        result.first.source.force_encoding("UTF-8") # cast to utf8 as it was getting encoding errors
      end

      private

      def details(controller)
        {
          locale:   [controller.locale, :en],
          formats:  controller.formats,
          variants: [],
          handlers: ActionView::Template.template_handler_extensions.map {|th| th.to_sym },
          versions: []
        }
      end
    end
  end
end

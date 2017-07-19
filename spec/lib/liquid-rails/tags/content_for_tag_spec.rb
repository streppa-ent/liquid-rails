require 'spec_helper'

module Liquid
  module Rails
    describe ContentForTag, type: :tag do
      it 'content_for and yield with non-quoted key' do
        Liquid::Template.parse(%|{% content_for not_authorized0 %}alert('You are not authorized to do that! [q0]');{% endcontent_for %}|).render(context)

        expect_template_result(%|{% yield not_authorized0 %}|, "alert('You are not authorized to do that! [q0]');")
      end

      it 'content_for and yield with quoted key using single quotes' do
        Liquid::Template.parse(%|{% content_for 'not_authorized1' %}alert('You are not authorized to do that! [q1]');{% endcontent_for %}|).render(context)

        expect_template_result(%|{% yield 'not_authorized1' %}|, "alert('You are not authorized to do that! [q1]');")
      end

      it 'content_for and yield with quoted key using double quotes' do
        Liquid::Template.parse(%|{% content_for "not_authorized2" %}alert('You are not authorized to do that! [q2]');{% endcontent_for %}|).render(context)

        expect_template_result(%|{% yield "not_authorized2"" %}|, "alert('You are not authorized to do that! [q2]');")
      end

      it 'content_for and yield with simulated symbol' do
        Liquid::Template.parse(%|{% content_for :not_authorized3 %}alert('You are not authorized to do that! [q3]');{% endcontent_for %}|).render(context)

        expect_template_result(%|{% yield :not_authorized3 %}|, "alert('You are not authorized to do that! [q3]');")
      end

      it 'content_for and yield with quoted simulated symbol' do
        Liquid::Template.parse(%|{% content_for ':not_authorized4' %}alert('You are not authorized to do that! [q3]');{% endcontent_for %}|).render(context)

        expect_template_result(%|{% yield ':not_authorized4' %}|, "alert('You are not authorized to do that! [q3]');")
      end

      it 'invokes content_for with the same identifier multiple times' do
        Liquid::Template.parse(%|{% content_for 'not_authorized4' %}alert('You are not authorized to do that 1! [m0.0]');{% endcontent_for %}|).render(context)
        Liquid::Template.parse(%|{% content_for 'not_authorized4' %}alert('You are not authorized to do that 2! [m0.1]');{% endcontent_for %}|).render(context)

        expect_template_result(%|{% yield 'not_authorized4' %}|, "alert('You are not authorized to do that 1! [m0.0]');alert('You are not authorized to do that 2! [m0.1]');")
      end

      it 'invokes content_for with the same identifier multiple times and flush' do
        Liquid::Template.parse(%|{% content_for 'not_authorized5' %}alert('You are not authorized to do that 1! [m1.0]');{% endcontent_for %}|).render(context)
        Liquid::Template.parse(%|{% content_for 'not_authorized5' flush true %}alert('You are not authorized to do that 2! [m1.1]');{% endcontent_for %}|).render(context)

        expect_template_result(%|{% yield 'not_authorized5' %}|, "alert('You are not authorized to do that 2! [m1.1]');")
      end
    end
  end
end
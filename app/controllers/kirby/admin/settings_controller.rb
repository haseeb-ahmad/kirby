module Kirby
  module Admin
    class SettingsController < AdminController

      before_action :find_or_set_settings
      before_action :set_breadcrumbs

      def edit
        add_breadcrumb t("kirby.#{plugin.namespace}.title")
      end

      def update
        if @setting.update_attributes(settings_params)
          redirect_to kirby.admin_edit_settings_path(plugin.namespace)
        else
          add_breadcrumb t("kirby.#{plugin.namespace}.title")
          render :edit
        end
      end

      private

      def setting_class
        "kirby/#{plugin.namespace}/setting".classify.constantize
      end

      def plugin
        kirby::Plugin.find_by(namespace: params[:plugin])
      end
      helper_method :plugin

      def find_or_set_settings
        @setting = setting_class.first_or_create do |setting|
          plugin.settings.each do |attribute, type|
            setting.send("#{attribute}=", (type.is_a?(Hash) ? type.first.last : nil))
          end
        end
        plugin.settings.keys.reject do |x|
          @setting.preferences.keys.map(&:to_sym).include? x
        end.each do |key|
          value = plugin.settings[key].is_a?(Hash) ? plugin.settings[key].first.last : nil
          @setting.send("#{key}=", value)
        end
      end

      def set_breadcrumbs
        add_breadcrumb t('kirby.settings.title')
      end

      def settings_params
        params.require(:setting).permit(plugin.settings.keys)
      end

    end
  end
end

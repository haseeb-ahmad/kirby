module Kirby
  module Admin
    class PagesController < AdminController
      before_action :set_tabs, only: [:new, :create, :edit, :update]
      before_action :set_locale

      def index
        add_breadcrumb I18n.t('kirby.website.pages'), kirby.admin_pages_path
        redirect_to admin_pages_path unless current_admin_path.starts_with?('/pages')
        @pages = Page.active.sorted.roots.regular_pages
      end

      def new
        @resource = Resource.find_by(id: params[:resource_id])
        @page = Page.new(resource: @resource, parent: @resource&.parent_page)
        add_index_breadcrumb
        if current_theme.new_page_templates.any? { |template| template[0] == params[:view_template] }
          @page.view_template = params[:view_template]
        end
        add_breadcrumb I18n.t('kirby.pages.new')
        @page_parts = @page.view_template_page_parts(current_theme).map { |part| @page.part(part) }
        render layout: 'kirby/admin/admin'
      end

      def create
        @page = Page.new(page_params)
        add_breadcrumb I18n.t('kirby.pages.new')
        if @page.save
          @page.navigations << Kirby::Navigation.where(auto_add_pages: true)
          redirect_to kirby.edit_admin_page_url(@page), flash: {success: t('kirby.pages.saved')}
        else
          @page_parts = @page.view_template_page_parts(current_theme).map { |part| @page.part(part) }
          render :new, layout: 'kirby/admin/admin'
        end
      end

      def edit
        @page = Page.find(params[:id])
        add_index_breadcrumb
        add_breadcrumb @page.title
        @page_parts = @page.view_template_page_parts(current_theme).map { |part| @page.part(part) }
        render layout: 'kirby/admin/admin'
      end

      def update
        I18n.locale = params[:locale] || I18n.default_locale
        @page = Page.find(params[:id])
        respond_to do |format|
          if @page.update_attributes(page_params)
            add_breadcrumb @page.title
            @page.touch
            I18n.locale = I18n.default_locale
            format.html { redirect_to kirby.edit_admin_page_url(@page, params: {locale: @locale}), flash: {success: t('kirby.pages.saved')} }
            format.js
          else
            50.times do
              Rails.logger.info @page.errors.inspect
            end
            format.html do
              @page_parts = @page.view_template_page_parts(current_theme).map { |part| @page.part(part) }
              render :edit, layout: 'kirby/admin/admin'
            end
          end
        end
      end

      def sort
        params[:list].each_pair do |parent_pos, parent_node|
          update_child_pages_position(parent_node)
          update_page_position(parent_node, parent_pos, nil)
        end
        render nothing: true
      end

      def destroy
        @page = Page.find(params[:id])
        @page.destroy
        redirect_to kirby.admin_pages_url
      end

      private

      def set_locale
        @locale = params[:locale] || I18n.default_locale
      end

      def add_index_breadcrumb
        if @page.resource.present?
          add_breadcrumb @page.resource.label, kirby.admin_resource_path(@page.resource)
        else
          add_breadcrumb I18n.t('kirby.website.pages'), kirby.admin_pages_path
        end
      end

      def set_tabs
        @tabs = %w{page_content page_seo advanced}
      end

      def update_page_position(page, position, parent_id = nil)
        Page.update(page[:id], position: position.to_i + 1, parent_id: parent_id )
      end

      def update_child_pages_position(node)
        if node[:children].present?
          node[:children].each_pair do |child_pos, child_node|
            update_child_pages_position(child_node) if child_node[:children].present?
            update_page_position(child_node, child_pos, node[:id])
          end
        end
      end

      def page_params
        params.require(:page).permit!
      end

    end
  end
end

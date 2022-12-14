module Kirby
  module Admin
    class NavigationsController < AdminController
      layout 'kirby/admin/pages'

      before_action :set_breadcrumb, except: [:show]

      def show
        @navigation = Navigation.find(params[:id])
        add_breadcrumb t('kirby.website.pages')
      end

      def edit
        @navigation = Navigation.find(params[:id])
        add_breadcrumb @navigation.label, kirby.admin_navigation_path(@navigation)
        add_breadcrumb t('kirby.edit')
        render layout: 'kirby/admin/admin'
      end

      def update
        @navigation = Navigation.find(params[:id])
        if @navigation.update_attributes(navigation_params)
          redirect_to kirby.admin_navigation_path(@navigation)
        else
          render :edit
        end
      end

      def sort
        params[:list].each_pair do |parent_pos, parent_node|
          update_child_pages_position(parent_node)
          update_navigation_item_position(parent_node[:id], parent_pos, nil)
        end
        render nothing: true
      end

      private

      def update_navigation_item_position(navigation_item_id, position, parent_id = nil)
        Kirby::NavigationItem.update(navigation_item_id, position: position.to_i + 1, parent_id: parent_id )
      end

      def update_child_pages_position(node)
        if node[:children].present?
          node[:children].each_pair do |child_pos, child_node|
            update_child_pages_position(child_node) if child_node[:children].present?
            update_navigation_item_position(child_node[:id], child_pos, node[:id])
          end
        end
      end

      def set_breadcrumb
        add_breadcrumb t('kirby.website.pages'), kirby.admin_pages_path
      end

      def navigation_params
        params.require(:navigation).permit(:auto_add_pages, page_ids: [])
      end
    end
  end
end

module Kirby
  module Admin
    class ImagesController < AdminController
      before_action :set_breadcrumbs

      layout "kirby/admin/media_library"

      def index
        add_breadcrumb I18n.t('kirby.website.images'), admin_images_path
        @media_folders = MediaFolder.order(:name)
        @images = Image.sorted.where(media_folder_id: nil).with_attached_file.page(params[:page])
      end

      def create
        @images = params[:image][:files].map do |file|
          image = Image.create
          image.file.attach(file)
          image
        end
      end

      def destroy
        @image = Image.find(params[:id])
        @image.destroy
        redirect_back fallback_location: kirby.admin_images_url
      end

      def add_to_media_folder
        @media_folder = MediaFolder.find(params[:id])
        @media_folder.images << Image.find(params[:image_id])
        render json: @media_folder
      end

      private

      def set_breadcrumbs
        add_breadcrumb I18n.t('kirby.website.media_library'), admin_media_library_path
      end

    end
  end
end

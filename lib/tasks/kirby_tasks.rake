namespace :kirby do

  desc "Generate all pages based on the theme config"
  task bootstrap: :environment do
    Kirby::Account.first.save
  end

  desc "Update translations after adding locales"
  task update_translations: :environment do
    Kirby.locales.each do |locale|
      I18n.locale = locale
      Kirby::Page.find_each(&:save!)
    end
  end

end

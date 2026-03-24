class AddRequiresPhotoToMissions < ActiveRecord::Migration[7.0]
  def change
    # すでにあるミッションがエラーにならないよう、基本は「写真あり(true)」にします
    add_column :missions, :requires_photo, :boolean, default: true
  end
end
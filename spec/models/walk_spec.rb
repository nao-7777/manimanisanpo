require 'rails_helper'

RSpec.describe Walk, type: :model do
  # テスト用のユーザーを作成
  let(:user) { User.create(email: 'test@example.com', password: 'password') }

  it 'ユーザーが紐付いていれば有効であること' do
    walk = Walk.new(
      user: user,
      steps: 1000,
      duration: 600
    )
    expect(walk).to be_valid
  end

  it 'ユーザーがいなければ無効であること' do
    walk = Walk.new(user: nil)
    expect(walk).not_to be_valid
  end
end

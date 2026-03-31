class StoriesController < ApplicationController
  def introduction
  end

  def introduction
  end

  def finish
    # 1. 念のためマイグレーションを実行（失敗しても無視して次へ）
    begin
      ActiveRecord::MigrationContext.new(Rails.root.join("db/migrate")).migrate
    rescue => e
      logger.error "Migration error (expected if already done): #{e.message}"
    end

    # 2. Userモデルに「DBの最新状態」を強制的に再認識させる
    # これをやらないと、CMDでmigrateが終わっていてもRailsが気づきません。
    User.connection.schema_cache.clear!
    User.reset_column_information

    # 3. カラムが存在するかチェックしてから更新（安全策）
    if current_user.respond_to?(:first_login)
      current_user.update_columns(first_login: false)
    else
      # 万が一まだ認識できていなくても、エラーを出さずに無理やり進める
      logger.error "Column first_login still not found. Redirecting anyway."
    end
    
    redirect_to root_path
  end
end

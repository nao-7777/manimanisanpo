class WalkingLogsController < ApplicationController
  def index
    # 1. 完了したデータを取得（念のため終了時刻がないものも開始時刻で救済）
    all_walks = current_user.walks.order(created_at: :desc)
    
    # 2. 日本時間（in_time_zone）に変換してから日付を取得する
    @dates = all_walks.group_by { |w| (w.end_at || w.created_at).in_time_zone('Tokyo').to_date }.map do |date, walks|
      {
        date: date,
        total_steps: walks.sum { |w| w.steps || 0 },
        total_duration: walks.sum { |w| w.duration || 0 },
        walk_count: walks.count
      }
    end

    # 3. 新しい順に並び替え
    @dates = @dates.sort_by { |d| d[:date] }.reverse
  end

  def date_index
    # パラメータの日付を日本時間の範囲として扱う
    @target_date = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    
    # 日本時間での「その日の 0:00 〜 23:59」を UTC に逆算して検索
    @walking_logs = current_user.walks
                                .where(end_at: @target_date.all_day)
                                .order(end_at: :desc)
  end

  def show
    # URLは /walking_logs/176 だけど、探すデータは Walk モデルから
    @walking_log = Walk.find(params[:id])
    @captured_missions = @walking_log.missions.with_attached_image
  end
end
class User < ApplicationRecord

  # ユーザが持てるポイントの上限は、200
  # ユーザのポイントの下限は、0
  validates :point, numericality: { greater_than: 0, less_than:200 }

  # 譲渡が行われる場合のみコールバックする
  # after_commit :transfer_point, on: :transfer
  # error
  ## :on conditions for after_commit and after_rollback callbacks have to be one of [:create, :destroy, :update]
  ## after_commit は、予約された時にしか呼び出せないようだった

  # after_rollback :transfer_point_rollback
  # after_update_commit :transfer_point

  # def transfer_point_rollback
  #   p "ポイントの譲渡に失敗しました。"
  #   errors.add(:point, "ポイントの受け渡しに失敗しました。")
  # end

  # def transfer_point
  #   p "ポイントの譲渡が成功したようです。"
  # end
end

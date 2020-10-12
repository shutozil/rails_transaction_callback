class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :transfer_points, :transfer]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def transfer_points
    @users = User.where.not(id: params[:id])
  end

  # patch
  def transfer

    transfer_point = params[:transfer_point].to_i
    destination_user = User.find(params[:destination_user_id])

    User.transaction do
      # >ロールバックが発火するには、「例外」が必要
      ## 参考:https://qiita.com/huydx/items/d946970d130b7dabe7ec
      ## アンチパターンとして、コントローラーを定義しているし、レスポンシブルな実装には向いていないと判断。
      # 下記を実装しきるのならば、非同期でjobを実装してバッチ処理として処理させることが良さそう

      # >コールバックのいずれかで何らかの例外が発生すると、
      #  その例外のせいで以後のafter_commitコールバックやafter_rollbackコールバックのメソッドは実行されなくなります。
      #  このため、もし自作のコールバックが例外を発生する可能性がある場合は、自分のコールバック内でrescueして適切にエラー処理を行い、
      #  他のコールバックが停止しないようにする必要があります。
      ## 参考:https://railsguides.jp/active_record_callbacks.html#%E3%83%88%E3%83%A9%E3%83%B3%E3%82%B6%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%B3%E3%83%BC%E3%83%AB%E3%83%90%E3%83%83%E3%82%AF

      # 例外処理すると、ロールバックが実行されない。
      # 例外処理でtransactionブロックを抜けたことになるから、コミットされてしまうという解釈。
      # > transactionブロック内の処理がエラーなしに完了すればトランザクションがコミットされ、「全件登録成功」する。
      ## 参考:https://qiita.com/jnchito/items/3ef95ea144ed15df3637

      # 処理1: 譲渡元のUserのpointを更新
      @user.update(point: @user.point - transfer_point) # ここの差分がエラーになる場合の考慮は、画面で行う
      # 処理2: 受け取り先のUserのpointを更新
      # begin
      destination_user.update!(point: destination_user.point + transfer_point)
      # 現状では、ここで処理が止まってしまう状態。
      # rescue => ActiveRecord::Rollback
      #   p exception
      #   return redirect_to transfer_points_path(@user)
      # end
      # return redirect_to transfer_points_path(@user)
    end

    redirect_to transfer_points_path(@user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :point)
    end
end

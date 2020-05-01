class AccountsController < ApplicationController
  before_action :find_account

  def show
    account = account_object(@account)
    render json: { account: account }, status: :ok
  end

  def update
    if @account['user_id'] == @current_user.id
      @account&.update(account_params)
      render json: { message: 'Account successfully updated' }, status: :ok
    else
      render json: {
          message: 'You have to be the owner to update this account'
      }, status: :forbidden
    end
  end

  private

  def find_account
    @account = Account.find_by(user_id: @current_user.id)
  rescue StandardError => e
    render json: {
        errors: e.message
    }, status: :bad_request
  end

  def account_object(account)
    {
        id: account.id,
        username: User.find(account.id).username,
        role: account.role,
        address: account.address
    }
  end

  def account_params
    params.require(:account).permit(:role, :address)
  end

end


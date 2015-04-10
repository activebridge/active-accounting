class InvitationsController < CounterpartiesController
  before_action :find_conterparty, only: [:create, :update]

  def create
    password = SecureRandom.hex(8)
    @counterparty.update(password: password)

    InvitationMailer.create_invite_for_vendor(@counterparty, password)
    render json: { success: 'success_send' }
  end
end

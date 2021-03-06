class AgentsController < ApplicationController
  before_action :set_owner_and_agent, except: [:index, :new, :create]
  before_action :check_user_rights, except: [:index, :new, :create]

  def index
    @search = AgentSearch.new(current_user, search_params)
    @total_count = Agent.search(@search.options).count
    @agents = Agent.search(@search.options).page(params[:page]).per(20)
    @search.save
  end

  def show
  end

  def new
    @agent = Agent.new
    @agent.locales = [Locales::ANY, 'en', 'fr']
    @origin = 'index'
    render partial: 'new'
  end

  def create
    @agent = Agent.new(agent_params)
    @agent.memberships << Membership.new(user_id: current_user.id, rights: 'all')

    respond_to do |format|
      if @agent.save
        format.json{
          redirect_to user_agent_path(current_user, @agent), notice: t('views.agents.new.success_message')
        }
      else
        @origin = 'index'
        format.json{
          render json: {
            replace_modal_content_with: render_to_string(partial: 'new', formats: :html),
          }, status: 422
        }
      end
    end
  end

  def edit
    @origin = params[:origin]
    render partial: 'edit'
  end

  def update
    @origin = params[:origin]
    respond_to do |format|
      if @agent.update(agent_params)
        redirect_path = @origin == 'show' ? user_agent_path(@owner, @agent.agentname) : agents_path
        format.json{
          redirect_to redirect_path, notice: t('views.agents.edit.success_message')
        }
      else
        format.json{
          render json: {
            replace_modal_content_with: render_to_string(partial: 'edit', formats: :html),
          }, status: 422
        }
      end
    end
  end

  def confirm_destroy
    render partial: 'confirm_destroy', locals: { agent: @agent }
  end

  def destroy
    if @agent.destroy
      redirect_to agents_path, notice: t('views.agents.destroy.success_message', name: @agent.name)
    else
      redirect_to agents_path, alert: t(
        'views.agents.destroy.errors_message',
        errors: @agent.errors.full_messages.join(', ')
      )
    end
  end

  def confirm_transfer_ownership
    render partial: 'confirm_transfer_ownership', locals: { new_owner: '', agent: @agent, errors: [] }
  end

  def transfer_ownership
    new_owner_input = params[:users][:new_owner]
    transfer = @agent.transfer_ownership_to(new_owner_input)

    respond_to do |format|
      if transfer[:success]
        format.json{
          new_owner = User.find(@agent.owner_id)
          redirect_to agents_path, notice: t(
            'views.agents.index.ownership_transferred',
            name: @agent.name, username: new_owner.username
          )
        }
      else
        format.json{
          render json: {
            replace_modal_content_with: render_to_string(
              partial: 'confirm_transfer_ownership',
              formats: :html,
              locals: { new_owner: new_owner_input, agent: @agent, errors: transfer[:errors] }
            )
          }, status: 422
        }
      end
    end
  end

  def generate_token
    @agent.ensure_api_token
    render json: { api_token: @agent.api_token }
  end

  def add_favorite
    favorite = FavoriteAgent.new(user: current_user, agent: @agent)
    if favorite.save
      redirect_to user_agent_path(@owner, @agent)
    else
      redirect_to agents_path, alert: t('views.agents.favorite.add_errors_message',
                                        errors: favorite.errors.full_messages.join(', '))
    end
  end

  def delete_favorite
    favorite = @agent.favorite_agents.find_by(user: current_user)
    if favorite.destroy
      redirect_to user_agent_path(@owner, @agent)
    else
      redirect_to agents_path, alert: t('views.agents.favorite.remove_errors_message',
                                        errors: favorite.errors.full_messages.join(', '))
    end
  end

  def duplicate
    DuplicateAgentJob.perform_later(@agent, current_user)
  end


  private

    def check_user_rights
      case action_name
      when "show", 'add_favorite', 'delete_favorite', 'duplicate', 'full_export'
        access_denied unless current_user.can? :show, @agent
      when "edit", "update", "generate_token"
        access_denied unless current_user.can? :edit, @agent
      when "confirm_transfer_ownership", "transfer_ownership", "confirm_destroy", "destroy"
        access_denied unless current_user.owner?(@agent)
      else
        access_denied
      end
    end

    def set_owner_and_agent
      begin
        @owner = User.friendly.find(params[:user_id])
        @agent = Agent.owned_by(@owner).friendly.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to '/404'
      end
    end

    def agent_params
      params.require(:agent).permit(
        :name, :agentname, :description, :color, :image, :remove_image, :api_token, :visibility,
        locales: []
      )
    end

    def search_params
      params.permit(search: [:query, :sort_by, :filter_owner, :filter_visibility])[:search]
    end

end

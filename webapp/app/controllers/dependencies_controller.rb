class DependenciesController < ApplicationController
  require 'rgl/dot' # write_to_graphic_file

  before_action :set_owner_and_agent

  def new
    @available_successors = @agent.available_successors(current_user)
    render partial: 'new'
  end

  def create
    arc = AgentArc.new(source: @agent, target_id: params[:id])
    if arc.save
      redirect_to user_agent_path(@agent.owner, @agent.agentname)
    else
      redirect_to user_agent_path(@agent.owner, @agent.agentname),
        alert: t(
          'views.dependencies.new.error_message',
          errors: arc.errors.full_messages.join(', ')
        )
    end
  end

  def successors_graph
    @svg = AgentGraph.new(@agent).to_graph_image
    render partial: 'graph', locals: { svg: @svg }
  end

  def predecessors_graph
    @svg = AgentGraph.new(@agent).to_graph_image(:predecessors)
    render partial: 'graph', locals: { svg: @svg }
  end

  def confirm_destroy
    @successor = Agent.friendly.find(params[:dependency_id])
    render partial: 'confirm_destroy', locals: {
      owner: @owner,
      agent: @agent,
      successor: @successor
    }
  end

  def destroy
    @successor = Agent.friendly.find(params[:id])
    arc = AgentArc.where(source: @agent.id, target: @successor).first
    if arc.destroy
      redirect_to user_agent_path(@agent.owner, @agent.agentname)
    else
      redirect_to user_agent_path(@agent.owner, @agent.agentname),
        alert: t('views.dependencies.destroy.error_message')
    end
  end


  private

    def set_owner_and_agent
      begin
        @owner = User.friendly.find(params[:user_id])
        @agent = @owner.agents.friendly.find(params[:agent_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to '/404'
      end
    end

end

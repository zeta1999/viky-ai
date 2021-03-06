require "application_system_test_case"

class AgentsTest < ApplicationSystemTestCase

  test "Navigation to agents index" do
    admin_go_to_agents_index
    assert has_text?("Agents")
    assert_equal "My awesome weather bot", first(".agent-box h2").text
  end


  test "blank slate" do
    Agent.delete_all
    admin_go_to_agents_index
    assert has_text?("Create your first agent")

    click_link "New agent"

    within(".modal") do
      assert has_field?("Name")
      assert has_field?("ID")
      assert has_button?("Create")
    end
  end


  #
  # Delete
  #
  test "Button to delete agent is not present" do
    admin_go_to_agents_index
    all(".dropdown__trigger > button").first.click
    assert has_no_link?("Delete")
  end

  test "Button to delete agent is (not) present" do
    # Make agent deletable
    agent = agents(:weather)
    agent.memberships.where.not(rights: "all").each do |m|
      assert m.destroy
    end

    admin_go_to_agents_index
    first(".dropdown__trigger > button").click
    assert has_link?("Delete")
  end


  test "Delete with confirmation" do
    # Make agent deletable
    agent = agents(:weather)
    agent.memberships.where.not(rights: "all").each do |m|
      assert m.destroy
    end

    before_count = Agent.count
    admin_go_to_agents_index

    first(".dropdown__trigger > button").click
    click_link "Delete"

    assert has_text?("Are you sure?")
    click_button("Delete")
    assert has_text?("Please enter the text exactly as it is displayed to confirm.")

    fill_in "validation", with: "dElEtE"
    click_button("Delete")
    assert has_text?("Please enter the text exactly as it is displayed to confirm.")

    fill_in "validation", with: "DELETE"
    click_button("Delete")
    assert has_text?("Agent with the name: My awesome weather bot has successfully been deleted.")

    assert_equal "/agents", current_path
    assert_equal before_count - 1, Agent.count
  end


  #
  # Configure
  #
  test "Configure from index" do
    admin_go_to_agents_index
    first(".dropdown__trigger > button").click
    click_link "Configure"
    assert has_text?("Configure agent")
    fill_in "Name", with: ""
    click_button "Update"

    expected = ["Name can't be blank"]
    expected.each do |error|
      assert has_text?(error)
    end
    assert_equal 1, all(".help--error").size

    fill_in "Name", with: "My new updated agent"
    click_button "Update"
    assert has_text?("Your agent has been successfully updated.")
    assert has_text?("My new updated agent")
  end

  test "Configure an agent where user has edit rights; The user owns another agent with the same name" do
    user = users(:edit_on_agent_weather)

    new_agent = Agent.new(
      name: "Weather agent 2",
      agentname: agents(:weather).agentname,
      description: "Agent A decription",
      visibility: "is_public",
      nlp_updated_at: "2019-05-09 10:07:53.484942"
    )
    new_agent.memberships << Membership.new(user_id: user.id, rights: "all")
    assert new_agent.save

    user_go_to_agent_show(user, agents(:weather))
    click_link "Configure"
    within(".modal") do
      assert has_text?("Configure agent")
      fill_in "Name", with: "Updated weather agent of admin"
      click_button "Update"
    end
    assert has_text?("Your agent has been successfully updated.")
    assert_equal "/agents/admin/weather", current_path
    assert has_text?("Updated weather agent of admin")
  end


  test "Cancel configure from index" do
    admin_go_to_agents_index
    first(".dropdown__trigger > button").click
    click_link "Configure"
    assert has_text?("Configure agent")
    click_button "Cancel"
    assert has_no_text?("Configure agent")
    assert_equal "/agents", current_path
  end


  #
  # Search
  #
  test "Agents can be found by name" do
    admin_go_to_agents_index
    fill_in "search_query", with: "800"
    click_button "#search"
    assert has_text?("T-800")
    assert has_no_text?("My awesome weather bot")
    assert_equal "/agents", current_path
  end


  test "Agents can be found by agentname" do
    admin_go_to_agents_index
    fill_in "search_query", with: "inator"
    click_button "#search"
    assert has_text?("T-800")
    assert has_no_text?("My awesome weather bot")
    assert_equal "/agents", current_path
  end


  test "Empty search agent" do
    admin_go_to_agents_index
    fill_in "search_query", with: "inator"
    click_button "#search"
    assert has_text?("T-800")
    assert has_no_text?("My awesome weather bot")
    fill_in "search_query", with: ""
    click_button "#search"
    assert has_text?("T-800")
    assert has_text?("My awesome weather bot")
    assert_equal "/agents", current_path
  end


  test "Agents can be sorted by last updated date" do
    admin_go_to_agents_index
    find(".dropdown__trigger", text: "Sort by popularity").click
    find(".dropdown__content", text: "Sort by last update").click

    click_button "#search"
    expected = [
      "admin/weather",
      "admin/terminator"
    ]
    assert_equal expected, (all(".agents-box-grid .agent-box").map { |div|
      div.all("h3").first.text
    })
  end

  test "Agents can be sorted by popularity" do
    admin_go_to_agents_index
    within('.header__search') do
      assert has_text?("Sort by popularity")
    end
    expected = [
      "admin/weather",
      "admin/terminator",
    ]
    assert_equal expected, (all(".agents-box-grid .agent-box").map { |div|
      div.all("h3").first.text
    })

    weather = agents(:weather)
    terminator = agents(:terminator)
    assert AgentArc.create(agent: weather, depends_on: terminator)

    within('.header__search') do
      assert has_text?("Sort by popularity")
      click_button "#search"
    end
    expected = [
      "admin/terminator",
      "admin/weather",
    ]
    assert_equal expected, (all(".agents-box-grid .agent-box").map { |div|
      div.all("h3").first.text
    })
  end


  test "Agents can be filtered by visibility" do
    agent = agents(:weather_confirmed)
    agent.visibility = Agent.visibilities[:is_public]
    assert agent.save

    admin_go_to_agents_index
    assert has_text?("admin/terminator")
    assert has_text?("admin/weather")
    assert has_text?("confirmed/weather")

    click_button "Private"
    assert has_no_text?("admin/terminator")
    assert has_text?("admin/weather")
    assert has_no_text?("confirmed/weather")

    click_button "Public"
    assert has_text?("admin/terminator")
    assert has_no_text?("admin/weather")
    assert has_text?("confirmed/weather")
  end


  test "Agents can be filtered by owner" do
    agent_public = agents(:weather_confirmed)
    agent_public.visibility = Agent.visibilities[:is_public]
    assert agent_public.save
    admin = users(:admin)
    assert FavoriteAgent.create(user: admin, agent: agent_public)
    assert FavoriteAgent.create(user: admin, agent: agents(:weather))

    admin_go_to_agents_index
    assert has_text?("admin/terminator")
    assert has_text?("admin/weather")
    assert has_text?("confirmed/weather")

    click_button "Yours"
    assert has_text?("admin/terminator")
    assert has_text?("admin/weather")
    assert has_no_text?("confirmed/weather")

    click_button "Favorites"
    assert has_no_text?("admin/terminator")
    assert has_text?("admin/weather")
    assert has_text?("confirmed/weather")
  end


  test "Keep agents search criteria" do
    agent = agents(:weather_confirmed)
    agent.visibility = Agent.visibilities[:is_public]
    assert agent.save

    admin_go_to_agents_index
    find(".dropdown__trigger", text: "Sort by popularity").click
    first(".dropdown__content a", text: "Sort by last update").click
    click_button "Private"
    click_button "Yours"
    assert has_text?("admin/weather")
    assert has_no_text?("admin/terminator")
    assert has_no_text?("confirmed/weather")

    click_link "My awesome weather bot admin/weather"
    assert has_text?("Sharing overview")
    admin_go_to_agents_index
    assert has_text?("admin/weather")
    assert has_no_text?("admin/terminator")
    assert has_no_text?("confirmed/weather")

    assert has_text?("Sort by last update")
    assert first("button[data-input-value='owned']").matches_css?(".btn--primary")
    assert first("button[data-input-value='private']").matches_css?(".btn--primary")
  end


  test "Agents search can be reset" do
    admin_go_to_agents_index
    fill_in "search_query", with: "weather"
    click_button "#search"
    assert has_text?("1 agent found. Reset search")
  end


  #
  # Token
  #
  test "Api Token is shown in edit" do
    admin_go_to_agents_index

    first(".dropdown__trigger > button").click
    click_link "Configure"
    assert has_text?("Configure agent")

    assert has_text?("API token")
    assert_not_nil find("#agent_api_token")[:readonly]
    prev_value = find("#agent_api_token").value

    first(".field--api-token a").click
    assert_not has_text?(prev_value)

    click_button "Update"
    assert has_text?("Your agent has been successfully updated.")

    first(".dropdown__trigger > button").click
    click_link "Configure"
    after_value = find("#agent_api_token").value

    assert_not_equal prev_value, after_value
  end
end

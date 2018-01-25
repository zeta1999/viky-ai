require 'application_system_test_case'

class EntitiesListsTest < ApplicationSystemTestCase

  test 'Create an entities list' do
    go_to_agent_show('admin', 'terminator')
    click_link 'Entities list'
    click_link 'New entities list'
    within('.modal') do
      assert page.has_text? 'Create a new entities list'
      fill_in 'ID', with: 'towns'
      fill_in 'Description', with: 'List every towns in the world !'
      click_button 'Private'
      click_button 'Create'
    end
    assert page.has_text?('Entities list has been successfully created.')
  end


  test 'Errors on entities list creation' do
    go_to_agent_show('admin', 'terminator')
    click_link 'Entities list'
    click_link 'New entities list'
    within('.modal') do
      assert page.has_text? 'Create a new entities list'
      fill_in 'ID', with: ''
      fill_in 'Description', with: 'List every towns in the world !'
      click_button 'Create'
      assert page.has_text?('ID is too short (minimum is 3 characters)')
      assert page.has_text?('ID can\'t be blank')
    end
  end


  test 'Update an entities list' do
    go_to_agent_show('admin', 'weather')
    click_link 'Entities list'
    within '#entities_lists-list-is_public' do
      first('.dropdown__trigger > button').click
      click_link 'Configure'
    end

    within('.modal') do
      assert page.has_text? 'Edit entities list'
      fill_in 'ID', with: 'countries'
      fill_in 'Description', with: 'Every countries'
      click_button 'Update'
    end
    assert page.has_text?('Your entities list has been successfully updated.')
  end


  test 'Delete an entities list' do
    go_to_agent_show('admin', 'weather')
    click_link 'Entities list'
    within '#entities_lists-list-is_public' do
      first('.dropdown__trigger > button').click
      click_link 'Delete'
    end

    within('.modal') do
      assert page.has_text?('Are you sure?')
      click_button('Delete')
      assert page.has_text?('Please enter the text exactly as it is displayed to confirm.')

      fill_in 'validation', with: 'DELETE'
      click_button('Delete')
    end
    assert page.has_text?('Entities list with the name: weather_conditions has successfully been deleted.')

    agent = agents(:weather)
    assert_equal user_agent_path(agent.owner, agent), current_path
  end
end

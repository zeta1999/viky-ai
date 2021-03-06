require 'test_helper'

class EntitiesImportTest < ActiveSupport::TestCase

  test 'Basic import creation and entities list association' do
    entities_list = entities_lists(:weather_conditions)

    Tempfile.open(['temp', '.csv']) do |file|
      IO.copy_stream(File.join(Rails.root, 'test', 'fixtures', 'files', 'import_entities_ok.csv'), file)
      file.open # Flush + rewind
      entities_import = EntitiesImport.new({
        file: file,
        mode: 'replace',
        entities_list: entities_list,
        user: users(:admin)
      })
      assert entities_import.save
      assert_equal 1, entities_list.entities_imports.count

      # Proceed import
      assert_equal 3, entities_import.proceed
      expected = ["nuageux cloudy", "snow", "sun spell eclaircie"]
      assert_equal expected, entities_list.entities.order(position: :desc).pluck(:searchable_terms)
    end
  end


  test 'file should be present' do
    entities_import = EntitiesImport.new({
      mode: 'replace',
      entities_list: entities_lists(:weather_conditions),
      user: users(:admin)
    })
    assert entities_import.invalid?
    assert_equal ["File must be present"], entities_import.errors.full_messages
  end


  test 'file should be of csv format' do
    entities_list = entities_lists(:weather_conditions)

    Tempfile.open(['temp', '.csv']) do |file|
      IO.copy_stream(File.join(Rails.root, 'test', 'fixtures', 'files', 'avatar_upload.png'), file)
      file.open # Flush + rewind
      entities_import = EntitiesImport.new({
        file: file,
        mode: 'replace',
        entities_list: entities_list,
        user: users(:admin)
      })
      assert entities_import.invalid?
      assert_equal ["File with CSV mime type is expected"], entities_import.errors.full_messages
    end
  end


  test 'file should have a valid csv extension' do
    entities_list = entities_lists(:weather_conditions)

    Tempfile.open(['temp', '.png']) do |file|
      IO.copy_stream(File.join(Rails.root, 'test', 'fixtures', 'files', 'avatar_upload.png'), file)
      file.open # Flush + rewind
      entities_import = EntitiesImport.new({
        file: file,
        mode: 'replace',
        entities_list: entities_list,
        user: users(:admin)
      })
      assert entities_import.invalid?
      assert_equal ["File with CSV mime type is expected", "File with .csv or .xls extension is expected"], entities_import.errors.full_messages
    end
  end


  test 'no concurrent import running' do
    entities_list = entities_lists(:weather_conditions)

    Tempfile.open(['temp', '.csv']) do |file|
      IO.copy_stream(File.join(Rails.root, 'test', 'fixtures', 'files', 'import_entities_ok.csv'), file)
      file.open # Flush + rewind
      entities_import = EntitiesImport.new({
        file: file,
        mode: 'replace',
        entities_list: entities_list,
        user: users(:admin)
      })
      assert entities_import.save
    end

    Tempfile.open(['temp', '.csv']) do |file|
      IO.copy_stream(File.join(Rails.root, 'test', 'fixtures', 'files', 'import_entities_ok.csv'), file)
      file.open # Flush + rewind
      entities_import = EntitiesImport.new({
        file: file,
        mode: 'replace',
        entities_list: entities_list,
        user: users(:admin)
      })
      assert_not entities_import.save
      assert_equal ["An import is already running, please wait."], entities_import.errors.full_messages
    end
  end


  test 'Import entities from CSV' do
    elist = entities_lists(:weather_conditions)
    assert_equal ["*", "en", "fr", "es"], elist.agent.locales

    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "snow,false,\"{'w': 'snow'}\",false,true\n"
    io << "cloudy|غائم:ar,False,\"{'weather': 'cloudy'}\",true,false\n"

    entities_import = build_entities_import(elist, io)

    assert_equal 2, elist.entities.count
    assert entities_import.save
    assert_equal 2, entities_import.proceed
    assert_equal 4, elist.entities.count

    snow = elist.entities.find_by_solution("{'w': 'snow'}")
    snow_terms = [{ 'term' => 'snow', 'locale' => '*' }]
    assert_equal snow_terms, snow.terms
    assert_equal false, snow.auto_solution_enabled
    assert_equal "{'w': 'snow'}", snow.solution
    assert_equal false, snow.case_sensitive
    assert_equal true, snow.accent_sensitive
    assert_equal 3, snow.position

    cloudy = elist.entities.find_by_solution("{'weather': 'cloudy'}")
    cloudy_terms = [{ 'term' => 'cloudy', 'locale' => '*' }, { 'term' => 'غائم', 'locale' => 'ar' }]
    assert_equal cloudy_terms, cloudy.terms
    assert_equal false, cloudy.auto_solution_enabled
    assert_equal "{'weather': 'cloudy'}", cloudy.solution
    assert_equal true, cloudy.case_sensitive
    assert_equal false, cloudy.accent_sensitive
    assert_equal 2, cloudy.position
    assert_equal 10, Entity.all.count
    assert_equal ["*", "en", "fr", "es", "ar"], elist.agent.locales
  end


  test 'Entities count column is updated after import' do
    elist = entities_lists(:weather_conditions)

    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "snow,false,\"{'w': 'snow'}\",false,false\n"
    io << "cloudy|غائم:ar,False,\"{'weather': 'cloudy'}\",false,false\n"

    entities_import = build_entities_import(elist, io)
    assert_equal 2, elist.entities.count
    assert_equal 2, elist.entities_count
    assert entities_import.save
    assert_equal 2, entities_import.proceed

    elist.reload
    assert_equal 4, elist.entities.count
    assert_equal 4, elist.entities_count
  end


  test 'Import entities missing header' do
    io = StringIO.new
    io << "snow,false,\"{'w': 'snow'}\",false,false\n"
    io << "cloudy|nuageux:fr,True,\"{'weather': 'cloudy'}\",false,false\n"

    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io)

    assert_equal 2, elist.entities.count
    assert entities_import.save
    assert_equal 0, entities_import.proceed
    assert_equal 2, elist.entities.count

    msg =  'File with bad CSV format: Missing or malformed header '
    msg << '("Terms,Auto solution,Solution,Case sensitive,Accent sensitive" is expected) in line 0.'
    assert_equal [msg], entities_import.errors.full_messages
  end


  test 'Import entities empty terms' do
    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "\"\",false,hail,false,false\n"
    io << "cloudy|nuageux:fr,True,\"{'weather': 'cloudy'}\",false,false\n"

    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io)

    assert_equal 2, elist.entities.count
    assert entities_import.save
    assert_equal 0, entities_import.proceed
    assert_equal 2, elist.entities.count

    msg = "File with bad entity format: Terms can't be blank in line 1."
    assert_equal [msg], entities_import.errors.full_messages
  end


  test 'Import entities unexpected auto solution' do
    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "snow,blablabla,snow,false,false\n"
    io << "cloudy|nuageux:fr,True,\"{'weather': 'cloudy'}\",false,false\n"
    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io, 'replace')

    assert_equal 2, elist.entities.count
    assert entities_import.save
    assert_equal 0, entities_import.proceed
    assert_equal 2, elist.entities.count

    msg = "File with bad CSV format: Auto solution must be true or false in line 1."
    assert_equal [msg], entities_import.errors.full_messages
  end


  test 'Import entities autosolution true with solution' do
    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "cloudy,true,\"{'weather': 'cloudy'}\",false,false\n"
    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io, 'replace')

    assert entities_import.save
    assert_equal 1, entities_import.proceed
    elist.entities.reload
    cloudy = elist.entities.first
    assert_equal [{ 'term' => 'cloudy', 'locale' => '*' }], cloudy.terms
    assert_equal true, cloudy.auto_solution_enabled
    assert_equal 'cloudy', cloudy.solution
  end


  test 'Import entities autosolution true without solution' do
    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "cloudy,True,,false,false\n"
    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io, 'replace')

    assert entities_import.save
    assert_equal 1, entities_import.proceed
    elist.entities.reload
    cloudy = elist.entities.first
    assert_equal [{ 'term' => 'cloudy', 'locale' => '*' }], cloudy.terms
    assert_equal true, cloudy.auto_solution_enabled
    assert_equal 'cloudy', cloudy.solution
  end


  test 'Import entities autosolution false with solution' do
    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "cloudy,false,\"{'weather': 'cloudy'}\",false,false\n"
    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io, 'replace')

    assert entities_import.save
    assert_equal 1, entities_import.proceed
    elist.entities.reload
    cloudy = elist.entities.first
    assert_equal [{ 'term' => 'cloudy', 'locale' => '*' }], cloudy.terms
    assert_equal false, cloudy.auto_solution_enabled
    assert_equal "{'weather': 'cloudy'}", cloudy.solution
  end


  test 'Import entities autosolution false without solution' do
    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "cloudy,false,,false,false\n"
    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io, 'replace')

    assert entities_import.save
    assert_equal 0, entities_import.proceed
    msg = "File with bad CSV format: Solution missing in line 1."
    assert_equal [msg], entities_import.errors.full_messages
  end


  test 'Import entities wrong separator' do
    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "snow;false;snow;false;false\n"
    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io)

    assert_equal 2, elist.entities.count
    assert entities_import.save
    assert_equal 0, entities_import.proceed
    assert_equal 2, elist.entities.count
    msg = "File with bad CSV format: Missing column in line 1."
    assert_equal [msg], entities_import.errors.full_messages
  end


  test 'Import and replace entities' do
    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "snow,false,\"{'w': 'snow'}\",false,false\n"

    elist = entities_lists(:weather_conditions)
    entities_import = build_entities_import(elist, io, 'replace')

    assert_equal 2, elist.entities.count
    assert entities_import.save
    assert_equal 1, entities_import.proceed
    assert_equal 1, elist.entities.count

    snow = elist.entities.find_by_solution("{'w': 'snow'}")
    snow_terms = [{ 'term' => 'snow', 'locale' => '*' }]
    assert_equal snow_terms, snow.terms
    assert_equal false, snow.auto_solution_enabled
    assert_equal "{'w': 'snow'}", snow.solution
    assert_equal 7, Entity.all.count
  end


  test 'Import entities with non existing locale' do
    elist = entities_lists(:weather_conditions)
    assert_equal ["*", "en", "fr", "es"], elist.agent.locales

    io = StringIO.new
    io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
    io << "snow,false,\"{'w': 'snow'}\",false,false\n"
    io << "cloudy:en|nuageuse:rf,False,\"{'weather': 'cloudy'}\",false,false\n"

    entities_import = build_entities_import(elist, io)

    assert_equal 2, elist.entities.count
    assert entities_import.save
    assert_equal 0, entities_import.proceed
    assert_equal 2, elist.entities.count

    msg = "File with bad entity format: Terms uses an unauthorized locale 'rf' for this agent in line 2."
    assert_equal [msg], entities_import.errors.full_messages
  end


  test 'Import entities, quota enabled (append mode)' do
    Feature.with_quota_enabled do
      Quota.stubs(:expressions_limit).returns(10)

      # Limit 10, current 10, append 3 -> Fail
      admin = users(:admin)
      assert_equal 10, admin.expressions_count

      elist = entities_lists(:terminator_targets)
      assert_equal admin, elist.agent.owner
      assert_equal 0, elist.entities.count

      io = StringIO.new
      io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
      io << "Sarah J. Connor,true,'',false,false\n"
      io << "Kyle Reese,false,'',false,false\n"
      io << "Terminator T-800,false,'',false,false\n"
      entities_import = build_entities_import(elist, io)

      assert_not entities_import.save

      expected = ["Quota exceeded (maximum is 10 formulations and entities), you will reach 13 entries"]
      assert_equal expected, entities_import.errors.full_messages

      # Limit 12, current 10, append 3 -> Fail
      Quota.stubs(:expressions_limit).returns(12)
      assert_not entities_import.save

      expected = ["Quota exceeded (maximum is 12 formulations and entities), you will reach 13 entries"]
      assert_equal expected, entities_import.errors.full_messages


      # Limit 13, current 10, append 3 -> Success
      Quota.stubs(:expressions_limit).returns(13)
      assert entities_import.save

      # Unitary quota validation must not be called
      Entity.any_instance.expects(:validate_owner_quota).never
      assert_equal 3, entities_import.proceed

      assert_equal 3, elist.entities.count
      assert_equal 13, admin.expressions_count
    end
  end


  test 'Import entities, quota enabled (append replace)' do
    Feature.with_quota_enabled do
      Quota.stubs(:expressions_limit).returns(10)

      admin = users(:admin)
      assert_equal 10, admin.expressions_count

      elist = entities_lists(:weather_conditions)
      assert_equal admin, elist.agent.owner
      assert_equal 2, elist.entities.count

      # Limit 10, current 10, remove 2, add 3 -> Fail
      io = StringIO.new
      io << "Terms,Auto solution,Solution,Case sensitive,Accent sensitive\n"
      io << "snow,false,'',false,false\n"
      io << "rain,false,'',false,false\n"
      io << "fog,false,'',false,false\n"
      entities_import = build_entities_import(elist, io, 'replace')

      assert_not entities_import.save

      expected = ["Quota exceeded (maximum is 10 formulations and entities), you will reach 11 entries"]
      assert_equal expected, entities_import.errors.full_messages


      # Limit 11, current 10, remove 2, add 3 -> Success
      Quota.stubs(:expressions_limit).returns(11)
      assert entities_import.save

      # Unitary quota validation must not be called
      Entity.any_instance.expects(:validate_owner_quota).never
      assert_equal 3, entities_import.proceed
      assert_equal 3, elist.entities.count
      assert_equal 11, admin.expressions_count
    end
  end


  private

    def build_entities_import(elist, io, mode = 'append')
      io.rewind
      file = Tempfile.open(['temp', '.csv'])
      IO.copy_stream(io, file)
      file.open # Flush + rewind
      EntitiesImport.new(
        file: file,
        mode: mode,
        entities_list: elist,
        user: users(:admin)
      )
    end
end

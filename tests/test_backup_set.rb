require 'minitest/autorun'



class TestBackupSet < MiniTest::Unit::TestCase
  def setup
    require_relative '../backup_checker'
    @backup_set = BackupSet.new('127', '../sample', 100)
  end

  def test_backup_size_is_zero_before_adding_a_file
    assert_equal 0, @backup_set.size
  end

  def test_complete_is_false_before_it_is_set
    assert_equal false, @backup_set.complete
  end

  def test_add_file_without_param
    assert_raises(ArgumentError, "Called add_file with no argument") do
      @backup_set.add_file()
    end
  end

  def test_files_empty_before_adding_file
    assert_equal [], @backup_set.files
  end

  def test_add_file_with_param
    @backup_set.add_file('test_file.txt', 100, "K")
    assert_equal "test_file.txt", @backup_set.files[0].name
    assert_equal 100, @backup_set.files[0].size
    assert_equal "K", @backup_set.files[0].ftype
  end

  def test_check_complete_before_completion
    assert_equal false, @backup_set.is_complete?
  end

  def test_is_complete_with_incomplete_info

    @backup_set.add_file('test_file.txt', 10, "K")
    @backup_set.add_file('test_file2.txt', 10, "K")
    assert_equal false, @backup_set.is_complete?
  end

  def test_is_complete_with_complete_info
    @backup_set = BackupSet.new('666','sample', 100)
    @backup_set.add_file('test_file.txt', 50, "K")
    @backup_set.add_file('test_file2.txt', 50, "R")
    assert_equal true, @backup_set.is_complete?
  end

  def test_get_creation_date
    @backup_set = BackupSet.new('666', 'sample', 100)
    @backup_set.add_file('test_file2.txt', 50, "R")
    assert_equal 1339306775, @backup_set.creation_date
  end

  def test_get_creation_date_with_wrong_file_info
    @backup_set = BackupSet.new('666', 'sample', 100)
    @backup_set.add_file('test_file2.txt', 50, "K")
    refute_equal 1339306775, @backup_set.creation_date
  end

  #def test_info
  #  @backup_set = BackupSet.new('666','sample', 100)
  #  @backup_set.add_file('test_file.txt', 50, "K")
  #  @backup_set.add_file('test_file2.txt', 50, "R")
  #  @backup_set.is_complete?
  #  assert_match "\nSet:666  Files:  test_file.txt, test_file2.txt                           \n\t Status: Complete    \n\t Size:   <1MB\n\t Date:   2012-06-09 22:39:35 -0700", @backup_set.info(55,10)
  #end

end
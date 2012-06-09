require 'minitest/autorun'
require 'purdytest'

class TestBackupSet < MiniTest::Unit::TestCase
  def setup
    require_relative '../backup_checker'
    @backup_set = BackupSet.new
  end

  def test_backup_size_is_zero_before_adding_a_file
    assert_equal 0, @backup_set.size
  end

  def test_complete_is_false
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
    @backup_set.add_file('test_file.txt')
    assert_equal "test_file.txt", @backup_set.files[0]
  end




end
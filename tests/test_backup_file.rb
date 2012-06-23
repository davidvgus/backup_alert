require 'minitest/autorun'



class TestBackupFile < MiniTest::Unit::TestCase
  def setup
    require_relative '../backup_checker'
    @backup_file = BackupFile.new('file.txt', 100, "K")
  end

  def test_file_has_a_name
    assert_equal 'file.txt', @backup_file.name
  end

  def test_file_has_a_size
    assert_equal 100, @backup_file.size
  end

  def test_file_is_correct_type
    assert_equal "K", @backup_file.ftype
  end




end
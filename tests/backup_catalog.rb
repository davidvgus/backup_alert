require 'minitest/autorun'
require 'purdytest'

class TestBackupCatalog < MiniTest::Unit::TestCase
  def setup
    require_relative '../backup_checker'
    @backup_catalog = BackupSetCatalog.new('sample', 14)
  end

  def test_list_set_names
    assert_equal ["900", "100", "127", "138", "129"], @backup_catalog.list_set_names
  end

  def test_that_backup_catalog_is_right_class
    assert_instance_of BackupSetCatalog, @backup_catalog
  end

  def test_get_last_backup_set
    assert_equal "900", @backup_catalog.get_last_set
  end

  def test_get_time_of_last_backup
    assert_equal 1339415518, @backup_catalog.catalog[@backup_catalog.get_last_set].creation_date
  end

  def test_is_the_last_backup_complete?
      assert_equal true, @backup_catalog.catalog[@backup_catalog.get_last_set].is_complete?
  end


end
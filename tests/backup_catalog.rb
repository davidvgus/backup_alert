require 'minitest/autorun'
require 'purdytest'

class TestBackupCatalog < MiniTest::Unit::TestCase
  def setup
    require_relative '../backup_checker'
    @backup_catalog = BackupSetCatalog.new('sample', 1)
  end

  def test_create_a_catalog

  end


end
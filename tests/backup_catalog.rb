require 'minitest/autorun'
require 'purdytest'

class TestBackupCatalog < MiniTest::Unit::TestCase
  def setup
    require_relative '../backup_checker'
    @backup_catalog = BackupCatalog.new
  end


end
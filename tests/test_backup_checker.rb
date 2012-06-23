require 'minitest/autorun'

class TestBackupChecker < MiniTest::Unit::TestCase

  def setup
    require_relative '../backup_checker'
    #t = 2012-06-12 00:51:58 -0700
    @t = 1339487518
    @backup_checker = BackupChecker.new(@t)
  end

  def test_current_time_set_properly
    assert_equal @t, @backup_checker.current_time
  end

  def test_correctly_identifies_complete_backup
    assert_equal true, @backup_checker.complete?
  end

  def test_alert_with_real_time
    assert_equal true, @backup_checker.alert?
  end

  def test_alert_with_test_time
    assert_equal false, @backup_checker.alert?(1339458718)
  end

end
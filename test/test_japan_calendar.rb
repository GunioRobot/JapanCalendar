# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'japan_calendar'
require 'kconv'

class TestJapanCalendar < Test::Unit::TestCase
  def setup
    @now = Time.now
    @this_year = @now.year
    @this_month = @now.month
    @this_day = @now.day
  end

  
  def test_holiday_workday_flg
    # 対象年
    year = 2009

    # 年間カウンター初期化
    workday_year_count = 0
    holiday_year_count = 0

    # 週の文字列
    # 月の配列
    # 12 か月分の配列
    1.upto(12) do |month|

      # 初期化
      workdayCount = 0
      holidayCount = 0
      jcal = JapanCalendar.new(year, month, true)

      1.upto(jcal.days) do |day|
        holidayCount += 1 if jcal.holiday? day
        workdayCount += 1 if jcal.workday? day
      end

      # puts "#{year}/#{month}　日数#{workdayCount + holidayCount}　平日#{workdayCount}(時間：#{workdayCount*7.5})　休日#{holidayCount}　稼働率#{workdayCount * 100 / (workdayCount + holidayCount)}%".tosjis
      workday_year_count = workday_year_count + workdayCount
      holiday_year_count = holiday_year_count + holidayCount
    end

    # puts "年間日数#{workday_year_count + holiday_year_count}　平日#{workday_year_count}　休日#{holiday_year_count}　稼働率#{workday_year_count * 100 / (workday_year_count + holiday_year_count)}%".tosjis

    assert_equal(365, workday_year_count + holiday_year_count)
    assert_equal(121, holiday_year_count)
  end

  def test_days
    jcal = JapanCalendar.new(2009, 4)
    assert_equal 30, jcal.days
    jcal = JapanCalendar.new(2009, 5)
    assert_equal 31, jcal.days
    jcal = JapanCalendar.new(2009, 6)
    assert_equal 30, jcal.days
  end

  def test_holiday?
    jcal = JapanCalendar.new(2009, 5)
    # 休日以外
    assert_equal false, jcal.workday?(3)
    assert_equal false, jcal.not_holiday?(3)
    # 祝祭日(初期設定では土曜日は平日扱い)
    assert_equal true, jcal.holiday?(3)

    # 土曜、又は、日曜、確認
    assert_equal true, jcal.weekend?(3)
    # 土曜、確認
    assert_equal false, jcal.saturday?(3)
    # 日曜、確認
    assert_equal true, jcal.sunday?(3)
  end

  def test_saturday_is_holiday
    # 設定を省略すると、土曜は休日扱いにはなっていない
    jcal = JapanCalendar.new(2009, 5)
    assert_equal false, jcal.holiday?(2)

    # 土曜を休日扱いにする
    jcal = JapanCalendar.new(2009, 5, true)
    assert_equal true, jcal.holiday?(2)

    # 土曜を休日扱いにしない
    jcal = JapanCalendar.new(2009, 5, false)
    assert_equal false, jcal.holiday?(2)
  end

  def test_days
    # 土曜日を休日扱いしない
    jcal = JapanCalendar.new(2009, 5)
    # 休日
    assert_equal 8, jcal.holidays
    # 平日
    assert_equal 23, jcal.workdays
    assert_equal 23, jcal.not_holidays
    # 月末日
    assert_equal 31, jcal.days

    # 土曜日を休日扱い
    jcal = JapanCalendar.new(2009, 5, true)
    # 休日
    assert_equal 13, jcal.holidays
    # 平日
    assert_equal 18, jcal.workdays
    assert_equal 18, jcal.not_holidays
    # 月末日
    assert_equal 31, jcal.days
  end

  def test_attr_reader
    jcal = JapanCalendar.new(2009, 5)
    assert_equal 2009, jcal.year
    assert_equal 5, jcal.month
  end

  def test_holiday_name
    # 2009年4月
    jcal = JapanCalendar.new(2009, 4)
    assert_equal '昭和の日', jcal.holiday_name(29)

    # 2009年5月
    jcal = JapanCalendar.new(2009, 5)
    assert_equal nil, jcal.holiday_name(2)
    assert_equal '憲法記念日', jcal.holiday_name(3)
    assert_equal 'みどりの日', jcal.holiday_name(4)
    assert_equal 'こどもの日', jcal.holiday_name(5)
    assert_equal '振替休日', jcal.holiday_name(6)
  end

  def test_initialize_no_parameter
    # newの引数が無いと実行時の年月が指定される
    jcal = JapanCalendar.new
    assert_equal @this_year, jcal.year
    assert_equal @this_month, jcal.month
  end

  def test_today?
    jcal = JapanCalendar.new
    1.upto(jcal.days) { |day|
      if day == @this_day
        assert_equal true, jcal.today?(day)
      else
        assert_equal false, jcal.today?(day)
      end
    }

  end
end

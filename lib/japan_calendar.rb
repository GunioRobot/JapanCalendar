# = JapanCalender
# Author::    梨木繁幸(NashikiShigeyuki)[http://cyberwave.jp/nashiki/]
# Copyright:: Copyright 2009 cyberwave.jp[http://cyberwave.jp/]
# License::   GPL
#
# 日本のカレンダークラスです。
# 年月を指定するとその月のカレンダークラス(JapanCalendar)を返します。
#
# === 使い方
#   gem install japan_calendar
#
# === サンプルソース
#   require 'japan_calendar'
#
#   jcal = JapanCalendar.new(2009, 5)
#   1.upto(jcal.days) do |day|
#     holidayCount += 1 if jcal.holiday? day
#     workdayCount += 1 if jcal.workday? day
#     puts jcal.holiday_name(day) if jcal.holiday? day
#   end


# === JapanCalendarクラスの機能
#
# 1. その日が、平日かどうか取得できます。
# 2. その日が、祝祭日かどうか取得できます。
# 3. 祝祭日のとき、日本語名を取得できます。
# 4. 土曜日を休日扱いにするかしないか設定できます。
#    * 初期設定では土曜日は平日扱い

class JapanCalendar
  attr_reader :year, :month
  attr_reader :holidays, :workdays, :not_holidays, :days

  # [year]
  #   年を指定します。
  #   省略時は、実行時の年になります。
  # [month]
  #   月をしてします。
  #   省略時は、実行時の月になります。
  # [saturday_holiday_flg]
  #   土曜日を給仕扱いする場合はTrueを指定します。
  #   False又は省略した時は、法令どおり土曜日は平日扱いになります。
  def initialize(year = nil, month = nil, saturday_holiday_flg = false)
    # 土曜日を祝日扱いするかフラグ
    @saturday_holiday_flg = saturday_holiday_flg

    # 呼び出し日の取得(内部利用)
    @now = Time.now

    # 取得対象年月（省略時はコール時の年月）
    @year = if year == nil then @now.year else year end
    @month = if month == nil then @now.month else month end
    
    # その月の月末日
    @days = Date.new(@year, @month, -1).strftime("%d").to_i

    # 日毎の休日フラグ（引数は日）
    @holiday = []
    # 日毎の日本語休日名（引数は日）
    @holiday_name = []

    # 対象月の日毎のTimeオブジェクトを作成（引数は日）
    @month_time_objs = []
    1.upto(@days) { |d|
      @month_time_objs[d] = Time.local(@year, @month, d, 0, 0, 0)
      @holiday[d] = false
    }

    holiday_str = <<EOS
1 1       0         元旦
1 15      -1999     成人の日
1 HM2     2000-     成人の日
2 11      0         建国記念の日
3 SHUNBUN 0         春分の日
4 29      -1988     天皇誕生日
4 29      1989-2006 みどりの日
4 29      2007-     昭和の日
5 3       0         憲法記念日
5 4       2007-     みどりの日
5 5       0         こどもの日
6 20      1996-2002 海の日
6 HM3     2003-     海の日
9 15      -2002     敬老の日
9 HM3     2003-     敬老の日
9 SYUBUN  0         秋分の日
10 10      -1999     体育の日
10 HM2     2000-     体育の日
11 3       0         文化の日
11 12      2009      天皇即位20年
11 23      0         勤労感謝の日
12 23      1989-     天皇誕生日
EOS

    holiday_str.split(/\n/).each do |line|
      next if line == '' or line =~ /^\#/
      line.sub!(/\#.*$/, '')
      m, d, y, c = line.split(/\s+/, 4)
      if y != '0'
        if y[0,1] == '-'
          next if @year > y[1,4].to_i
        elsif y[-1,1] == '-'
          next if @year < y[0,4].to_i
        elsif y[4,1] == '-'
          next if @year < y[0,4].to_i || @year > y[5,4].to_i
        else
          next if @year != y.to_i
        end
      end

      if @month == m.to_i
        case d
        when 'SHUNBUN'
          d = syunbun(@year).to_s
        when 'SYUBUN'
          d = syubun(@year).to_s
        when 'HM2'
          d = monday_of_week(2).to_s
        when 'HM3'
          d = monday_of_week(3).to_s
        end
        @holiday[d.to_i] = true
        @holiday_name[d.to_i] = c
      end
    end

    if @year >= 1986
      i = 0
      while i < 31 - 2
        # 「国民の休日」判定
        # 当日が祝日       次の日が祝日でない           次の日が日曜日でない           次の次の日が祝日
        if @holiday[i] and @holiday[i + 1] == false and @month_time_objs[i + 1].wday != 0 and @holiday[i + 2]
          @holiday[i + 1] = true
          @holiday_name[i + 1] = '国民の休日'
          i += 1                # skip
        end
        i += 1
      end
    end

    # 休日の日数カウント
    @holidays = 0
    1.upto(@days) { |d|
      @holidays += 1 if holiday?(d)
    }
    @workdays = @days - @holidays
    @not_holidays = @workdays
  end

  # [mday]
  #   日を指定します。(省略不可)
  #
  # 休日であればその休日日本語名称を返す
  # 土曜日はNilを返す
  def holiday_name mday
    return @holiday_name[mday]
  end

  # [mday]
  #   日を指定します。(省略不可)
  #
  # 当日かどうかを返します。
  def today? mday
    @now.year == @year and @now.month == @month and @now.mday == mday
  end

  # [mday]
  #   日を指定します。(省略不可)
  #
  # 平日かどうかを返します。
  def workday? mday
    not holiday? mday
  end

  # [mday]
  #   日を指定します。(省略不可)
  #
  # workday?の別名
  def not_holiday? mday
    workday? mday
  end

  # [mday]
  #   日を指定します。(省略不可)
  #
  # 土日かどうかを返します。
  def weekend? mday
    return nil unless @month_time_objs[mday]
    wday = @month_time_objs[mday].wday
    return wday == 6 || wday == 0
  end

  # [mday]
  #   日を指定します。(省略不可)
  #
  # 土曜日かどうかを返します。
  def saturday? mday
    return nil unless @month_time_objs[mday]
    wday = @month_time_objs[mday].wday
    return wday == 6
  end

  # [mday]
  #   日を指定します。(省略不可)
  #
  # 日曜日かどうかを返します。
  def sunday? mday
    return nil unless @month_time_objs[mday]
    return true if @holiday[mday]
    wday = @month_time_objs[mday].wday
    return wday == 0
  end

  # [mday]
  #   日を指定します。(省略不可)
  #
  # 休日かどうかを返します。
  # 土曜日を休日で返すかは、オブジェクト初期化時の土曜日を休日扱いするか否かの設定で決まる。
  def holiday? mday
    return nil unless @month_time_objs[mday]
    return true if @holiday[mday]
    wday = @month_time_objs[mday].wday

    if (wday == 6 && @saturday_holiday_flg) || wday == 0
      return true
    end

    status(mday) == 'holiday'
  end

  private
  def status(mday)
    return nil unless @month_time_objs[mday]
    return 'holiday' if @holiday[mday]
    wday = @month_time_objs[mday].wday

    case wday
    when 1
      if @month_time_objs[mday].year >= 1973 and mday > 1 and @holiday[mday - 1]
        # 振替休日
        'holiday'
      else
        'workday'
      end
    when 2..5
      furikae2005(mday, wday)
    when 0, 6
      'weekend'
    end
  end

  def wday(mday)
    return nil unless @month_time_objs[mday]
    @month_time_objs[mday].wday
  end

  # 2005 からの振替休日
  # 連続する祝日が日曜日にかかると祝日の終りの次の平日を振替休日になる
  def furikae2005(mday, wday)
    year = @month_time_objs[mday].year
    if year < 2005
      return 'workday'
    end
    if mday <= wday
      return 'workday'
    end
    (1..wday).each do |i|
      if @holiday[mday - i] == false
        return 'workday'
      end
    end
    @holiday_name[mday] = '振替休日'
    'holiday'
  end

  def monday_of_week(n)
    count = 0
    @month_time_objs.each_index do |d|
      next if d < 1
      count += 1 if @month_time_objs[d].wday == 1
      return d if count == n
    end
  end

  # 秋分の日
  def syunbun(year)
    # (31y+2525)/128-y/4+y/100    (1851年-1999年通用)
    # (31y+2395)/128-y/4+y/100    (2000年-2150年通用)
    if year > 2150
      STDERR.print "over year's: #{year}\n"  #'
      exit 1
    end
    v = if year < 2000 then 2213 else 2089 end
    (31 * year + v)/128 - year/4 + year/100
  end

  # 春分の日
  def syubun(year)
    # (31y+2213)/128-y/4+y/100    (1851年-1999年通用)
    # (31y+2089)/128-y/4+y/100    (2000年-2150年通用)
    if year > 2150
      STDERR.print "over year's: #{year}\n" #'
      exit 1
    end
    v = if year < 2000 then 2525 else 2395 end
    (31 * year + v)/128 - year/4 + year/100
  end
end

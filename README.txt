= japan_calendar

* http://github.com/c-ge/JapanCalendar

== DESCRIPTION:

 日本のカレンダークラスです。
 年月を指定するとその月の祝祭日が入ったカレンダー(JapanCalendar)を返します。

== FEATURES/PROBLEMS:

* none

== SYNOPSIS:

  require 'japan_calendar'

  jcal = JapanCalendar.new(2009, 5)
  1.upto(jcal.days) do |day|
    holidayCount += 1 if jcal.holiday? day
    workdayCount += 1 if jcal.workday? day
    puts jcal.holiday_name(day) if jcal.holiday? day
  end

== REQUIREMENTS:

* ruby
* gem

== INSTALL:

* sudo gem install c-ge-JapanCalendar

== LICENSE:

GPLv2

Copyright (c) 2009 cyberwave

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

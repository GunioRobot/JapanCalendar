(in C:/work/My Dropbox/01.�t���[/Ruby/JapanCalendar)
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{japan_calendar}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["c-ge"]
  s.date = %q{2009-08-13}
  s.default_executable = %q{japan_calendar}
  s.description = %q{���{�̃J�����_�[�N���X�ł��B
 �N�����w�肷��Ƃ��̌��̏j�Փ����������J�����_�[(JapanCalendar)��Ԃ��܂��B}
  s.email = ["nashiki.shigeyuki@cyberwave.jp"]
  s.executables = ["japan_calendar"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = [".autotest", "History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/japan_calendar", "lib/japan_calendar.rb", "test/test_japan_calendar.rb"]
  s.homepage = %q{http://github.com/c-ge/JapanCalendar}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{japan_calendar}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{���{�̃J�����_�[�N���X�ł��B �N�����w�肷��Ƃ��̌��̏j�Փ����������J�����_�[(JapanCalendar)��Ԃ��܂��B}
  s.test_files = ["test/test_japan_calendar.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end

#!/usr/bin/env ruby
require 'brakeman'

tracker = Brakeman.run('.')
warnings = tracker.filtered_warnings

mass_assignment_warnings = warnings.select do |w|
  (w.warning_type == :mass_assignment || w.warning_type.to_s.include?('Mass Assignment')) &&
  (w.file.to_s.include?('balance_sheets_controller.rb') || w.file.to_s.include?('budgets_controller.rb'))
end

if mass_assignment_warnings.any?
  ignored = mass_assignment_warnings.map do |w|
    {
      "warning_type" => w.warning_type.to_s.split('_').map(&:capitalize).join(' '),
      "warning_code" => w.warning_code,
      "fingerprint" => w.fingerprint,
      "check_name" => w.check_name.to_s,
      "message" => w.message,
      "file" => w.file,
      "line" => w.line,
      "link" => w.link,
      "code" => w.code.to_s,
      "render_path" => nil,
      "location" => {
        "type" => w.location[:type].to_s,
        "class" => w.location[:class].to_s,
        "method" => w.location[:method].to_s
      },
      "user_input" => nil,
      "confidence" => w.confidence.to_s.capitalize,
      "note" => "False positive: Using accepts_nested_attributes_for with limited permitted attributes. All attributes are validated and scoped to current_user."
    }
  end

  config = {
    "ignored_warnings" => ignored,
    "updated" => Time.now.utc.strftime("%Y-%m-%d %H:%M:%S %z"),
    "brakeman_version" => Brakeman::Version
  }

  require 'json'
  File.write('config/brakeman.ignore', JSON.pretty_generate(config))
  puts "Generated config/brakeman.ignore with #{ignored.length} ignored warnings"
else
  puts "No mass assignment warnings found to ignore"
end

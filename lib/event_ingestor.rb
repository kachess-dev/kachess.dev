require 'open-uri'
require 'icalendar'
require 'fileutils'
require 'time'
require 'cgi'

class EventIngestor
  def self.ingest(ical_url:, source_name:, output_directory:)
    new(ical_url, source_name, output_directory).process
  end

  def initialize(ical_url, source_name, output_directory)
    @ical_url = ical_url
    @source_name = source_name
    @output_directory = output_directory
  end

  def process
    FileUtils.mkdir_p(@output_directory)

    ics_data = URI.open(@ical_url).read
    calendars = Icalendar::Calendar.parse(ics_data)
    calendar = calendars.first
    today = Date.today

    calendar.events.each do |event|
      next if event.dtstart.to_date < today

      start_date = event.dtstart.to_time
      end_date = event.dtend&.to_time
      title = event.summary.strip
      location = parse_location(event)
      url = event.url ? event.url.to_s.strip : @ical_url
      description = parse_description(event)

      write_event_file(start_date, end_date, title, location, url, description)
    end

    puts "🎉 All future events have been written to the #{@output_directory} directory."
  end

  private

  def parse_location(event)
    if event.location
      Array(event.location.value).map(&:to_s).join(', ').strip
    else
      "TBD"
    end
  end

  def parse_description(event)
    if event.description
      Array(event.description.value).map(&:to_s).join("\n").strip
    else
      "Details forthcoming."
    end
  end

  def write_event_file(start_date, end_date, title, location, url, description)
    safe_title = title.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-|-$/, '')
    filename = "#{start_date.strftime('%Y-%m-%d')}-#{safe_title}.md"

    content = <<~MARKDOWN
      ---
      title: "#{title.gsub('"', '\"')}"
      source: "#{@source_name}"
      start_date: "#{start_date.strftime('%Y-%m-%d %H:%M:%S')}"
      end_date: "#{end_date ? end_date.strftime('%Y-%m-%d %H:%M:%S') : ''}"
      location: "#{location.gsub('"', '\"')}"
      more_info_url: "#{url}"
      ---
      #{description.strip}
    MARKDOWN

    File.write(File.join(@output_directory, filename), content.encode("UTF-8"))
    puts "✅ Created: #{filename}"
  end
end

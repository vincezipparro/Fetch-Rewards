# This class attempts to filter out the many, many psuedo-warning and error messages that capybara-webkit likes to throw
# Note that the messages being filtered out below have ZERO impact on test status or performance

class QtPluginMessagesSuppressed
  IGNOREABLE = Regexp.new( [
    'CoreText performance',
    'userSpaceScaleFactor',
    'Internet Plug-Ins',
    'is implemented in bo',
    'unknown URL'
  ].join('|') )

  def write(message)
    if message =~ IGNOREABLE
      0
    else
      puts(message)
      1
    end
  end
end
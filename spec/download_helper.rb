module DownloadHelper
  TIMEOUT = 30
  PATH    = Rails.root.join('tmp/downloads')
  require 'roo'
  require 'roo-xls'

  module_function

  def downloads
    Dir[PATH.join('*')]
  end

  def download
    downloads.first
  end

  def download_content
    wait_for_download
    # puts 'download file contents:', "'#{File.read(download)}'"

    if File.read(download).eql? ''
      # puts 'Waiting an extra 22 seconds to check the directory...'
      sleep 8
      # puts %x{ls -lah #{PATH}}
    end

    if File.read(download).eql? ''
      # puts 'Waiting an extra 8 seconds to check the directory...'
      sleep 25
      # puts %x{ls -lah #{PATH}}
    end

    File.read(download)
  end

  # prevents test from erroring out if sheet is empty
  def empty_sheet_check(xls)
    if !xls.first_row
      true
    else
      false
    end
  end

  def download_content_colored
    wait_for_download
    xls = Roo::Excel.new(download)
    xls.default_sheet = xls.sheets[0]
    headers = {}
    headers_add = {}

    # headers are typically on the following rows
    xls.row(5).each_with_index { |header, i| headers[header] = i }
    xls.row(6).each_with_index { |header, i| headers_add[header] = i }
    headers.merge(headers_add)
  end

  def download_content_headers
    wait_for_download
    # puts 'download file contents:', "'#{File.read(download)}'"
    xls = Roo::Excel.new(download)
    xls.default_sheet = xls.sheets[0]
    headers = {}

    # if the sheet is empty, assign the header to null so test doesn't fail
    if !empty_sheet_check(xls)
      xls.row(1).each_with_index { |header, i| headers[header] = i }
    else
      headers = { a: 'null' }
    end
  end

  def wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 1 until downloaded?
    end

    # puts %x{ls -lah #{PATH}}
  end

  def downloaded?
    !downloading? && downloads.any?
  end

  def downloading?
    # chrome extension for a partially downloaded file
    downloads.grep(/\.crdownload$/).any?
  end

  def clear_downloads
    FileUtils.rm_f(downloads)
  end

  def download_file_size
    wait_for_download

    File.size?(download)
  end

  def download_file_name
    wait_for_download

    File.basename(download)
  end
end

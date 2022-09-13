module Blacklist
  def blacklist
    @_blacklist ||= File.read(Rails.root.join 'lib', 'blacklist.txt').split
  end
end
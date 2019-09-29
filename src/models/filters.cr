class Filter < Granite::Base
  connection pg
  table filters

  column id : Int64, primary: true
  column severity : Int32
  column regex : String?
  timestamps

  def self.filter_severity(input : String)
    all.each do |filter|
      unless (/#{filter.regex}/m =~ input).nil?
        return filter.severity
      end
    end
    nil
  end
end

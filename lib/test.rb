require "date"
year = DateTime.now.year
month = DateTime.now.month
icntr = 0
while ((year > 2009) and (icntr <= 48) and (!(month == 0)))
  icntr += 1
  if !(month == 0)
    date_start = Date.new(year, month, 1)
    puts date_start
    d = date_start
    d += 42
    puts 'd: '
    puts d
    date_end =  Date.new(d.year, d.month) - 1
    puts date_end
    #CalculateSite.new(site_id,date_start,date_end).perform
    puts "kano doulia gia"+date_start.to_s+" mexri "+date_end.to_s
    month -= 1
    if month == 0 then
      year -= 1
      month = 12
    end
    puts 'Year: '
    puts year
    puts 'Month: '
    puts month
  end
end


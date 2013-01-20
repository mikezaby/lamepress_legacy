class String

  def summarize
    text = Nokogiri::HTML(self).to_str
    return text if text.size <= 300

    stop = text.index('.', 260)
    (stop.present? && stop < 500) ? text[0..stop] : text[0..300]
  end

  def bold(value)
    self.gsub(value, "<b>"+value+"</b>")
  end

  def lm_strip
    self.strip.gsub(/[\~]|[\`]|[\!]|[\@]|[\#]|[\$]|[\%]|[\^]|[\&]|[\*]|[\(]|[\)]|[\+]|[\=]|[\{]|[\[]|[\}]|[\]]|[\|]|[\\]|[\:]|[\;]|[\"]|[\']|[\<]|[\,]|[\>]|[\.]|[\?]|[\/]/,"").gsub(/\s+/,"-").downcase
  end
end

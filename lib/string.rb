class String
  TRUE_ALIASES = %w(1 true)
  FALSE_ALIASES = %w(0 false)

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

  def to_bool
    bool_check = ->(value) { casecmp(value) == 0 }
    return true if TRUE_ALIASES.any?(&bool_check)
    return false if FALSE_ALIASES.any?(&bool_check)
    raise "Cant convert #{self} to boolean"
  end
end

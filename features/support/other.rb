module Other
  def decolorize(s)
    s.gsub(/\e\[\d*m/, '')
  end
end
xml.instruct!
xml.paths do
  @paths.each do |path|
    xml.path do
      xml.id path.id
      path.coordinates.each do |c|
        xml.coord c.x.to_s + "," + c.y.to_s
      end
    end
  end
end
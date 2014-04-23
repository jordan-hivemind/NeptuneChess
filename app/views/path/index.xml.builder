xml.instruct!
xml.paths do
  @paths.each do |path|
    xml.path do
      xml.id path.id
      path.coordinates.each do |c|
        xml.coordinate do
          xml.id c.id
          xml.x c.x
          xml.y c.y
        end
      end
    end
  end
end
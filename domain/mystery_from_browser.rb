MysteryFromBrowser = Struct.new(
  :title,
  :url,
  :image,
  :content,
  :story
) do
  def segregate_content(content)
    puts content.split('開催期間', 0)
  end
end

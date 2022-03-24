tasks = [
  "ランニング",
  "皿洗い",
  "本を読む",
  "机の掃除"
]

tasks.each do |name| 
  Task.create(name: name)
end
tasks = [
  "ランニングする",
  "皿洗いする",
  "本を読む",
  "机の掃除",
  "散歩する",
  "洗濯物を干す",
  "倉庫の整理をする",
  "将棋をする",
  "漫画を読む",
  "プログラミングをする"
]

tasks.each do |name| 
  Task.create(name: name)
end
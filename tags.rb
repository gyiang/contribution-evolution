require 'set'

# 获取tag并合并tag信息
def tags git_tree
  tags=[]
  `git #{git_tree} tag`.each_line do |tag|
    tags.push(tag.chomp)
  end

  # get tag's date
  tags_date={}
  tags.each do |tag|
    `git #{git_tree} show #{tag} --date=short`.each_line do |line|
      if line.start_with?("Date:") then
        tags_date["#{tag}"]=line.match(/\d{4}-\d{2}-\d{2}/)[0]
        break
      end
    end
  end

  # sort by hash-value
  tags_date=Hash[tags_date.sort_by{|k,v|v}]

  tags_date_new={}
  # merge tag versions(v0.x.y) to v0.x
  test = Set.new
  tags_date.each_pair do |k,v|
    tag=k.match(/(v\d+\.\d+)/)[0]
    if tags_date_new[tag]!=nil
      next
    else
      tags_date_new[tag]=v
    end
    test.add tag
  end
  p tags_date
  p tags_date_new


  tags_date_new
end
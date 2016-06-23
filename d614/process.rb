require 'set'



$git_tree="--git-dir=/home/other/Desktop/elasticsearch2/.git"
DB=Sequel.connect('mysql2://root:1234@192.168.8.128:3306/by?characterEncoding=UTF-8')

DB.create_table?(:metric,:charset => 'utf8') do

  String :author
  String :tag
  Integer :cmt
  Integer :add
  Integer :del
  Integer :fixs
  Integer :closes
  Integer :issues
  Integer :comments

end

authors=[]
`git #{$git_tree} log --pretty="%an" | sort | uniq -c`.each_line do |line|
  cmt,author= line.chomp.split(' ',2)
  authors<<[author,cmt.to_i]
end


tags=[]
`git #{$git_tree} tag`.each_line do |tag|
  tags.push(tag.chomp)
end

# merge tag versions(v0.x.y) to v0.x
# get tag's date
tags_date={}
tags.each do |tag|
  `git #{$git_tree} show #{tag} --date=short`.each_line do |line|
    if line.start_with?("Date:") then
      tags_date["#{tag}"]=line.match(/\d{4}-\d{2}-\d{2}/)[0]
      break
    end
  end
end

# sort by hash-value
tags_date=Hash[tags_date.sort_by{|k,v|v}]

test = Set.new
tags_date.each_pair do |k,v|
  tag=k.match(/(v\d+\.\d+)/)[0]
  test.add tag
end

authors.each do |author|
  radar={}
  ur={} #store data
  tags_date.each do |k,v|
    cmt=`git #{$git_tree} log --pretty=oneline --author="^#{author}" --before={#{v}} | wc -l`.chomp

    add, del, changes=`git #{$git_tree}  log --author="^#{author}" --before={#{v}} --pretty=tformat: --numstat |
   gawk '{ add += $1;subs += $2;loc += $1 + $2} END {printf("%s,%s,%s",add,subs,loc)}' -`.split(",")

    fixs=`git #{$git_tree} log --pretty="%s" --author="^#{author}" --before="#{v}" | grep -P '(fix|fixes|fixed)' | wc -l`.chomp

    closes=`git #{$git_tree} log --pretty="%s" --author="^#{author}" --before="#{v}" | grep -P '(close|closes|closed)\s#\\d+' | wc -l`.chomp

    # try to pre it
    # id=DB[:users].select(:user_id).where(:git_name=>"#{author}").all[0][:user_id]

    # merge tag
    tag=k.match(/(v\d+\.\d+)/)[0]
    if (radar[tag]==nil or radar[tag][0]<cmt.to_i)
      radar[tag]=[cmt.to_i,add.to_i,del.to_i,fixs.to_i,closes.to_i,v]
    end

    p "#{k}==>#{radar[tag]}"
  end



end


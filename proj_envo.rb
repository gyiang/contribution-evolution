require 'sequel'
load 'tags.rb'

git_tree='--git-dir=/home/other/Desktop/elasticsearch2/.git'

DB=Sequel.connect('mysql2://root:1234@192.168.8.163:3306/by?characterEncoding=UTF-8')

DB.create_table!(:repo_proj_tag,:charset => 'utf8') do
  String :tag
  String :date
  Integer :cmt
  Integer :add
  Integer :del
  Integer :fixes
  Integer :closes
  Integer :issues
  Integer :pr
  Integer :comments
end

items=DB[:repo_proj_tag]

tags_hash=tags(git_tree)
tags_hash['master']='2016-06-10'


  #

tags_hash.each do |tag,date|
  # init item
  item={}

  issues= DB[:repo_issues].where("created_at < '#{date}'").and('pull_request is null').count
  pr=DB[:repo_issues].where("created_at < '#{date}'").and('pull_request is not null').count
  comments=DB[:issues_comments].where("created_at < '#{date}'").count

  cmt=`git #{git_tree} log --pretty=oneline --before={#{date}} | wc -l`.chomp

  add, del, changes=`git #{git_tree} log --before={#{date}} --pretty=tformat: --numstat |
        gawk '{ add += $1;subs += $2;loc += $1 + $2} END {printf("%s,%s,%s",add,subs,loc)}' -`.split(",")

  fixes=`git #{git_tree} log --pretty="%s" --before={#{date}} | grep -P '(fix|fixes|fixed)' | wc -l`.chomp

  closes=`git #{git_tree} log --pretty="%s" --before={#{date}} | grep -P '(close|closes|closed)\s#\\d+' | wc -l`.chomp


  # item
  item[:tag]=tag
  item[:date]=date
  item[:cmt]=cmt.to_i

  if add.nil?
    item[:add]=0
  else
    item[:add]=add.to_i
  end

  if del.nil?
    item[:del]=0
  else
    item[:del]=del.to_i
  end

  item[:fixes]=fixes.to_i
  item[:closes]=closes.to_i


  p [tag,cmt,add,del,fixes,closes,issues,pr,comments]
  item[:issues]=issues
  item[:pr]=pr
  item[:comments]=comments

  #
  items.insert(item)

end









p nil.to_s



require 'sequel'
load 'tags.rb'

git_tree='--git-dir=/home/other/Desktop/elasticsearch2/.git'

DB=Sequel.connect('mysql2://root:1234@192.168.8.128:3306/by?characterEncoding=UTF-8')

DB.create_table?(:repo_contr_tag,:charset => 'utf8') do
  String :author
  String :author_login
  Integer :cmt
  Integer :add
  Integer :del
  Integer :fixes
  Integer :closes
  Integer :issues
  Integer :pr
  Integer :comments
  String :tag
end

authors=[]
`git #{git_tree} log --pretty="%an" | sort | uniq -c`.each_line do |line|
  cmt,author= line.chomp.split(' ',2)
  authors<<[author,cmt.to_i]
end

items=DB[:repo_contr_tag]
item={}


tags_hash=tags(git_tree)
tags_hash["master"]='2016-06-10'
length=authors.size

author='Adrien Grand'
al=DB[:repo_commits].select(:author,:author_login).where("author=\"#{author}\"").limit(1).all


tags_hash.each do |tag,date|
  # try get login
  # bug fix at 2016年6月20日13:35:18
  # 以时间,date加'
  p date
  if al!=[] then
    author_login= al.first[:author_login]
    issues= DB[:repo_issues].where(:login=>author_login).and("created_at < '#{date}'").and('pull_request is null').count
    pr=DB[:repo_issues].where(:login=>author_login).and("created_at < '#{date}'").and('pull_request is not null').count
    comments=DB[:issues_comments].where(:login=>author_login).and("created_at < '#{date}'").count
  end

  cmt=`git #{git_tree} log --pretty=oneline --author="^#{author} <" --before={#{date}} | wc -l`.chomp

  add, del, changes=`git #{git_tree} log --author="^#{author} <" --before={#{date}} --pretty=tformat: --numstat |
        gawk '{ add += $1;subs += $2;loc += $1 + $2} END {printf("%s,%s,%s",add,subs,loc)}' -`.split(",")

  fixes=`git #{git_tree} log --pretty="%s" --author="^#{author} <"  --before={#{date}} | grep -P '(fix|fixes|fixed)' | wc -l`.chomp

  closes=`git #{git_tree} log --pretty="%s" --author="^#{author} <" --before={#{date}} | grep -P '(close|closes|closed)\s#\\d+' | wc -l`.chomp

  item[:tag]=tag
  item[:author]=author
  item[:author_login]=author_login
  item[:cmt]=cmt.to_i

  if add.nil?
    add=0
  else
    item[:add]=add.to_i
  end

  if del.nil?
    del=0
  else
    item[:del]=del.to_i
  end

  item[:fixes]=fixes.to_i
  item[:closes]=closes.to_i

  if al!=[]
    p [tag,author,author_login,cmt,add,del,fixes,closes,issues,pr,comments]
    item[:issues]=issues
    item[:pr]=pr
    item[:comments]=comments
  else
    p [tag,author,nil,cmt,add,del,fixes,closes,0,0,0]
    item[:issues]=0
    item[:pr]=0
    item[:comments]=0
  end

  #items.insert(item)
  p item
end









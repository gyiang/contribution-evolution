require 'sequel'

git_tree='--git-dir=/home/other/Desktop/elasticsearch2/.git'

DB=Sequel.connect('mysql2://root:1234@192.168.8.128:3306/by?characterEncoding=UTF-8')

DB.create_table?(:repo_contributors,:charset => 'utf8') do
  String :author
  String :author_login
  String :tag
  Integer :cmt
  Integer :add
  Integer :del
  Integer :fixes
  Integer :closes
  Integer :issues
  Integer :pr
  Integer :comments
end

authors=[]
`git #{git_tree} log --pretty="%an" | sort | uniq -c`.each_line do |line|
  cmt,author= line.chomp.split(' ',2)
  authors<<[author,cmt.to_i]
end

items=DB[:repo_contributors]
item={}

length=authors.size
authors.each_with_index do |author,index|
  author=author[0]

  # try get login
  # bug fix at 2016年6月20日13:35:18
  al=DB[:repo_commits].select(:author,:author_login).where("author=\"#{author}\"").limit(1).all
  if al!=[] then
    author_login= al.first[:author_login]
    issues= DB[:repo_issues].where(:login=>author_login).and('pull_request is null').count
    pr=DB[:repo_issues].where(:login=>author_login).and('pull_request is not null').count
    comments=DB[:issues_comments].where(:login=>author_login).count
  end

  cmt=`git #{git_tree} log --pretty=oneline --author="^#{author} <" | wc -l`.chomp

  add, del, changes=`git #{git_tree} log --author="^#{author} <" --pretty=tformat: --numstat |
          gawk '{ add += $1;subs += $2;loc += $1 + $2} END {printf("%s,%s,%s",add,subs,loc)}' -`.split(",")

  fixes=`git #{git_tree} log --pretty="%s" --author="^#{author} <" | grep -P '(fix|fixes|fixed)' | wc -l`.chomp

  closes=`git #{git_tree} log --pretty="%s" --author="^#{author} <" | grep -P '(close|closes|closed)\s#\\d+' | wc -l`.chomp

  item[:author]=author
  item[:author_login]=author_login
  item[:cmt]=cmt.to_i
  item[:add]=add.to_i
  item[:del]=del.to_i
  item[:fixes]=fixes.to_i
  item[:closes]=closes.to_i

  if al!=[]
    p ["#{index}/#{length}",author,author_login,cmt,add,del,fixes,closes,issues,pr,comments]
    item[:issues]=issues
    item[:pr]=pr
    item[:comments]=comments
  else
    p ["#{index}/#{length}",author,nil,cmt,add,del,fixes,closes,0,0,0]
    item[:issues]=0
    item[:pr]=0
    item[:comments]=0
  end

  items.insert(item)
end








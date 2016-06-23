# he bing tag cao zuo

require 'sequel'

DB=Sequel.connect('mysql2://root:1234@192.168.8.163:3306/by?characterEncoding=UTF-8')

all_contr_tag=
DB[:repo_contr_tag].with_sql('SELECT author_login,tag,
SUM(`cmt`) as cmt,
SUM(`add`) as `add`,
SUM(del) as del,
SUM(fixes) as fixes,
SUM(closes) as closes ,
FLOOR(avg(issues)) as issues ,
FLOOR(avg(comments)) as comments,
FLOOR(avg(pr)) as pr FROM repo_contr_tag GROUP BY author_login,tag'.gsub("\n",'')).all

items=DB[:repo_contr_tag_merge]
all_contr_tag.each do |item|
  next if item[:author_login].nil?
  author=DB[:repo_commits].select(:author).where(:author_login=>item[:author_login]).order_by(Sequel.desc(:date)).first[:author]
  item[:author]=author
  items.insert(item)
end



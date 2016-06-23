

# 整理提交为0，但是有issue和comments的情况


require 'sequel'
DB=Sequel.connect('mysql2://root:1234@192.168.8.128:3306/by?characterEncoding=UTF-8')


p 'start create table'
DB.create_table?(:net_users,:charset => 'utf8') do
  String :login
  Integer :issues
  Integer :comments
  Integer :cmt
end

p 'start update issues'
item={}
DB[:repo_issues].select(:login).group_and_count(:login).all.each do |row|
  item[:login]=row[:login]
  item[:issues]=row[:count]
  DB[:net_users].insert(item)
end


p 'start update comments'
item={}
DB[:issues_comments].select(:login).group_and_count(:login).all.each do |row|

  # 更新 ，成功返回更新数，否则 0
  r=DB[:net_users].where(:login=>row[:login]).update(:comments=>row[:count])

  # 没更新=》没找到=》插入
  if r==0 then
    item[:login]=row[:login]
    item[:issues]=0
    item[:comments]=row[:count]
    DB[:net_users].insert(item)
  end
end
DB[:net_users].where(:comments=>nil).update(:comments=>0)


p 'start update commits'
item={}
DB[:repo_commits].select(:author_login).group_and_count(:author_login).all.each do |row|
  r=DB[:net_users].where(:login=>row[:author_login]).update(:cmt=>row[:count])
  if r==0 then
    item[:login]=row[:author_login]
    item[:issues]=0
    item[:comments]=0
    item[:cmt]=row[:count]
    DB[:net_users].insert(item)
  end
end
DB[:net_users].where(:cmt=>nil).update(:cmt=>0)
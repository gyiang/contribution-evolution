require 'sequel'
require 'pp'
DB=Sequel.connect('mysql2://root:1234@192.168.8.128:3306/by?characterEncoding=UTF-8')


DB[:repo_commits].select('COUNT(DISTINCT author,author_login) as cnt,author_login')
      .group_by(:author_login).having('cnt>1')



#以后再研究
p DB[:repo_commits].select(:author).where(:author_login=>"kimchy").order_by(Sequel.desc(:date)).first

require 'sequel'

# 合并贡献量

DB=Sequel.connect('mysql2://root:1234@192.168.8.128:3306/by?characterEncoding=UTF-8')

a=[]
DB[:repo_contributors].select().all do |row|
  a<<row
end

#key=author_login value={hash}
h={}
a.each do |row|
  author=row[:author]
  author_login=row[:author_login]

  p [author,author_login]

  row.delete(:author_login)
  row.delete(:author)

  if !h[author_login] then
    h[author_login]=row
  else
    row.delete(:author_login)
    row.delete(:author)
    row.each_key do |key|
      h[author_login][key]=row[key]+h[author_login][key]
    end
  end
end


# insert data
DB.create_table?(:repo_contributors_merge,:charset => 'utf8') do
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
  Integer :files
end

h.each_pair do |author_login,item|

  if author_login==nil
    next
  end

  author=DB[:repo_commits].select(:author).where(:author_login=>author_login).order_by(Sequel.desc(:date)).first[:author]
  item[:author]=author
  item[:author_login]=author_login
  DB[:repo_contributors_merge].insert(item)

end



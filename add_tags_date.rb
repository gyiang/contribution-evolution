load 'tags.rb'
require 'sequel'

git_tree='--git-dir=/home/other/Desktop/elasticsearch2/.git'
tags_date=tags(git_tree)
tags_date['master']='2016-06-10'

DB=Sequel.connect('mysql2://root:1234@192.168.8.163:3306/by?characterEncoding=UTF-8')

tags_date.each do |tag,date|
  DB[:repo_contr_tag_merge].where(:tag=>tag).update(:date=>date)
end


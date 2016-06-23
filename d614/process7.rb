require 'sequel'
git_tree="--git-dir=/home/other/Desktop/elasticsearch2/.git"
work_tree="/home/other/Desktop/elasticsearch2"

files=[]
`git #{git_tree} ls-tree -r --name-only master`.each_line do |line|
  files<<line.chomp
end

# key=author value=file_change_cnt
file_changes={}

size=files.size
files.each_with_index do |file,index|
  p ["#{index}/#{size}",file]
  `cd #{work_tree} && git log --pretty="%an" #{file} | sort | uniq`.each_line do |line|
    author=line.chomp
    if !file_changes[author] then
      file_changes[author]=1
    else
      file_changes[author]=file_changes[author]+1
    end
  end
end

DB=Sequel.connect('mysql2://root:1234@192.168.8.128:3306/by?characterEncoding=UTF-8')

file_changes.each_pair do |author,cnt|
  DB[:repo_contributors].where(:author=>author).update(:files=>cnt)
end
$git_tree="--git-dir=/home/other/Desktop/elasticsearch2/.git"
authors=[]

`git #{$git_tree} log --pretty="%an" | sort | uniq -c`.each_line do |line|
  cmt,author= line.chomp.split(' ',2)
  authors<<[author,cmt.to_i]
end

authors.each do |author|

end
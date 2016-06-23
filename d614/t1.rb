

while true
    pid=`ps -aux | awk '{print $11}' | grep -Dhadoop`

    if pid == ''
      exec(path,dir)
    end

    sleep 10

end
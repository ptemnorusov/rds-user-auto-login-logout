#Script, that helps to login on behalf of every specified username and then logout


function Index ([string]$username, [string]$userpassword, [string]$servername, [int]$sleeptimer) {
 taskkill -f -im "SearchProtocolHost.exe"
 cmdkey /delete:TERMSRV/$servername
 cmdkey /generic:"$servername" /user:"$username" /pass:"$userpassword"
 mstsc /v:"$servername"
 $message = "#############################`r`nUser $username on $servername started to index`r`n#############################"
 d:\distr\curl\bin\curl -X POST --silent --output /dev/null https://api.telegram.org/BOT_TOKEN/sendMessage -d chat_id=CHAT_ID -d parse_mode=html -d text="$message"
 get-date
 sleep $sleeptimer
 $message = "#############################`r`nIndex for user $username on $servername ended`r`n#############################"
 d:\distr\curl\bin\curl -X POST --silent --output /dev/null https://api.telegram.org/BOT_TOKEN/sendMessage -d chat_id=CHAT_ID -d parse_mode=html -d text="$message"
 
 $sessionId = ((quser /server:$servername | Where-Object { $_ -match "$username" }) -split ' +')[3]
 $sessiontext = "Номер сессии пользователя $username : $sessionId"
 echo $sessiontext
 logoff $sessionId /server:$servername
 #sleep 180
 }

# Wait before start
sleep 1

Index user1_name user1_password rds_servername user1_timeout  #elements 700
Index user1_name user2_password rds_servername user2_timeout  #elements 1700
Index user1_name user3_password rds_servername user3_timeout  #elements 2700

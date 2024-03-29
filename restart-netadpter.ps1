$t = 3
$log = 'E:\XMTT\Router.log.txt'
$num = 0
$content1 = "##########"
$content2 = "监控次数"
$restart = 0
$url = 'www.baidu.com'

Get-NetAdapter -Name 'WLAN' | Restart-NetAdapter

Start-Sleep 30

if ((Get-WmiObject -query "SELECT * FROM Win32_PingStatus WHERE Address = '$url'").StatusCode -eq 0){ 
    "The route is online!" 
    Write-Output "重启成功" >>$log
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss.ffff')" >>$log
    Exit-PSHostProcess
} else {
    "再次重启路由网卡"
    $restart = $restart + 1
    Get-NetAdapter -Name 'WLAN' | Restart-NetAdapter
    Start-Sleep 30
    if ((Get-WmiObject -query "SELECT * FROM Win32_PingStatus WHERE Address = '$url'").StatusCode -eq 0){
        "The route is online!"
        Write-Output "重启成功" >>$log
        Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss.ffff')" >>$log
        Exit-PSHostProcess 
        }else {
            Write-Output "恢复失败" >>$log
            Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss.ffff')" >>$log
            Exit-PSHostProcess 
        }
}
# Clear-Host
#t1间隔时间s
$t = 3
$log = 'D:\Router.log.txt'

$num = 0
$content1 = "##########"
$content2 = "监控次数"
$restart = 0
$url = 'www.baidu.com'

if (Test-Path $log) { }else {
    Write-Output "log"
    Write-Output $content1 >$log
    Write-Output $content2 >>$log
    Write-Output $num >>$log
    Write-Output $content1 >>$log
}
while (1 -lt 2) {
    Start-Sleep $t
    Clear-Host
    $log1 = Get-Content $log
    $num = $log1[2]
    $num = [int]$num + 1
    #print
    Write-Output $content1
    Write-Output "$($content2):$($num)"
    Write-Output "监控间隔：$($t)s"
    Write-Output "重启网卡：$($restart)"
    Write-Output $content1
    #write
    Write-Output $content1 >$log
    Write-Output $content2 >>$log
    Write-Output $num >>$log
    Write-Output $log1[3..($log1.count - 1)] >>$log
    #check
    if ((Get-WmiObject -query "SELECT * FROM Win32_PingStatus WHERE Address = '$url'").StatusCode -eq 0) {
        "The router is online!"
    }
    else {
        "The router is offline!"
        "重启路由网卡"
        $restart = $restart + 1
        Get-NetAdapter -Name 'WLAN' | Restart-NetAdapter
        Start-Sleep 60
        if ((Get-WmiObject -query "SELECT * FROM Win32_PingStatus WHERE Address = '$url'").StatusCode -eq 0)
        { "The route is online!" }
        else {
            "再次重启路由网卡"
            $restart = $restart + 1
            Get-NetAdapter -Name 'WLAN' | Restart-NetAdapter
            Start-Sleep 60
            if ((Get-WmiObject -query "SELECT * FROM Win32_PingStatus WHERE Address = '$url'").StatusCode -eq 0)
            { "The route is online!" }
            else {
                Write-Output "恢复失败" >>$log
                Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss.ffff')" >>$log
                break;
            }
        }
    }
}
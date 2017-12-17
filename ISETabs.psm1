function New-ISERemoteTab
{
    [Alias('nirt')]

    [CmdletBinding()]

    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$ComputerName
    )
    process
    {
        foreach ($Computer in $ComputerName)
        {
            $NewTab = $psISE.PowerShellTabs.Add()
            $NewTab.Displayname = $Computer
            Start-Sleep -Seconds 1
            $NewTab.Invoke( {Enter-PSSession -ComputerName $psISE.CurrentPowerShellTab.DisplayName; Clear-Host})
        }
    }
}
function New-ISERemoteTab
{
    <#
    .SYNOPSIS
    Create a new remote ISE tab

    .DESCRIPTION
    Create a new remote ISE tab

    .PARAMETER ComputerName
    The computer to which the remote session will be created

    .EXAMPLE
    New-ISERemoteTab -ComputerName 'Server1','Server2','Server3'

    .EXAMPLE
    'Server1','Server2','Server3' | New-ISERemoteTab
    #>

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
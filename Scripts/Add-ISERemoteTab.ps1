function Add-ISERemoteTab {
    <#
    .SYNOPSIS
    Add ISE tabs to a list.

    .DESCRIPTION
    When you create a list of tabs with New-ISERemoteTab, you can latter add ISE tabs to this list with Add-ISERemoteTab.
    If the tab already exist it will be added to the list.
    If the tab does not exist, it will be created.

    .PARAMETER TabName
    The name of the tab you want to add to the existing list.

    .PARAMETER PowerShellTab
    The list of tabs to which you want to add one or several tab(s).

    .EXAMPLE
    $PowerShellTabList = Add-ISERemoteTab -PowerShellTab $PowerShellTabList -TabName 'ComputerName'

    In this example, you add the tab named 'ComputerName' to the $ISETabList array.
    #>

    [Alias('airt')]

    [CmdletBinding()]

    [OutputType('Microsoft.PowerShell.Host.ISE.PowerShellTab')]

    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            Position = 0
        )]
        [Microsoft.PowerShell.Host.ISE.PowerShellTab[]]$PowerShellTab,

        [Parameter(
            Mandatory,
            Position = 1
        )]
        [string[]]$TabName
    )

    Process {
        $PowerShellTab

        foreach ($Tab in $TabName) {
            if ($PowerShellTab.DisplayName -contains $Tab) {
                $Message = "The collection already contains a tab named $Tab"
                Write-Error -Message $Message
            }
            else {
                if ($psISE.PowerShellTabs.DisplayName -Contains $Tab) {

                    $Message = 'The {0} tab already exists and will be added to the list' -f $Tab
                    Write-Warning -Message $Message

                    $psISE.PowerShellTabs.Where( { $PSItem.DisplayName -eq $Tab })
                }
                else {
                    $NewTab = $psISE.PowerShellTabs.Add()

                    $ISETab.Displayname = $Tab

                    $NewTab
                }
            }
        }
    }
}

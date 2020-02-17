function Remove-ISERemoteTab {
    <#
    .SYNOPSIS
    Remove ISE tabs from a list.

    .DESCRIPTION
    When you create a list of tabs with New-ISERemoteTab, you can remove ISE tabs from this list with Remove-ISERemoteTab.

    .PARAMETER TabName
    The name of the tab(s) you want to remove from the array.

    .PARAMETER PowerShellTab
    The list of tabs from which you want to remove one or several tab(s).

    .PARAMETER KeepOpen
    Removes tabs from the list but don't close them.

    .PARAMETER CleanOrphanTab
    This parameter checks for tabs which don't exist anymore and removes them from the list.

    .EXAMPLE
    $PowerShellTabList = Remove-ISERemoteTab -PowerShellTab $PowerShellTabList -TabName 'MyRemoteComputer'

    In this example, you remove the tab named 'MyRemoteComputer' from the array $ISETabList

    .EXAMPLE
    $PowerShellTabList = Remove-ISERemoteTab -PowerShellTab $PowerShellTabList -CleanOrphanTabs

    In this example, the cmdlet checks for tabs which don't exist anymore and remove them from the array.
    #>

    [Alias('rirt')]

    [CmdletBinding(DefaultParameterSetName = 'TabName')]

    [OutputType('Microsoft.PowerShell.Host.ISE.PowerShellTab')]

    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            Position = 0
        )]
        [Microsoft.PowerShell.Host.ISE.PowerShellTab[]]$PowerShellTab,

        [Parameter(
            ParameterSetName = 'TabName',
            Position = 1
        )]
        [string[]]$TabName = '\.*',

        [Parameter(ParameterSetName = 'TabName')]
        [switch]$KeepOpen,

        [Parameter(ParameterSetName = 'OrphanTab')]
        [switch]$CleanOrphanTabs
    )

    Begin {
        if ($PSBoundParameters['Debug']) {
            $DebugPreference = 'Continue'
        }

        '$TabName:{0}' -f $TabName | Write-Debug
        '$KeepOpen:{0}' -f $KeepOpen | Write-Debug
        '$CleanOrphanTabs:{0}' -f $CleanOrphanTabs | Write-Debug
        '$PowerShellTab:{0}' -f $PowerShellTab | Write-Debug
    }

    Process {

        foreach ($Tab in $PowerShellTab) {
            switch ($PSCmdlet.ParameterSetName) {
                'TabName' {
                    $MatchFound = $false

                    foreach ($TabNameItem in $TabName) {

                        If ($Tab.DisplayName -match $TabNameItem) {
                            $MatchFound = $true
                            Break
                        }
                    }

                    If ($MatchFound) {

                        If (-not($PSBoundParameters['KeepOpen'])) {

                            $Message = 'Closing tab named {0}' -f $Tab.DisplayName
                            Write-Verbose -Message $Message

                            $Null = $psISE.PowerShellTabs.Remove($Tab)
                        }
                    }
                    else {
                        $Tab
                    }
                }

                'OrphanTab' {
                    if ($psISE.PowerShellTabs.DisplayName.Contains($Tab.DisplayName)) {
                        $Tab
                    }
                    else {
                        $Message = 'Removing tab named {0}...' -f $Tab.DisplayName
                        Write-Verbose -Message $Message
                    }
                }
            }
        }
    }
}

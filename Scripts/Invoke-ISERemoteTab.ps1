function Invoke-ISERemoteTab {
    <#
    .SYNOPSIS
    Invoke existing ISE tabs and executes a script block.

    .DESCRIPTION
    Invoke existing ISE tabs and executes a script block.

    .PARAMETER PowerShellTab
    Specify an ISE PowerShell tab object.

    .EXAMPLE
    $PowerShellTabList = New-ISERemoteTab -ComputerName 'Comp1','Comp2' -PassThru
    Invoke-ISERemoteTab -PowerShellTab $PowerShellTabList -ScriptBlock {Get-ChildItem -Path C:\temp}

    In this example, you create two ISE tabs with a remote PSSession and assign the tab object to $PowerShellTabList.
    Then you invoke the two tabs you just created and run a command-line inside.
    #>

    [Alias('iirt')]

    [CmdletBinding()]

    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [Microsoft.PowerShell.Host.ISE.PowerShellTab[]]$PowerShellTab,

        [Parameter(
            Mandatory,
            Position = 1
        )]
        [scriptblock]$ScriptBlock
    )

    Process {
        foreach ($ISETab in $PowerShellTab) {
            $TabDisplayName = $ISETab.DisplayName
            Write-Verbose -Message "Invoking $TabDisplayName tab..."

            If ($ISETab.CanInvoke) {
                $ISETab.Invoke($ScriptBlock)
            }
            else {
                Write-Warning -Message "The $TabDisplayName tab is busy or does not exist anymore!"
            }
        }
    }
}

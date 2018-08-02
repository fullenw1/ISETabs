function New-ISERemoteTab
{
    <#
    .SYNOPSIS
    Create ISE tabs with a PSSession to a remote computer.

    .DESCRIPTION
    Create ISE tabs with a PSSession to a remote computer.

    .PARAMETER ComputerName
    Computer name for the tab name and PSSession.

    .EXAMPLE
    New-ISERemoteTab -ComputerName 'Comp1','Comp2'

    .EXAMPLE
    'Comp1','Comp2' |New-ISERemoteTab -ComputerName

    .EXAMPLE
    $ISETabs = New-ISERemoteTab 'Comp1','Comp2' -PassThru
    $ISETabs | ForEach-Object -Process {$_.invoke({Get-ChildItem -Path C:\})}

    In this example, you create two ISE tabs with a remote PSSession and assign the tab object to $ISETabs.
    Then you invoke the same command-line to all selected tabs.
    #>

    [Alias('nirt')]

    [CmdletBinding()]

    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$ComputerName,

        [switch]$PassThru
    )

    Begin
    {
        if (!($psISE))
        {Throw 'This cmdlet must be run from inside an ISE console.'}
    }

    Process
    {
        $RemoteTabsList = [System.Collections.ArrayList]::new($ComputerName.Count)

        foreach ($Computer in $ComputerName)
        {
            Write-Verbose -Message "Creating new remote tab for $Computer..."
            $ISETab = $psISE.PowerShellTabs.Add()

            $Null = $RemoteTabsList.Add($ISETab)

            $ISETab.Displayname = $Computer
            while (!($ISETab.CanInvoke)) {Start-Sleep -Milliseconds 500}
            $ISETab.Invoke( {Enter-PSSession -ComputerName $psISE.CurrentPowerShellTab.DisplayName})
        }

        foreach ($Tab in $RemoteTabsList)
        {
            $TabName = $Tab.Displayname
            Write-Verbose -Message "Checking PSSession for $TabName..."
            while (!($Tab.CanInvoke)) {Start-Sleep -Milliseconds 500}
            if ($Tab.ConsolePane.CaretLineText.StartsWith("[$TabName]: PS")) {$Tab.Invoke( {Clear-Host})}
        }
    }

    End
    {
        if ($PSBoundParameters['PassThru'])
        {$RemoteTabsList}
    }
}

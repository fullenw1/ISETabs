# ISETabs

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

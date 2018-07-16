# ISETabs

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

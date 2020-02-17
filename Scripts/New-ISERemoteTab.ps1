function New-ISERemoteTab {
    <#
    .SYNOPSIS
    Create ISE tabs with a PSSession to a remote computer.

    .DESCRIPTION
    Create ISE tabs with a PSSession to a remote computer.

    .PARAMETER ComputerName
    Computer name for the tab name and PSSession.

    .EXAMPLE
    'Comp1','Comp2' | New-ISERemoteTab

    .EXAMPLE
    $ISETabs = New-ISERemoteTab -ComputerName 'Comp1','Comp2'

    In this example, you create two ISE tabs with a remote PSSession and assign the tab object to $ISETabs.
    Then you invoke the same command-line to all selected tabs.
    #>

    [Alias('nirt')]

    [CmdletBinding(DefaultParameterSetName = 'All')]

    [OutputType('Microsoft.PowerShell.Host.ISE.PowerShellTab')]

    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 1
        )]
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'UserName')]
        [ValidateNotNullOrEmpty()]
        [string]$UserName,

        [Parameter(ParameterSetName = 'Credential')]
        [ValidateNotNullOrEmpty()]
        [string]$Credential,

        [ValidateNotNullOrEmpty()]
        [switch]$DoNotConnect,

        [switch]$PassThru
    )

    Begin {
        if (-not($psISE))
        { Throw 'This cmdlet must be run from inside an ISE console.' }

        If ($PSBoundParameters['Credential']) {

            #$CredentialPath = Join-Path -Path $env:TEMP -ChildPath 'Cred.xml'
            $CredentialPath = [System.IO.Path]::GetTempFileName()

            $Credential | Export-Clixml -Path $CredentialPath
        }

        $RemoteTabsList = [System.Collections.Generic.List[Microsoft.PowerShell.Host.ISE.PowerShellTab]]::new($ComputerName.Count)
    }

    Process {
        foreach ($Computer in $ComputerName) {
            Write-Verbose -Message "Creating new remote tab for $Computer..."
            $ISETab = $psISE.PowerShellTabs.Add()

            $RemoteTabsList.Add($ISETab)

            $ISETab.Displayname = $Computer

            while (!($ISETab.CanInvoke)) { Start-Sleep -Milliseconds 500 }

            if (-Not($PSBoundParameters['DoNotConnect'])) {
                if ($PSBoundParameters['UserName']) {
                    $ScriptBlock = [scriptblock]::Create("Enter-PSSession -ComputerName $Computer -Credential $UserName")
                }
                elseif ($PSBoundParameters['Credential']) {
                    $ScriptBlock = & {
                        $Cred = Import-Clixml -Path $CredentialPath
                        $Comp = $Computer
                        { Enter-PSSession -ComputerName $Comp -Credential $Cred }.GetNewClosure() }
                }
                else {
                    $ScriptBlock = [scriptblock]::Create("Enter-PSSession -ComputerName $Computer")
                }

                $ISETab.Invoke($ScriptBlock)
            }
        }

        if (-Not($PSBoundParameters['DoNotConnect'])) {
            foreach ($Tab in $RemoteTabsList) {

                $TabName = $Tab.Displayname

                Write-Verbose -Message "Checking PSSession for $TabName..."
                while (!($Tab.CanInvoke)) { Start-Sleep -Milliseconds 500 }

                if ($Tab.ConsolePane.CaretLineText.StartsWith("[$TabName]: PS")) { $Tab.Invoke( { Clear-Host }) }
            }
        }
    }

    End {
        if ($PSBoundParameters['Credential']) {
            Remove-Item -Path $CredentialPath
        }

        $RemoteTabsList
    }
}

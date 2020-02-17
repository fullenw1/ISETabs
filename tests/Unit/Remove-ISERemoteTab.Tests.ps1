$ScriptName = $MyInvocation.MyCommand.Name -replace '\.Tests\.', '.'
$ScriptPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Scripts'
$Script = Join-Path $ScriptPath -ChildPath $ScriptName
. $Script

Describe "Parameters" {

}

Describe "Functional tests" {

}

using module ..\Classes\CBEPAPIComputerClass.psm1

function Get-Computer {
    Param(
        [Parameter(
            Position=0,
            ParameterSetName='computerName',
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [string[]]$computerName,
        [Parameter(
            Position=0,
            ParameterSetName='computerId',
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [string[]]$computerId,
        [Parameter(
            Mandatory=$true
        )]
        [system.object]$session
    )

    $Computer = [CBEPComputer]::new()

    $Computer.Get($computerName, $computerId, $Session)

    Write-Output $Computer.computer
}
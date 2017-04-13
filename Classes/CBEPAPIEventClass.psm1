#requires -version 5.0

<#
    CB PowerShell Toolkit v2.0
    Copyright (C) 2017 Thomas Brackin

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction,
    including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
    and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

class CBEPEvent{
    [system.object]$event

    [void] Get ([string]$maxAge, [string]$subtypeId, [string]$computerId, [string]$policyId, [string]$fileCatalogId, [system.object]$session){
        $this.event = $null

        If (!$maxAge){
            return
        }
        Else{
            $timeStamp = ((([DateTime]::UtcNow).AddMinutes(-$maxAge)).ToString('yyyy-MM-ddTH:mm:ssZ')) 
        }
        # Get the amount of events
        $urlQueryPart = "/event?q=timeStamp>" + $timeStamp + "&q=limit:-1"
        $tempEvent = $session.get($urlQueryPart)

        If ($tempEvent.count){
            $count = $tempEvent.count
            $j = 0

            # Get the first 1000 events
            $urlQueryPart = "/event?q=timeStamp>" + $timeStamp
            If ($subtypeId){
                $urlQueryPart += ("&q=subType:" + $subtypeId)
            }
            If ($computerId){
                $urlQueryPart += ("&q=computerId:" + $computerId)
            }
            If ($policyId){
                $urlQueryPart += "&q=policyId:" + $policyId
            }
            If ($fileCatalogId){
                $urlQueryPart += "&q=fileCatalogId:" + $fileCatalogId
            }
            $urlQueryPart += "&offset=" + $j

            $tempEvent = $session.get($urlQueryPart)

            If ($tempEvent.id){
                $this.event = $tempEvent
            }
            ElseIf ($tempEvent.Message){
                Write-Error -Message ($tempEvent.Query + " : " + $tempEvent.Message + " : " + $tempEvent.HttpStatus + " : " + $tempEvent.HttpDescription)
            }

            # Get the rest of the events
            If ($count -gt 1000){
                Do{
                    $j += 1000

                    $urlQueryPart = "/event?q=timeStamp>" + $timeStamp
                    If ($subtypeId){
                        $urlQueryPart += ("&q=subType:" + $subtypeId)
                    }
                    If ($computerId){
                        $urlQueryPart += ("&q=computerId:" + $computerId)
                    }
                    If ($policyId){
                        $urlQueryPart += "&q=policyId:" + $policyId
                    }
                    If ($fileCatalogId){
                        $urlQueryPart += "&q=fileCatalogId:" + $fileCatalogId
                    }
                    $urlQueryPart += "&offset=" + $j

                    $tempEvent = $session.get($urlQueryPart)
                    If ($tempEvent.id){
                        $this.event += $tempEvent
                    }
                    ElseIf ($tempEvent.Message){
                        Write-Error -Message ($tempEvent.Query + " : " + $tempEvent.Message + " : " + $tempEvent.HttpStatus + " : " + $tempEvent.HttpDescription)
                    }
                } While ($j -lt $count)
            }
        }
        ElseIf ($tempEvent.Message){
            Write-Error -Message ($tempEvent.Query + " : " + $tempEvent.Message + " : " + $tempEvent.HttpStatus + " : " + $tempEvent.HttpDescription)
        }
    }
}
# CB Protection API Toolkit for PowerShell
This toolkit was written specifically for PowerShell 5.1. As such, it uses code that is NOT compatible with anything below 5.0.

If you are trying to use this with Task Scheduler on Windows Server 2012R2, you MUST install this KB patch so that the API key can be stored and read securely in the running user's temp folder: KB3133689

## How to use
Import these modules with the new import method introduced in PowerShell 5.0
```
using module .\CBEPAPI****.psm1
```

To create a new object from the class definitions use the method introduced in PowerShell 5.0
```
$object = [CBEP****]::new()
```

To use methods of classes, simply reference them in 'dot' notation. Methods that will return data for consumption will be typecast as something OTHER than [void] in the class definitions.
```
$object.GetSomethingCool('variable1','variable2','variable3)
```


## Future implements
- [x] File analysis class
- [ ] Create VirusTotal script for performing analysis and making decisions based on the results.

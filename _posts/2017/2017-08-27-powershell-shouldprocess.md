---
title: 'How to Use ShouldProcess in #PowerShell Functions'
date: 2017-08-27T19:21:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/08/27/how-to-use-shouldprocess-in-powershell-functions/
categories:
  - Haufe-Lexware
tags:
- PowerShell
---
When writing advanced functions in PowerShell, ShouldProcess enables a script to ask for confirmation and react to different settings of `$ConfirmPreference`. Unfortunately, the use of ShouldProcess is still somewhat obsure. Therefore, I have created template for this and added unit tests to proove it works correctly.<!--more-->

# Using ShouldProcess

An advanced function is created by adding `[CmdletBinding()]` to the top of the function. ShouldProcess is enabled by adding a parameter:

```powershell
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param()

    # Code
}
```

By adding `ConfirmImpact`, you can specify when a function asks for confirmation. When using verbs like `New` or `Remove`, the [PowerShell script analyzer](https://www.powershellgallery.com/packages/PSScriptAnalyzer/) forces you to add the expected impact on the environment to your function. Based on this impact definition and the setting of `$ConfirmPreference`, PowerShell will decide whether to ask for confirmation. Whenever the impact is higher than the `$ConfirmPreference`, a confirmation is required.

The function will most certainly not contain critical code exclusively. Usually functions with an impact require some preparation and cleaning up afterwards. You can easily wrap the critical code to make sure that the confirmation is only required to execute the wrapped code. The critical code should only be called if some preparation fails. You do not want to ask for confirmation without requiring it. The method `$PSCmdlet.ShouldProcess()` takes care of this:

```powershell
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param()

    # Preparation

    if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
        # Critical code
    }

    # Cleanup
}
```

The [`ShouldProcess` method has multiple overloads](https://msdn.microsoft.com/en-us/library/system.management.automation.cmdlet.shouldprocess(v=vs.85).aspx) to cover different several use cases regarding messaging towards to end-user.

The above example will already work for the following scenarios:

- Using different values for `ConfirmImpact` and `$ConfirmPreference`
- Using `$WhatIfPreference`
- Using the parameter `-WhatIf` to test the outcome
- Using the parameter `-Confirm` to confirm non-interactively

When such a function is used as part of a library or module, it is seldomly called directly but it part of a much larger call stack. If `Test-ShouldProcess` is called from a function which is called with `-WhatIf` it is highly desirable to honour this further down in the call stack. This requires reading the state of variables like `$WhatIfPreference` and `$ConfirmPreference` from the session instead of simply relying on the parameters passed to `Test-ShouldProcess`:

```powershell
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param()

    Begin {
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }

    Process {
        # Preparation

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            # Critical code
        }

        # Cleanup
    }
}
```

Of course, the same works for honouring `$VerbosePreference`.

# Code

The full example can be viewed, copied and reused:

<script src="https://gist.github.com/nicholasdille/525a8e3bc714fd2d2cf85bb86517cd1f.js"></script>
# HelloID-Task-SA-Target-ActiveDirectory-AccountDisable
#######################################################
# Form mapping
$formObject = @{
    UserPrincipalName     = $form.UserPrincipalName
}

try {
    Write-Information "Executing ActiveDirectory action: [DisableAccount] for: $($formObject.UserPrincipalName)]"

    Import-Module ActiveDirectory -ErrorAction Stop
    $user = Get-ADUser -Filter "userPrincipalName -eq '$($formObject.UserPrincipalName)'"
    if ($user) {
        $null = Disable-ADAccount -Identity  $user.SID.value
        $auditLog = @{
            Action            = 'DisableAccount'
            System            = 'ActiveDirectory'
            TargetIdentifier  =  "$($user.SID.value)"
            TargetDisplayName = "$($formObject.UserPrincipalName)"
            Message           = "ActiveDirectory action: [DisableAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [DisableAccount] for: [$($formObject.DisplayName)] executed successfully"
    } elseif (-not($user)) {
        $auditLog = @{
            Action            = 'DisableAccount'
            System            = 'ActiveDirectory'
            TargetIdentifier  = ""
            TargetDisplayName = "$($formObject.UserPrincipalName)"
            Message           = "ActiveDirectory action: [DisableAccount] for: [$($formObject.UserPrincipalName)] cannot execute. The account cannot be found in the AD. possibly already deleted"
            IsError           = $true
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [DisableAccount] for: [$($formObject.UserPrincipalName)] cannot execute. The account cannot be found in the AD. possibly already deleted"
    }
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'DisableAccount'
        System            = 'ActiveDirectory'
        TargetIdentifier  = '' # optional (free format text)
        TargetDisplayName = "$($formObject.UserPrincipalName)"
        Message           = "Could not execute ActiveDirectory action: [DisableAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute ActiveDirectory action: [DisableAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
}
#######################################################

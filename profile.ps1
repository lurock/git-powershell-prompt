. (Resolve-Path "$env:LOCALAPPDATA\GitHub\shell.ps1")

$Global:CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$UserType = "User"
$CurrentUser.Groups | foreach { if($_.value -eq "S-1-5-32-544") {$UserType = "Admin"} }
 
function prompt {
  if($UserType -eq "Admin") {
    $host.ui.rawui.WindowTitle = "" + $(get-location) + " : Admin"
  }
  else {
    $host.ui.rawui.WindowTitle = $(get-location)
  }
  
   Write-Host("")
      
   $symbolicref = git symbolic-ref HEAD
   if($symbolicref -ne $NULL) {
      $branch_name = ""
      git branch | foreach {
        if ($_ -match "^\*(.*)"){
          $branch_name = $matches[1]
        }
      }
      
      $git_create_count = 0
      $git_update_count = 0
      $git_delete_count = 0
      
      git status | foreach {
        if($_ -match "modified:"){ 
        $git_update_count += 1
      }
      elseif($_ -match "deleted:"){ 
        $git_delete_count += 1
      }
      elseif($_ -match "new file:"){ 
        $git_create_count += 1
      }
    }
    $status_string = " [a:" + $git_create_count + " u:" + $git_update_count + " d:" + $git_delete_count + "]"
    $host.ui.rawui.WindowTitle += " [" + $branch_name.trim() + "]" + "  added: " + $git_create_count + "  updated: " + $git_update_count + "  deleted: " + $git_delete_count
  }
  else{
    $status_string = ""
  }
 
  Write-Host (" PS " + $(get-location)) -nonewline
  Write-Host ($status_string) -nonewline -foregroundcolor Cyan
  Write-Host (">") -nonewline
  return " "
}
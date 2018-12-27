# Script  to pull the Local administrator group list from the remote computers
# Input file should contain the server / workstation names one on each line.
# Example: .\Ladmin_Listing_Latest.ps1 -inputfile ".\serversList.txt"
# Make sure that you have the serverslist.txt file exist in the same folder where the script exist, otherwise, you need to provide
# the full path of the input file. 
# Author : Murugan Natarajan
# Email  : murugan.natarajan@outlook.com
# Script created date: 8/3/2018
# Script provided without any warranty, please use it with your own risk.


param(
[Parameter(Mandatory=$True)]
[String]$Inputfile='.\ServersList.txt'
)

$logdate = (Get-Date -Format ddMMyyyy-hh-mm)
$FinalLog= ".\$($logdate)_LocalAdmin_List.csv"

Foreach ( $SName in (Get-Content $inputfile) ) {

        $Message= " " # Adding empty line for each item processing
        $Message | Out-File $FinalLog -Append
        
        If (Test-Connection $SName -Count 1 -Quiet -ErrorAction SilentlyContinue) {


$group = [ADSI]("WinNT://$SName/Administrators,group")  
$GMembers = $group.psbase.invoke("Members")
$Liste=$GMembers | ForEach-Object {$_.GetType().InvokeMember("ADspath",'GetProperty', $null, $_, $null) -replace ('WinNT://DOMAIN/' + $Sname + '/'), '' -replace ('WinNT://DOMAIN/', 'DOMAIN\') -replace ('WinNT://', '') }# | Out-File $FinalLog -append

#

foreach ( $object in $Liste ){

$Message="$sname,$object"
$message | Out-File $FinalLog -Append

}
}
    else{

        $Message="$SName,Problematic server"
        $message | Out-File $FinalLog -Append
    }

}

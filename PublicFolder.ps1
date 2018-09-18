

function DirectoryChain {
    param (
        $width = 3
    )

    #Add an extra timestamp - pointless as script takes less than a second to run.
    $dirModifiers += "_$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    
    #Create the requested number of folders
    for ($i = 0; $i -lt $width; $i++) {

        #randomly draw from the directory and modifier pools
        $Directory = $dirNames[$(Get-Random -Minimum 0 -Maximum $dirNames.Length)]
        $Modifier =  $dirModifiers[$(Get-Random -Minimum 0 -Maximum $dirModifiers.Length)]

        #concatenate the random draws to create a folder name
        $dir = "$Directory$Modifier"

        #check the folder doesn't already exist
        if(!(Test-Path $dir))
        {
            #if it doesn't exist, create it!
            New-Item -ItemType Directory $dir | Out-Null
        }

        #Pull another random number between <minimum> and <maximum>
        $doBranch = Get-Random -Minimum 0 -Maximum 2

        #if the number 0 was picked, recurse!
        #That is go into the last folder that was made and make some new folders 
        if ($doBranch -eq 0) {
            #Go into the new folder, and remember what folder we were just in
            Push-Location $dir
            #Create some new sub folders
            DirectoryChain -width $(Get-Random -Minimum 1 -Maximum 6)
            #Go back to where we were originally
            Pop-Location
        }

        #Pull another random number
        $createFile = Get-Random -Minimum 0 -Maximum 3

        #if the number 0 was picked, we'll create a new file
        if ($createFile -eq 0) {

            #pull a random side, modifier and file extension from the respective pools
            $Site = $dirSite[$(Get-Random -Minimum 0 -Maximum $dirSite.Length)]
            $fModifier = $dirModifiers[$(Get-Random -Minimum 0 -Maximum $dirModifiers.Length)]
            $extension = $dirExtension[$(Get-Random -Minimum 0 -Maximum $dirExtension.Length)]

            #concatenate to create the filename
            $filename = "$site$fModifier$extension"

            #Create that file!
            New-Item -ItemType File $filename | Out-Null
        }
    }
}

#requires -Version 5

#start at the folder where the script is stored
Set-Location $PSScriptRoot

#directory name pool
$dirNames = @(
    "Corporate-Storage"
    "Public"
    "TroyH"
    "AaronP"
    "JesseF"
    "Dynacorp"
    "Vitamax"
    "SynterNIX"
)

#modifier pool. Add a couple 'blank' entries to increase the odds of 
#  getting 'no' modifier
$dirModifiers = @(
    ""
    ""
    ""
    ""
    "_Bak"
    "_Backup"
    "_Old"
    "_New"
    "_Prod"
    "_$(Get-Date -Format 'yyyyMMdd-HHmmss')"
)

#site pool
$dirSite = @(
    "Metro"
    "Adelaide"
    "Production"
    "WaggaWagga"
    "Customer"
    "Darlington"
    "Downs"
)

#extension pool
$dirExtension = @(
    ".rsz"
    ".gel"
    ".fed"
    ".plc"
)

#Start the magic!
DirectoryChain -width 4

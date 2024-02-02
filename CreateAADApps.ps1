# Install-Module AzureAD -Force
Import-Module AzureAD
Connect-AzureAD

# Set your FQDN here
$yourFQDN = "yourdomain.com"

# Arrays of adjectives and nouns (80 each)
$adjectives = @("swift", "silent", "frozen", "mystic", "ancient", "twilight", "dawn", "crescent", "fallen", "forgotten", "gentle", "hidden", "jolly", "kind", "luminous", "mysterious", "noble", "old", "proud", "quiet", "restless", "sacred", "tame", "unseen", "vivid", "wild", "xenial", "young", "zealous", "abundant", "brave", "clever", "daring", "elegant", "fancy", "graceful", "hopeful", "intrepid", "joyful", "keen", "lively", "magical", "nimble", "optimistic", "peaceful", "quaint", "radiant", "serene", "tranquil", "upbeat", "vibrant", "whimsical", "youthful", "zestful", "amazing", "blissful", "charming", "delightful", "enchanted", "fantastic", "glorious", "harmonious", "inspired", "jubilant", "knightly", "legendary", "marvelous", "notable", "outstanding", "picturesque", "quixotic", "remarkable", "stunning", "terrific", "unique", "valiant", "wonderful", "exquisite", "yearning", "zany")
$nouns = @("wolf", "forest", "river", "mountain", "sky", "ocean", "star", "tree", "moon", "phoenix", "dragon", "flame", "horizon", "journey", "knight", "legacy", "miracle", "nexus", "oracle", "pilgrim", "quest", "relic", "sage", "talisman", "unicorn", "voyager", "wizard", "xenolith", "yeti", "zeppelin", "archer", "breeze", "crystal", "dewdrop", "emerald", "falcon", "glacier", "harbor", "iris", "jewel", "kaleidoscope", "lotus", "meadow", "nebula", "oasis", "paladin", "quartz", "rainbow", "sparrow", "tiger", "urchin", "vortex", "willow", "xanadu", "yellowtail", "zebra", "asteroid", "butterfly", "canyon", "dandelion", "eagle", "firefly", "gazelle", "hedgehog", "island", "jaguar", "koala", "lemur", "mongoose", "narwhal", "octopus", "panda", "quail", "raccoon", "salamander", "toucan", "urchin", "viper", "walrus", "xiphos", "yak", "zebu")

# Initialize an array to keep track of used names
$usedNames = @()

# Determine the log file path based on the script's location and name
$scriptPath = $MyInvocation.MyCommand.Path
$logFilePath = $scriptPath -replace '\.ps1$', '.log'

Write-Host "Script started. Logging to $logFilePath"

for ($i = 0; $i -lt 2000; $i++) {
    do {
        # Select random adjective and noun
        $randomAdjective = Get-Random -InputObject $adjectives
        $randomNoun = Get-Random -InputObject $nouns

        # Combine to form a name
        $randomName = "$randomAdjective-$randomNoun"
    }
    while ($usedNames -contains $randomName)

    # Add the name to the list of used names
    $usedNames += $randomName

    # Define start and end date range for expiration
    $startDate = Get-Date
    $earliestEndDate = Get-Date -Year 2024 -Month 2 -Day 17
    $latestEndDate = Get-Date -Year 2026 -Month 1 -Day 17

    # Calculate the range of days for random expiration
    $daysRange = (New-TimeSpan -Start $earliestEndDate -End $latestEndDate).Days

    # Generate a random number of days to add to the earliest end date
    $randomDaysToAdd = Get-Random -Minimum 0 -Maximum $daysRange

    # Calculate the random end date
    $endDate = $earliestEndDate.AddDays($randomDaysToAdd)

    Write-Host "Creating App Registration: $randomName"
    # Create the Azure AD App Registration
    $app = New-AzureADApplication -DisplayName $randomName

    # Add a client secret
    $secret = New-AzureADApplicationPasswordCredential -ObjectId $app.ObjectId -StartDate $startDate -EndDate $endDate

    # Construct the redirect URI
    $redirectUri = "http://$yourFQDN/$randomName"

    # Update the app registration with the redirect URI
    Set-AzureADApplication -ObjectId $app.ObjectId -ReplyUrls $redirectUri

    Write-Host "App Registration created: $randomName with Redirect URI: $redirectUri"

    # Write to log file
    $logEntry = "Time: $(Get-Date) - App Registration: $randomName - Redirect URI: $redirectUri"
    Add-Content -Path $logFilePath -Value $logEntry
}

Write-Host "Script completed."

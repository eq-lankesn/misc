Clear-Host

$baseUrl = "https://gitlab.com/api/v4/projects"
Write-Host("Gitlab info for $baseUrl")
$accessToken = "private_token=ReplaceMe"
$url = "$($baseUrl)?owned=true&$($accessToken)"
Write-Host("Getting data from $url")
$response = curl $url

$json = $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 100
Write-Host($json)

$json = $response.Content | ConvertFrom-Json 

Write-Host("------------------------")

$gitlabProjects = @()

foreach ($item in $json) {    
    $properties = [ordered]@{ Id = $item.id
        Name = $item.name
        NamespacedName = $item.name_with_namespace
        Path = $item.path
        NamespacedPath = $item.path_with_namespace
        RepositoryUrl = $item.http_url_to_repo
        BranchesUrl = $item._links.repo_branches
        BranchNames = @()
    }

    $gitlabProject = New-Object -TypeName psobject -Property $properties
    
    $branchesUrl = "$($gitlabProject.BranchesUrl)?$($accessToken)"
    $response = curl $branchesUrl 
    $json = $response.Content | ConvertFrom-Json

    foreach ($branch in $json) {
        $gitlabProject.BranchNames += $branch.name        
    }

    $gitlabProjects += $gitlabProject
}

($gitlabProjects | ConvertTo-Xml -NoTypeInformation).Save("C:\Temp\test.xml")
$gitlabProjects | Select NamespacedName, RepositoryUrl, @{N='Branches';Expression={ $_.BranchNames}} | Export-Csv -NoTypeInformation "C:\Temp\test.csv" 
$baseUrl = "https://gitlab.com/api/v4/projects"

$projectId = "convexarc/my-simple-pipeline"
$projectIdEncoded = [System.Web.HttpUtility]::UrlEncode($projectId)
$accessToken = "private_token=ReplaceMe"
$url = "$($baseUrl)/$projectIdEncoded/merge_requests?$($accessToken)"

$postParams = @{
    id = $projectIdEncoded;
    source_branch = 'develop-branched';
    target_branch = 'develop';
    title = "Test title2"
}

$result = Invoke-WebRequest -Uri $url -Method Post -Body $postParams
$result

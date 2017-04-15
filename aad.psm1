function Get-AadAccessToken ($ClientID, $ClientSecret, $TenantID, $Resource) {
    $uri = "https://login.microsoftonline.com/$TenantID/oauth2/token"
    $headers = @{ Accepts="application/json" }
    $body = @{
        grant_type="client_credentials"; 
        client_id=$ClientID;
        client_secret=$ClientSecret;
        resource=$Resource;
    }    

    $token = Invoke-RestMethod -Uri $uri -Body $body -ContentType "application/x-www-form-urlencoded" -Method Post -Headers $headers
    return $token
}

function Invoke-AadWebRequest ($Url, $Authorization, $Method="Get", $Body=$null) {
    $headers = @{ 
        Accepts="application/json";
        Authorization="Bearer $($Authorization.access_token)";
    }

    return Invoke-RestMethod -Uri $url -Method $Method -Headers $headers -Body $body
}
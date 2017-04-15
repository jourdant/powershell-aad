##

Class AadAccessToken {
    [datetime]$Expiry
    [string]$Resource
    [string]$TokenType
    [string]$Value
}

function Get-AadAccessToken (
    [Parameter(Mandatory=$true)][string]$ClientId, 
    [Parameter(Mandatory=$true)][string]$ClientSecret, 
    [Parameter(Mandatory=$true)][string]$TenantId, 
    [Parameter(Mandatory=$true)][string]$Resource) {
    
    $uri = "https://login.microsoftonline.com/$TenantID/oauth2/token"
    $headers = @{ Accepts="application/json" }
    $body = @{
        grant_type="client_credentials"; 
        client_id=$ClientID;
        client_secret=$ClientSecret;
        resource=$Resource;
    }    

    $token = Invoke-RestMethod -Uri $uri -Body $body -ContentType "application/x-www-form-urlencoded" -Method Post -Headers $headers
    if ($token.access_token -eq $null) { throw "Could not retrieve bearer token with provided details." }

    $ret = New-Object AadAccessToken -Prop @{
        Expiry=([datetime]"1970-01-01 00:00:00").AddSeconds($token.expires_on);
        Resource=$token.resource;
        TokenType=$token.token_type;
        Value=$token.access_token;
    }

    return $ret
}

function Invoke-AadWebRequest (
    [Parameter(Mandatory=$true)][string]$Url, 
    [Parameter(Mandatory=$true)][AadAccessToken]$AadAccessToken, 
    [Parameter(Mandatory=$false)][string]$Method="Get", 
    [Parameter(Mandatory=$false)][string]$Body=$null) {

    $headers = @{ 
        Accepts="application/json";
        Authorization="Bearer $($Authorization.value)";
    }

    return Invoke-RestMethod -Uri $url -Method $Method -Headers $headers -Body $body
}
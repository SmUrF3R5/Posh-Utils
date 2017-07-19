function Decodde-Base64($string)
{   
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($string))
}

function Encode-Base64($String)
{
    [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($string))
} 

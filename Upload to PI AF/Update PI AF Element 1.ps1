param($PIAFPath,$DisplayImagePath,$Enviar)

#$DisplayImagePath = "C:\Power Automate Desktop Flows\Screenshot 1 Despliegue\Capturas\HIDRO-PTL-Infodia_v2_20240814_151357.png"
#$PIAFPath = "\\STAPITEST\Test_01\Power Automate Screenshots\PTL"
#$Enviar = "1"

If (!$PIAFPath.Equals("") -and !$DisplayImagePath.Equals("") -and !$Enviar.Equals("")){
    If ([System.IO.File]::Exists($DisplayImagePath)){
        try{

            $PIAFPathArray = $PIAFPath -split '\\'

            $AFServerName = ($PIAFPath -split '\\')[2]
            $AFDatabaseName = ($PIAFPath -split '\\')[3]
            $AttributeName_Despliegue = "Despliegue1"
            $AttributeName_Enviar = "Enviar"

            $AFServer = Get-AFServer $AFServerName
            $AFConnection = Disconnect-AFServer -AFServer $AFServer
            $AFConnection = Connect-AFServer -AFServer $AFServer
            $AFDatabase = Get-AFDatabase -AFServer $AFConnection -Name $AFDatabaseName

            $indice = 0
            forEach($ElementName in $PIAFPathArray){
                $indice = $indice+1
                If ($indice -gt 4){
                    If ($indice -eq 5){
                        $AFElement = Get-AFElement -AFDatabase $AFDatabase -Name $ElementName
                    }else{
                        $AFElement = Get-AFElement -AFElement $AFElement -Name $ElementName
                    }
                }
            }

            $ChildAttribute_Despliegue = Get-AFAttribute -AFElement $AFElement -Name $AttributeName_Despliegue
            $ChildAttribute_Enviar = Get-AFAttribute -AFElement $AFElement -Name $AttributeName_Enviar

            $image = New-Object OSIsoft.AF.Asset.AFFile
            $image.upload($DisplayImagePath)
            $ChildAttribute_Despliegue.SetValue($image)

            If ($Enviar.Equals("1")){
                $ChildAttribute_Enviar.SetValue(1)
                Start-Sleep 10
                $ChildAttribute_Enviar.SetValue(0)
            }else{
                $ChildAttribute_Enviar.SetValue(-1)
                Start-Sleep 10
                $ChildAttribute_Enviar.SetValue(0)
            }
            $AFConnection = Disconnect-AFServer -AFServer $AFServer
        }
        catch {Write-Host "Error: $_."}
    }else{
        Write-Host "Error"
    }
}else{
    Console.Write-Host "Error"
}



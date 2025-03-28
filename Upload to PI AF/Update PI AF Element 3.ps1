param($PIAFPath,$DisplayImagePath1,$DisplayImagePath2,$DisplayImagePath3,$Enviar)

#$DisplayImagePath1 = "C:\Power Automate Desktop Flows\Screenshot 002\Capturas\MolymetNos-Reporte-SO2_20240813184151.png"
#$DisplayImagePath2 = "C:\Power Automate Desktop Flows\Screenshot 002\Capturas\MolymetNos-Tendencias-SO2_20240813184151.png"
#$PIAFPath = "\\STAPITEST\Test_01\Power Automate Screenshots\Emisiones SO2"
#$Enviar = "1"

If (!$PIAFPath.Equals("") -and !$DisplayImagePath1.Equals("") -and !$DisplayImagePath2.Equals("") -and !$Enviar.Equals("")){
    If ([System.IO.File]::Exists($DisplayImagePath1) -and [System.IO.File]::Exists($DisplayImagePath2)){
        try{

            $PIAFPathArray = $PIAFPath -split '\\'

            $AFServerName = ($PIAFPath -split '\\')[2]
            $AFDatabaseName = ($PIAFPath -split '\\')[3]
            $AttributeName_Despliegue1 = "Despliegue1"
            $AttributeName_Despliegue2 = "Despliegue2"
            $AttributeName_Despliegue3 = "Despliegue3"
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

            $ChildAttribute_Despliegue1 = Get-AFAttribute -AFElement $AFElement -Name $AttributeName_Despliegue1
            $ChildAttribute_Despliegue2 = Get-AFAttribute -AFElement $AFElement -Name $AttributeName_Despliegue2
            $ChildAttribute_Despliegue3 = Get-AFAttribute -AFElement $AFElement -Name $AttributeName_Despliegue3
            $ChildAttribute_Enviar = Get-AFAttribute -AFElement $AFElement -Name $AttributeName_Enviar

            $image1 = New-Object OSIsoft.AF.Asset.AFFile
            $image1.upload($DisplayImagePath1)
            $ChildAttribute_Despliegue1.SetValue($image1)
            $image2 = New-Object OSIsoft.AF.Asset.AFFile
            $image2.upload($DisplayImagePath2)
            $ChildAttribute_Despliegue2.SetValue($image2)
            $image3 = New-Object OSIsoft.AF.Asset.AFFile
            $image3.upload($DisplayImagePath3)
            $ChildAttribute_Despliegue3.SetValue($image3)

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



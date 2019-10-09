$HeightLocation=0
#Parametres de fenetre
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='PUFFYsearcher - Windows files search'
$main_form.Width = 800
$main_form.Height = 500
#$main_form.FormBorderStyle = 'Fixed3D'
#$main_form.AutoSize = $true
$img = [System.Drawing.Image]::Fromfile('logosized.png')
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width = 166
$pictureBox.Height = 60
$pictureBox.Image = $img
$main_form.controls.add($pictureBox)

#label titre de repertoire
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Repertoire racine de recherche:"
$Label.Location  = New-Object System.Drawing.Point(170,($HeightLocation + 10))
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

#label afficher repertoire
$path = Get-Location
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = $path
$Label3.Location  = New-Object System.Drawing.Point(360,($HeightLocation + 10))
$Label3.AutoSize = $true
$main_form.Controls.Add($Label3)

#label Changer repertoire
$Folderlist = New-Object System.Windows.Forms.Label
$Folderlist.Text = "changer de repertoire:"
$Folderlist.Location  = New-Object System.Drawing.Point(170,($HeightLocation + 35))
$Folderlist.AutoSize = $true
$main_form.Controls.Add($Folderlist)

#Création d'un bouton parcourir (Button + OpenFolderDialog).
$bouton1 = New-Object Windows.Forms.Button
$bouton1.Location = New-Object System.Drawing.Point(360,($HeightLocation + 30))
$bouton1.Size = New-Object System.Drawing.Point(100,20)
$bouton1.text = "Parcourir"
$bouton1.add_click({
	#Création d'un objet "ouverture de fichier".
	$ouvrir1 = New-Object System.Windows.Forms.FolderBrowserDialog
	#Affiche la fenêtre d'ouverture de fichier.
	$retour1 = $ouvrir1.ShowDialog()
	$Label3.Text = $ouvrir1.SelectedPath
	$global:path = $ouvrir1.SelectedPath
})
#Attache le contrôle à la fenêtre.
$main_form.controls.add($bouton1)#Affiche le tout.


#boite de texte
$textBox1 = new-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Size(10,($HeightLocation + 60))
$textBox1.Size = New-Object System.Drawing.Size(565,20)
$main_form.Controls.Add($textBox1)


#label bouton rechercher
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(575,($HeightLocation + 60))
$Button.Size = New-Object System.Drawing.Size(100,20)
$Button.Text = "Rechercher"
$main_form.Controls.Add($Button)

#height asjustment
$HeightLocation += 20

#Advanced search
$AdvancedLabel = New-Object System.Windows.Forms.Label
$AdvancedLabel.Text = "[OPTIONS AVANCEES]:"
$AdvancedLabel.Location  = New-Object System.Drawing.Point(10,($HeightLocation + 70))
#$AdvancedLabel.Size  = New-Object System.Drawing.Point(100,15)
$AdvancedLabel.AutoSize = $True
$main_form.Controls.Add($AdvancedLabel)

#radio - names or content
$GroupFilter1 = New-Object System.Windows.Forms.Panel
$GroupFilter1.Location = New-Object System.Drawing.Point(150,($HeightLocation + 70))
$GroupFilter1.Size = New-Object System.Drawing.Point(400,20)
#$GroupFilter1.AutoSize = $True
    
# Create the collection of radio buttons
$RadioButton1 = New-Object System.Windows.Forms.RadioButton
$RadioButton1.Location = New-Object System.Drawing.Point(0,0)
$RadioButton1.Checked = $true 
$RadioButton1.AutoSize = $True
$RadioButton1.Text = "Noms des fichiers"
$GroupFilter1.Controls.Add($RadioButton1)

$RadioButton2 = New-Object System.Windows.Forms.RadioButton
$RadioButton2.Location = New-Object System.Drawing.Point(150,0)
$RadioButton2.Checked = $false
$RadioButton2.AutoSize = $True
$RadioButton2.Text = "Contenus des fichiers"
$GroupFilter1.Controls.Add($RadioButton2)

$main_form.Controls.Add($GroupFilter1)

#height asjustment
$HeightLocation += 20

#radio - exact match or one of words
$GroupFilter2 = New-Object System.Windows.Forms.Panel
$GroupFilter2.Location = New-Object System.Drawing.Point(150,($HeightLocation + 70))
$GroupFilter2.Size = New-Object System.Drawing.Point(400,20)
#$GroupFilter1.AutoSize = $True
    
# Create the collection of radio buttons
$RadioButton3 = New-Object System.Windows.Forms.RadioButton
$RadioButton3.Location = New-Object System.Drawing.Point(0,0)
$RadioButton3.Checked = $true 
$RadioButton3.AutoSize = $True
$RadioButton3.Text = "Le texte entier"
$GroupFilter2.Controls.Add($RadioButton3)

$RadioButton4 = New-Object System.Windows.Forms.RadioButton
$RadioButton4.Location = New-Object System.Drawing.Point(150,0)
$RadioButton4.Checked = $false
$RadioButton4.AutoSize = $True
$RadioButton4.Text = "L'un des mots"
$GroupFilter2.Controls.Add($RadioButton4)

$main_form.Controls.Add($GroupFilter1)
$main_form.Controls.Add($GroupFilter2)

#label progression:
$Progress = New-Object System.Windows.Forms.Label
$Progress.Text = "..."
$Progress.Location  = New-Object System.Drawing.Point(600,($HeightLocation + 60))
$Progress.AutoSize = $true
$main_form.Controls.Add($Progress)

#label resultat recherche
$SearchRes = New-Object System.Windows.Forms.Label
$SearchRes.Text = "Cliquer sur Parcourir pour selectionner un dossier" + "`n" + "puis cliquer sur le bouton Rechercher"
$SearchRes.Location  = New-Object System.Drawing.Point(10,($HeightLocation + 90))
$SearchRes.Size  = New-Object System.Drawing.Point(300,40)
$main_form.Controls.Add($SearchRes)

$HeightLocation -= 40 

#evenement boutton rechercher
$Button.Add_Click({ 
	#clear result buffer
	$removelist = $main_form.Controls | Where-Object {$_.Name -like "templink*"}
	ForEach($item in $removelist)
	{
		$main_form.Controls.Remove($item)
	}
	#prepare height display
	$PixelsVertical=130
	
	#remove help
	$SearchRes.Text =""
	$SearchRes.Size = '0,0'
	#Pattern to Search
	
	$Wordlist = ""
	If ( $RadioButton3.Checked ) {
		$Wordlist = $textBox1.Text
	}
	Else {
		$Wordlist = $textBox1.Text.split(" ")
	}

	## -- Create The Progress-Bar
	$Global:ObjForm = New-Object System.Windows.Forms.Form
	$Global:ObjForm.Text = "Rendering links...Please wait"
	$Global:ObjForm.Height = 100
	$Global:ObjForm.Width = 500
	$Global:ObjForm.BackColor = "White"

	$Global:ObjForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
	$Global:ObjForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

	## -- Create The Label
	$ObjLabel = New-Object System.Windows.Forms.Label
	$ObjLabel.Text = "Starting. Please wait ... "
	$ObjLabel.Left = 5
	$ObjLabel.Top = 10
	$ObjLabel.Width = 500 - 20
	$ObjLabel.Height = 15
	$ObjLabel.Font = "Tahoma"
	## -- Add the label to the Form
	$Global:ObjForm.Controls.Add($ObjLabel)

	$PB = New-Object System.Windows.Forms.ProgressBar
	$PB.Name = "PowerShellProgressBar"
	$PB.Value = 0
	$PB.Style="Continuous"

	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 500 - 40
	$System_Drawing_Size.Height = 20
	$PB.Size = $System_Drawing_Size
	$PB.Left = 5
	$PB.Top = 40
	$Global:ObjForm.Controls.Add($PB)
	
	#type of element to search
	$Global:searchlist = @()
	$removedpath=@("C:\Windows",$env:APPDATA,$env:LOCALAPPDATA)
	
	$cpttot = 0
	$cptfnd = 0
	$progresslimit = 200
	#ForEach ($Pattern in $Wordlist) {
		If ( $RadioButton1.Checked ) {
			$Global:searchlist += gci -Path $path -recurse | %{$cpttot++;if(0 -eq $cpttot % 200){$progress.text = "$cptfnd matchs ($cpttot total)"; $progress.refresh()}; $_} | where { ! $_.PSIsContainer } | Where{$_.Name -match ($Wordlist -join '|' )} | %{$cptfnd++;$progress.text = "$cptfnd matchs ($cpttot total)"; $progress.refresh();$_}
			$progress.text = "$cptfnd matchs ($cpttot total)";$progress.refresh()
		}
		Else{ 
			$Global:searchlist += gci -Path $path -recurse | %{$cpttot++;if(0 -eq $cpttot % 200){$progress.text = "$cptfnd matchs ($cpttot total)"; $progress.refresh()}; $_} | Where-Object {$_ | Select-String ($Wordlist -join '|' ) -quiet} | %{$cptfnd++;$progress.text = "$cptfnd matchs ($cpttot total)"; $progress.refresh();$_}
			$progress.text = "$cptfnd matchs ($cpttot total)";$progress.refresh()
		}
#	}

	$Global:searchlist = $Global:searchlist | Sort-Object Name
	
	if ($cptfnd -ge $progresslimit)
	{
#		param($Global:ObjForm)
		## -- Show the Progress-Bar and Start The PowerShell Script
		$Global:ObjForm.Show() | Out-Null
		$Global:ObjForm.Focus() | Out-NUll
		$ObjLabel.Text = "Starting. Please wait ... "
		$Global:ObjForm.Refresh()
	}
	
	$Counter = 0
	ForEach($result in $Global:searchlist){
		$LinkLabel = New-Object System.Windows.Forms.LinkLabel
		$LinkLabel.Location = New-Object System.Drawing.Size(10,($HeightLocation + $PixelsVertical))
		$LinkLabel.Size = New-Object System.Drawing.Size(600,15)
		$LinkLabel.LinkColor = "#0074A2"
		$LinkLabel.ActiveLinkColor = "#114C7F"
		$linkLabel.Name = "templink"
		$LinkLabel.Text = $result.Name
		$linkLabel.Tag = $result.FullName
		$LinkLabel.add_Click({param($Sender) & explorer.exe $Sender.Tag })

		$main_form.Controls.Add($LinkLabel)
		$PixelsVertical += 15
		
		$Counter++
		if (0 -eq $Counter % 25 -And $cptfnd -ge $progresslimit)
		{
			[Int]$Percentage = ($Counter/$cptfnd)*100
			$PB.Value = $Percentage
#			$ObjLabel.Text = "Recursive Search: Writing Names of All Files Found Inside $Path"
			$Global:ObjForm.Refresh()
		}
	}
	$Global:ObjForm.Close()
})

$main_form.AutoScroll = $True 
#affichage fenetre
$main_form.ShowDialog()


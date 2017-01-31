$URL = "https://updates.jenkins-ci.org/download/plugins/"

$CurrentDirectory = (Get-Item -Path ".\" -Verbose).FullName
$CurrentDate = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
$DOWNLOAD_PATH = $CurrentDirectory+"\PluginPacks\"+$CurrentDate

#Create directory
New-Item -ItemType Directory -Force -Path $DOWNLOAD_PATH

#Go to that directory
cd $DOWNLOAD_PATH

#Get HTML
$HTML = Invoke-WebRequest -URI $URL

foreach($PLUGIN in $HTML.Links.innerHTML){
	$PLUGIN_FILE_NAME = $PLUGIN.Substring(0,$PLUGIN.Length-1)+".hpi"
	$PLUGIN_URL = "https://updates.jenkins-ci.org/latest/"+$PLUGIN_FILE_NAME
	write-output $PLUGIN_URL
	
	Invoke-WebRequest -Uri $PLUGIN_URL -OutFile $PLUGIN_FILE_NAME
}

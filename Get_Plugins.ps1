$URL = "https://updates.jenkins-ci.org/download/plugins/"

$CURRENT_DIRECTORY = (Get-Item -Path ".\" -Verbose).FullName
$CURRENT_DATE = (Get-Date).ToString('yyyy-MM-dd')
$DOWNLOAD_PATH = $CURRENT_DIRECTORY+"\PluginPacks\"+$CURRENT_DATE

#Create directory
New-Item -ItemType Directory -Force -Path $DOWNLOAD_PATH

#Get HTML
$PLUGINS_HTML = Invoke-WebRequest -URI $URL

foreach($PLUGIN in $PLUGINS_HTML.Links.innerHTML){
	$PLUGIN_FILE_NAME = $PLUGIN.Substring(0,$PLUGIN.Length-1)
	$PLUGIN_URL = $URL+$PLUGIN_FILE_NAME
	write-output $PLUGIN_URL
	#Create directory
	New-Item -ItemType Directory -Force -Path $DOWNLOAD_PATH\$PLUGIN_FILE_NAME
	
	$PLUGIN_VERSION_HTML = Invoke-WebRequest -Uri $PLUGIN_URL
	foreach($PLUGIN_VERSION in $PLUGIN_VERSION_HTML.Links.innerHTML){
	
		if($PLUGIN_VERSION.equals("permalink to the latest")){
			$PLUGIN_VERSION = "latest"
			$PLUGIN_VERSION_URL = "https://updates.jenkins-ci.org/"+$PLUGIN_VERSION+"/"+$PLUGIN_FILE_NAME+".hpi"
			#Example - https://updates.jenkins-ci.org/latest/BlazeMeterJenkinsPlugin.hpi
		}else{
			$PLUGIN_VERSION_URL = $URL+$PLUGIN_FILE_NAME+"/"+$PLUGIN_VERSION+"/"+$PLUGIN_FILE_NAME+".hpi"
			#Example - https://updates.jenkins-ci.org/download/plugins/BlazeMeterJenkinsPlugin/2.7/BlazeMeterJenkinsPlugin.hpi
		}
	
		#Create directory
		New-Item -ItemType Directory -Force -Path $DOWNLOAD_PATH\$PLUGIN_FILE_NAME\$PLUGIN_VERSION
		
		#write-output $PLUGIN_VERSION
		Invoke-WebRequest -Uri $PLUGIN_VERSION_URL -OutFile $DOWNLOAD_PATH\$PLUGIN_FILE_NAME\$PLUGIN_VERSION\$PLUGIN_FILE_NAME".hpi"
	
	}
	
	
	
}

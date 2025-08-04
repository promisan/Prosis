<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Select template</title>
	
<cf_ajaxRequest>	
	
</head>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<div style="position:absolute;width:100%;height:100%; overflow: auto; scrollbar-face-color: F4f4f4;">

<script type="text/javascript">

function JSselect(theFile) {
	var dir=theFile.split("/");
	var path=""

	for (var i=0;i<(dir.length-1);i++) 
	{
		path=path+"\\"+dir[i];
		
	}
	window.opener.document.AddFile.PathName.value=path;
	window.opener.document.AddFile.FileName.value=dir[i];
	window.opener.document.AddFile.File.value=path+dir[i];
	window.close();
	
	<!--- var url = "GetDescription.cfm?Path="+path+"&filename="+dir[i];

	
	AjaxRequest.get({
	    'url':url
	    ,'onSuccess':function(req){ 
			window.opener.document.AddFile.TemplateFunction.value = req.responseText;
			window.close();
		}
	    ,'onError':function(req){ alert('Error!\nStatusText='+req.statusText+'\nContents='+req.responseText);}
	  }
	);	
	
	--->


}

 
</script>  

<cf_dcCom component="dcFileManagerV3" 
title="Prosis File Manager" 
folder="#SESSION.rootPath#"
selectFileMode="Yes" 
selectFileJSFunction="JSselect()"
allowCut="No"
allowFileViewing="Yes"
allowEditFiles="Yes"
ALLOWFILEDELETE="No"
ALLOWFOLDERDELETE="No"
ALLOWFILERENAME="No"
ALLOWFOLDERRENAME="No"
ALLOWADDFOLDER="No"
ALLOWUPLOADFILE="No"
allowFileProperties="No"
allowFileDownload="No"
allowRefresh="No"
ALLOWCOPY="No">
</cf_dcCom>

</div>

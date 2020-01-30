
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

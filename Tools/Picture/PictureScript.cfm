
<cfajaxproxy cfc="Service.Process.System.UserController" jsclassname="systemcontroller">

<cfoutput>

	<script language="JavaScript">

	function pictureedit(path,dir,filter,height,width)	{				
		ProsisUI.createWindow('wApplicantPicture','Picture','',{resizable:false,center:true,modal:true,width:530,height:400});		
		ptoken.navigate('#SESSION.root#/Tools/Picture/PictureDialog.cfm?path='+path+'&dir='+dir+'&filter='+filter+'&width='+width+'&height='+height,'wApplicantPicture')
	}
	
	function checkfile() {

	var uController = new systemcontroller();			
	document.attach.action = document.attach.action + '&mid='+ uController.GetMid();				
	if (document.attach.uploadedfile.value == "") {
	   alert("You must select a file to upload.")
	   return false }	   
	}
			
	</script>
	
</cfoutput>	
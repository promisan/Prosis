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
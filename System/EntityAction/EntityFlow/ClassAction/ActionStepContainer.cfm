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

<html>
<head>
	<title>Maintain workflow Actions</title>
</head>

<body>

<cfoutput>
	
	<script language="JavaScript">
	
		 function addtab(id,pub) {
		 	 	 
		  try {	 
		  ColdFusion.Layout.createTab('wfcontain',id,id,'ActionStepContainerItem.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode='+id+'&PublishNo='+pub,{closable:true}) 	  
		  ColdFusion.Layout.selectTab('wfcontain',id)
		  } catch(e) {}  
	
		} 
		
	</script>
	
	<table width="100%" height="100%" align="center">
	
	    <tr>
		<td align="center" height="100%">
		
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>   
					
		<cfset attrib = {type="Tab",name="wfcontain",tabstrip="false",width="926",height="870"}>
	
		<cflayout attributeCollection="#attrib#">	
				
			<cflayoutarea 
		          name="#URL.ActionCode#"
		          source="#SESSION.root#/system/entityAction/EntityFlow/ClassAction/ActionStepContainerItem.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#URL.ActionCode#&PublishNo=#URL.PublishNo#&mid=#mid#"
		          title="#URL.ActionCode#"		
				  overflow="hidden"		  	 		   	 
		          closable="true"/>
			
		</cflayout>
		
	    </td>
		</tr>
	
   </table>	
		
</cfoutput>

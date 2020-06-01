
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

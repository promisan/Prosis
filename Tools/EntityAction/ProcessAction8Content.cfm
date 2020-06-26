<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr><td colspan="2" style="padding-left:15px;padding-right:15px;">
   	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		
	<cfparam name="URL.Mode" default="">	
	<cfparam name="url.id"  default="{00000000-0000-0000-0000-000000000000}">
		
	<cfif Action.recordcount eq "0">
		<cf_message text="Problem, please contact your administrator">
		<cfabort>
	</cfif>
	
	<cfoutput query="action">	
			
	  <cfif ActionReferenceShow eq "1"> 
				   
		  <tr class="fixrow"><td style="background-color:white" colspan="2" valign="top">		
		  <table width="100%" align="center">
			  
		    <!--- Element 1b of 3 about --->	
								   
			    <tr class="labelmedium line" style="background-color:white">
			    <td height="34" width="24%" style="background-color:white;font-size:16px;padding-left:10px">#Object.EntityDescription#:</td>
				<td style="background-color:white">
				<table width="100%">
					<tr class="labelmedium">
					<td style="font-size:16px;background-color:white">
					#Object.ObjectReference# <cfif Object.ObjectReference2 neq "">(#Object.ObjectReference2#)</cfif>
					</td>					
					<td align="right" style="background-color:white">
					
						<cfif getAdministrator("#Object.Mission#") eq "1">
					
						<img src="#SESSION.root#/Images/Workflow-Methods.png"
							 alt="Show Workflow"
							 border="0"
							 width="32"
							 height="32"
							 align="absmiddle"
							 valign="center"
							 style="cursor: pointer;"
						     onClick="workflowshow('#Object.ActionPublishNo#','#Object.EntityCode#','#Object.EntityClass#','#ActionCode#','#Object.ObjectId#')">
							 
						</cfif>	 
							 
					 </td>
					</tr>
				</table>
				</td>
			   </tr>	
			   
		  </table>
		  </td></tr> 	
			  
	   </cfif>	
	
	</cfoutput>
	
	<cfset processhide = "No">
	<cfset showProcess = "1">
	<cfset def         = "0">	
			
	<tr class="line"><td valign="top" colspan="2" height="30">	
		<table width="100%">
		<tr>		
			<cfset menumode = "menu">
			<cfinclude template="ProcessAction8Tabs.cfm">
			<td width="10%"></td>			
	    </tr>
		</table>	
	</td></tr>
		
	<tr><td height="100%" valign="top" style="border:0px solid silver">
		<table width="100%" height="100%">				
		<cfset menumode = "content">
		<cfinclude template="ProcessAction8Tabs.cfm">
		</table>		
	</td></tr>
	
</table>

</td></tr>

</table>


<cfoutput>

<script>

	function processAuthorization(owner, selectedstatus) {
	
		try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
		ColdFusion.Window.create('mydialog', 'Receipt', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    
		// ColdFusion.Window.show('mydialog') -- not needed					
		ColdFusion.navigate("#SESSION.root#/Roster/Maintenance/Parameter/ParameterEditOwnerView.cfm?isreadonly=0&owner=" + owner + "&selectedStatus=" + selectedstatus,'mydialog') 		
	}

</script>

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		   
	   <tr><td colspan="2" style="font-size:25px;height:40;padding-top:7px"  class="labellarge">
	    <cf_UIToolTip tooltip="Mapping of the access level assign to the user in the authorization framework <br> and the related steps that will be activated for roster processing (role:<b>RosterClear</b>).">
		  Authorization Level:
		</cf_UIToolTip>
	   </td></tr>
	   <tr><td colspan="2" height="1" style="border-bottom:1px dotted C0C0C0;"></td></tr>
	   	<input type="Hidden" name="accesslevel" value="">		
		<tr>
			<td class="labelmedium" width="30%" style="padding-left:10px">
				<table width="95%" align="left">
					<tr>
						<td colspan="2" class="labelmedium">
							View/Search:
						</td>
					</tr>
					<tr >
						<td class="labelmedium" style="color:red; font-size:11px; padding-top:2px;" valign="top">**</td>
						<td class="labelmedium" style="color:red; font-size:11px;">
							Changing this setting will affect the role assignment matrix.
						</td>
					</tr>
				</table>
			</td>
			<td class="labelmedium">
				<cfdiv id="searchList" bind="url:ParameterEditStepSettingsSearch.cfm?owner=#url.owner#&status=#url.status#">
			</td>
		</tr>
		
		<tr>
			<td width="30%" style="padding-left:10px" class="labelmedium">Process:</td>
			<td class="labelmedium" style="padding-left:5px">
				<a href="javascript:processAuthorization('#url.owner#', '#url.status#')"><font color="6688aa">Maintain Process Authorization</font></a>
			</td>
		</tr>
				   
	   <cfquery name="Workflow" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Ref_EntityClass
			 WHERE  EntityCode = 'EntRosterClearance' 
			 AND   Operational = 1
	   </cfquery>
			   
	   <tr class="hide">
	    <td height="25" class="labelmedium">Show denied if application reached until:</td>
		<td class="labelmedium">
		<select name="ShowDeniedStatus" class="regularxl">
			<cfloop query="denied">
			<option value="#Denied.Status#" <cfif Denied.Status eq ShowDeniedStatus>selected</cfif>>#Denied.Meaning#</option>
			</cfloop>
		</select>
		</td>		   		
	   </tr>
	   
       <tr><td colspan="2" style="font-size:25px;height:40;padding-top:7px" class="labellarge">Visibility</td></tr>
	   <tr><td colspan="2" height="1" style="border-bottom:1px dotted C0C0C0;"></td></tr>
	   	   
	   <tr>
	    <td width="190" class="labelmedium" style="padding-left:10px">Show in Roster Grid:</td>
	    <td><table cellspacing="0" cellpadding="0">
		     <tr><td class="labelmedium">
			 
			  <table>
			<tr class="labelmedium">
			<td> <input type="radio" name="ShowRoster" class="radiol" value="0" <cfif ShowRosterSearch eq "0">checked</cfif>></td>
			<td style="padding-left:3px">No</td>
			<td style="padding-left:6px"><input type="radio" name="ShowRoster" class="radiol" value="1" <cfif ShowRosterSearch eq "1">checked</cfif>></td>
			<td style="padding-left:3px">Yes</td>
			</tr></table>	
			
			 </td>			 
			 </tr></table>
		</td>
 	   </tr>
	   
	   <tr>
	    <td width="190" class="labelmedium" style="padding-left:10px">Show in Roster Search:</td>
	    <td><table cellspacing="0" cellpadding="0">
		     <tr><td class="labelmedium">
			 <input type="radio" name="ShowRosterSearch" class="radiol" value="0" <cfif ShowRosterSearch eq "0">checked</cfif>>Always hide
			 <input type="radio" name="ShowRosterSearch" class="radiol" value="1" <cfif ShowRosterSearch eq "1">checked</cfif>>Show if user has access
			 </td>			
			 <td class="labelmedium" style="padding-left:10px">
			 Precheck option in Search Criteria <input type="checkbox" class="radiol" name="ShowRosterSearchDefault" value="1" <cfif ShowRosterSearchDefault eq "1">checked</cfif>>		
			 </td>
			 </tr></table>
		</td>
 	   </tr>
	   
	   <tr><td colspan="2" style="font-size:25px;height:40;padding-top:7px" class="labellarge linedotted">Status Process Settings</td></tr>
	  	   
	   <tr>
	    <td width="190" style="padding-left:10px" class="labelmedium">
		<cf_UIToolTip tooltip="Upon selecting this status user has to specifically define the effective date of the status.">
		Enforce Status Date:
		</cf_UIToolTip>
		</td>
	    <td class="labelmedium">
		    <table>
			<tr class="labelmedium">
			<td> <input type="radio" class="radiol" name="EnableStatusDate" value="0" <cfif EnableStatusDate eq "0">checked</cfif>></td>
			<td style="padding-left:3px">Yes</td>
			<td style="padding-left:6px"><input type="radio" class="radiol" name="EnableStatusDate" value="1" <cfif EnableStatusDate eq "1">checked</cfif>></td>
			<td style="padding-left:3px">No</td>
			</tr></table>					
		</td>
 	   </tr>
	   
	    <tr>
	    <td class="labelmedium" style="padding-left:10px;padding-right:5px">Start workflow upon reaching status:</td>
		<td class="labelmedium">

		<select name="EntityClass" class="regularxl">
		<option value="" selected>No workflow</option>
		<cfloop query="workflow">
		<option value="#EntityClass#" <cfif EntityClass eq Action.EntityClass>selected</cfif>>#EntityClass#</option>
		</cfloop>
		</select>
		</td>	
	   </tr>
		    
	   <tr>
	    <td width="190" class="labelmedium" style="padding-left:10px">Enforce Roster Status Decision:</td>
	    <td class="labelmedium">
		    <table>
			<tr class="labelmedium">
			<td><input type="radio" class="radiol" name="EnforceReason" value="1" <cfif EnforceReason eq "1">checked</cfif>></td>
			<td style="padding-left:3px">Yes</td>
			<td style="padding-left:6px"><input type="radio" class="radiol" name="EnforceReason" value="0" <cfif EnforceReason eq "0">checked</cfif>></td>
			<td style="padding-left:3px">No</td>
			</tr></table>		
		</td>
 	   </tr>
	   
	   <tr> 	   		
			<td colspan="2">
		   	   <cfinclude template="ParameterEditStepDecision.cfm">			 			 
			</td>
	   </tr>
	   
</table>	

</cfoutput>   
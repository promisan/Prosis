
<cfparam name="URL.ID1" default="">
<cfparam name="URL.Status" default="0">

<cfinvoke component="Service.AccessReport"  
         method="editreport"  
		 ControlId="#URL.ID#" 
		 returnvariable="accessedit">

<cfquery name="Group" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT DISTINCT A.*
    FROM  System.dbo.UserNames A
	WHERE A.Disabled = '0'
	AND AccountType = 'Group'
	AND A.Account NOT IN (SELECT Account 
	                     FROM    System.dbo.Ref_ReportControlUserGroup
						 WHERE   ControlId = '#URL.ID#')
						 
	<cfif SESSION.isAdministrator eq "No" and accessEdit neq "EDIT">  				 
	AND A.AccountOwner IN (SELECT ClassParameter
						FROM   OrganizationAuthorization A
						WHERE  A.UserAccount = '#SESSION.acc#'
						  AND  A.Role = 'AdminSystem')			 
	</cfif>			
			  
	ORDER BY AccountOwner,LastName
</cfquery>

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM   Ref_ReportControlUserGroup R
	WHERE  R.Operational = 1
	AND    ControlId = '#URL.ID#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ReportControlUserGroup R, UserNames U
	WHERE  ControlId = '#URL.ID#'
	AND    U.Account = R.Account
</cfquery>

  <table width="100%" align="center" class="formpadding">
    <tr><td>

	<table width="100%" align="center">
	    
	  <tr>
	    <td>
		
	    <table width="100%" border="0" class="navigation_table">
			
	    <TR class="labelmedium line fixrow">
		   <td style="width:100%;padding-left:3px;font-size:19px;font-weight:200" colspan="2"><cf_tl id="Grant access to the following USER GROUPS"></td>
		   <td style="min-width:200;cursor:pointer"><cf_UIToolTip tooltip="Delegate security access to users assigned to this group">Delegation</cf_UIToolTip></td>
		   <td style="min-width:80">Active</td>
		   <td colspan="1" style="min-width:200"></td>		
		  
	    </TR>			
		
		<cfoutput>
		
		<cfloop query="Detail">
		
			<cfset rl = Account>
			<cfset op = Operational>
													
			<cfif URL.ID1 eq Account>
										
				<TR class="labelmedium">
							    					   						 						  
				   <td colspan="2" height="20" style="padding-left:5px">#Account# : #LastName# (#AccountMission#)</td>
					<td><input type="checkbox" class="radiol" name="groupdelegation" id="groupdelegation" value="1" <cfif "1" eq Detail.Delegation>checked</cfif>></td>   
					<td><input type="checkbox" class="radiol" name="groupoperational" id="groupoperational" value="1" <cfif "1" eq Detail.Operational>checked</cfif>></td>			   
				   <td colspan="3" align="right"><input type="button" onclick="groupsubmit('#url.id1#')" value="Update" class="button10g"></td>
	
			    </TR>	
						
			<cfelse>
			
				<TR class="labelmedium navigation_row line">
				   <td colspan="2" height="20" style="padding-left:4px"><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#Account# : #LastName#</a></td>
				   
				   <td><cfif detail.delegation eq "0"><font color="red">No<cfelse>Yes</cfif></td>
				   <td><cfif op eq "0">No<cfelse>Yes</cfif></td>
				   
				   <td colspan="2"><table align="center">
				   <tr class="labelmedium">
				   <cfif URL.status eq "0">
				     <td align="center">				 
					    <cf_img icon="edit" onclick="ColdFusion.navigate('Group.cfm?status=#url.status#&ID=#URL.ID#&ID1=#Account#','groupbox')">											
					 </td>
					 <td style="padding-left:4px;padding-right:24px;padding-top:1px">				   
					   <cf_img icon="delete" onclick="ptoken.navigate('GroupPurge.cfm?status=#url.status#&ID=#URL.ID#&ID1=#Account#','groupbox')">				   					
					 </td>			   				  
				   </cfif>	
				   </tr>	
				   </table></td>	   
			    </TR>	
			
			</cfif>
				
		</cfloop>
		
		</cfoutput>
								
		<cfif URL.ID1 eq "" and URL.status eq "0">					
							
			<TR class="line">
			
			<td colspan="2" style="padding-left:3px;height:35px">
			
				<cf_UIselect name   = "group"
				    class           = "regularxxl" 
					queryposition   = "below"
					query           = "#group#"
					group           = "AccountOwner"
					value           = "account"
					required        = "Yes"
					onchange        = "show(this.value,'btn_group')"	
					message         = "Please select a group"
					display         = "LastName"
					filter          = "contains"																																				
					style           = "width:90%;">
						
				</cf_UIselect>			
			
			<!---
			   <select class="regularxl" style="width:60%" name="group" id="group" onChange="show(this.value,'btn_group')">
			    <option>---Select---</option>
	           <cfoutput query="Group" group="AccountOwner">
			     <option value=""><cfif AccountOwner eq "">Global<cfelse>#AccountOwner#</cfif></option>
				 <cfoutput>
			     <option value="#Account#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #LastName# (#Account#)</option>
				 </cfoutput>
			   </cfoutput>
		   	   </select>			
			   --->
			   
			</td>		
			
			<td width="40"><input type="checkbox" class="radiol" name="groupdelegation"  id="groupdelegation"  value="1"></td>					   
			<td width="40"><input type="checkbox" class="radiol" name="groupoperational" id="groupoperational" value="1" checked></td>								   
			<td colspan="2" align="right">
			<input name="btn_group" id="btn_group" type="button" onclick="groupsubmit('')" style="width:50" value="Add" class="hide">
			</td>
							
			</TR>			
								
		</cfif>	
		
		</table>
		
		</td>
		</tr>				
		
		<cfif check.recordcount eq "0">
		
			<tr><td height="6" colspan="6"></td></tr> 			
			<tr class="labelmedium"><td colspan="6" align="center" height="50"><font color="FF0000">Attention:</font> No group access defined.</td></tr>
			
		</cfif>
		
		<tr><td height="1" colspan="5"></td></tr> 
							
	</table>	
	
</td></tr>
	
</table>	

<cfset ajaxonload("doHighlight")>
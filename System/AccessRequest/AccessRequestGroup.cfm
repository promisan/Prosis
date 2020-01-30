<cfparam name="url.requestid" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.mode"      default="new">

<cfquery name="UserGroup" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  UN.*, 
		        G.AccountGroup as RequestGroup
		FROM    UserNames UN
		
		<cfif url.mode neq "view">
				LEFT    JOIN UserRequestUserGroup G
		<cfelse>
				INNER   JOIN UserRequestUserGroup G
		</cfif>
				ON		UN.Account = G.AccountGroup AND G.RequestId = '#url.requestid#'
			
		WHERE   AccountType = 'Group' 
		
		AND     Disabled != '1' 
		<!---
		AND     AccountMission IN ('#URL.Mission#','Global')
		--->
		
		<!--- account mission --->		
		AND     AccountMission IN ('#URL.Mission#')
		
		<!--- only usergroups that are actually used for modules in this application --->		
		AND     UN.Account IN (SELECT UserAccount
		                       FROM   Organization.dbo.OrganizationAuthorization
							   WHERE  UserAccount = UN.Account
							   AND    Role IN (SELECT Role 
							                   FROM   Organization.dbo.Ref_AuthorizationRole 
											   WHERE  SystemModule IN (SELECT SystemModule
											                           FROM   Ref_ApplicationModule
																	   WHERE  Code = '#url.application#')
											   )
							   )
		ORDER BY LastName				   	   
</cfquery>

<input type="hidden" name="AccountGroup" id="AccountGroup" value=""> <!--- So the field exists even if no groups were selected --->

<table width="100%">
	<tr>
		<td>
			<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font-size:15px; width:250px; padding:5px;"
			   rowclass         = "clsGroup"
			   rowfields        = "clsGroupContent">
		</td>
	</tr>
	<tr>
		<td width="100%">

			<cfinvoke component="Service.Access"  
				   method="useradmin" 
				   returnvariable="access">	
			
			<cfif UserGroup.recordcount neq 0>
			
				<cfif UserGroup.recordcount lte "1">
					<table width="50%">
				<cfelse>
				    <table width="100%">
				</cfif>	
				
				
				<cfset cnt = "0">
				<cfset row = "0">
				
				<cfoutput query="UserGroup">
				
					<cfif cnt eq "0"><tr class="clsGroup"></cfif>
					
					<cfset cnt = cnt + 1>
					<cfset row = row + 1>
					
					<cfif RequestGroup neq "">
					   <cfset cl = "ffffbf">
					<cfelse>
					   <cfset cl = "ffffff">
					</cfif>  
							
					<td id="group_#row#" height="20px" style="padding-left:20px;padding-right:6px" bgcolor="#cl#">
					 	<cfif url.mode neq "view">
							<input type = "checkbox" 
							  name      = "AccountGroup" id = "AccountGroup"   onclick = "hl('group_#row#',this.checked); updateAccountDetails();" 
							  value     = "#Account#" <cfif RequestGroup neq "">checked="checked"</cfif>>
						</cfif>
					</td>
					
					<td id="group_#row#" bgcolor="#cl#" class="labelit clsGroupContent">
					<cfif Access eq "EDIT" or Access eq "ALL"><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')"><font color="0080C0"></cfif>
					#LastName#</td>
					<td id="group_#row#" class="labelit clsGroupContent" bgcolor="#cl#">#AccountMission#</td>
												
					<cfif cnt eq 3>
						</tr>
					    <tr class="clsGroup"> <td class="linedotted" colspan="9"> </td> </tr>	
						<cfset cnt=0>
					</cfif>
						
				</cfoutput>
				</table>
			
			<cfelse>
				<table width="100%">
					<tr>
						<td align="center" style="height:34px" class="labelit">
						    <cfoutput>
							<font size="3">No user groups found that are applicable for Application: <b>#url.application#</b> and Entity : <b>#URL.Mission#</b></font> 
							</cfoutput>
						</td>
					</tr>
				</table>
			</cfif>

		</td>
	</tr>
</table>

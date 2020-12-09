
<cfif url.role eq "">
	<cf_screentop height="100%" scroll="Yes" html="no" close="parent.ColdFusion.Window.destroy('myrole',true)" label="Add Role" layout="webapp" banner="gray" >
<cfelse>
	<cf_screentop height="100%" scroll="Yes" html="no" close="parent.ColdFusion.Window.destroy('myrole',true)" label="Edit Role" banner="gray" layout="webapp">
</cfif>

<cfinvoke component="Service.AccessReport"  
         method="editreport"  
	  ControlId="#URL.ID#" 
	  returnvariable="accessedit">

<cfquery name="RoleList" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT A.*, M.MenuOrder
    FROM  Ref_AuthorizationRole A, 
	      System.dbo.Ref_SystemModule M
	WHERE A.SystemModule = M.SystemModule
	AND  M.Operational = '1'
    AND  A.Role NOT IN (SELECT Role 
	                     FROM System.dbo.Ref_ReportControlRole 
						 WHERE ControlId = '#URL.ID#') 
	<cfif SESSION.isAdministrator eq "No" and accessEdit neq "EDIT">  					 
	AND A.RoleOwner IN (SELECT ClassParameter
						FROM   OrganizationAuthorization A
						WHERE  A.UserAccount = '#SESSION.acc#'
						  AND  A.Role = 'AdminSystem')			 
	</cfif>					  
	ORDER BY MenuOrder, A.SystemModule
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	R.*, A.Description, A.OrgUnitLevel
    FROM 	Ref_ReportControlRole R, 
	     	Organization.dbo.Ref_AuthorizationRole A 
	WHERE 	R.Role = A.Role
	AND  	ControlId = '#URL.ID#'
	AND		R.Role = '#url.role#'
</cfquery>

<cfquery name="OwnerList" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_AuthorizationRoleOwner	
</cfquery>

<cfquery name="Class" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_AuthorizationRole
	 WHERE  Role = '#URL.Role#'	  
</cfquery>

<script>
	function selectcell(mission) {
		document.getElementById('td_'+mission).style.backgroundColor = '';
		
		if (document.getElementById('mission_'+mission).checked) {
			document.getElementById('td_'+mission).style.backgroundColor = 'E7FEEA';
		}
		
	}
</script>

<cfoutput>

	<cfform name="frmRoleEdit" action="RoleEditSubmit.cfm?status=#url.status#&class=#Class.Parameter#&id=#url.id#&role=#url.role#" target="processRoleEdit" method="POST">
		
	<table width="94%" align="center" class="formspacing formpadding">
		<tr><td height="10"></td></tr>
		<tr><td colspan="2" class="hide"><iframe name="processRoleEdit" id="processRoleEdit" frameborder="0"></iframe></td></tr>
			
		<tr>
			<td width="20%" height="23" class="labelmedium"><cf_tl id="Role">:</td>
			<td class="labelmedium">
				<cfif url.role neq "">
					<b>#Detail.Role# - #Detail.Description#</b>
					<input type="Hidden" name="role" id="role" value="#Detail.Role#">
				<cfelse>
			
					<cfselect class="regularxxl" name="role" query="RoleList" display="Description" value="Role" group="SystemModule"></cfselect>
							
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="labelmedium"><cf_tl id="Owner">:</td>
			<td class="labelmedium">
				<cfdiv id="divOwner" bind="url:RoleEditOwner.cfm?role={role}"> 
			</td>	
		</tr>
		
		<tr>
			<td height="23" class="labelmedium"><cf_tl id="Delegation">:</td>
			<td>
			<table cellspacing="0" cellpadding="0">
			 <tr><td>
				<input type="checkbox" class="radiol" name="roledelegation" id="roledelegation" value="1" <cfif "1" eq Detail.Delegation>checked</cfif>>
				</td>
				<td class="labelmedium" style="padding-left:4px"><font color="808080">Users with this role may redefine security settings in production</font></td>
			 </tr>
			</table>	
			</td>
		</tr>
		
		<tr>
			<td height="23" colspan="1" class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Enabled for">:</td>
			<td colspan="1" style="padding-left:0px">
				<cfdiv id="divMission" bind="url:RoleEditMission.cfm?id=#url.id#&role={role}"> 
			</td>
		</tr>
		
		<tr><td></td><td class="labelmedium"><font color="gray">Leave blank to enable for ANY entity</i></font></td></tr>
		
		<tr>
			<td height="25" class="labelmedium"><cf_tl id="Operational">:</td>
			<td>
			<input class="radiol" type="checkbox" name="roleoperational" id="roleoperational" value="1" <cfif "1" eq Detail.Operational or url.role eq "">checked</cfif>>
			</td>
		</tr>
		<tr><td height="3"></td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td height="3"></td></tr>
		<tr>
			<td colspan="2" align="center">
			<input type="Submit" value="  Save  " name="save" id="save" class="button10g">
			</td>
		</tr>
		
	</table>
	
	</cfform>
	
</cfoutput>


<cfparam name="url.idmenu" default="">

<cfquery name="Mission" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_Mission M
	WHERE  Operational = 1
	AND    EXISTS (
		SELECT 'X'
		FROM Employee.dbo.Ref_ParameterMission
		WHERE Mission = M.Mission )
	AND  EXISTS (
		SELECT 'X'
		FROM   Organization.dbo.Ref_MissionModule
		WHERE  Mission = M.Mission 
		AND    SystemModule = 'Staffing')
</cfquery>


<cf_screentop height="100%" 
	  label="Edit Person Event" 
	  scroll="Yes" 
	  layout="webapp" 
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEvent
		WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Code ?")) {	
	return true 	
	}	
	return false
	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <cfoutput>
	<tr><td></td></tr>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="50"class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter an order" style="text-align:center" required="Yes" size="2" maxlength="4" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Record Position:</TD>
    <TD>
  		<input type="checkbox" class="radiol" name="ActionPosition" value="1" <cfif get.ActionPosition eq 1>checked</cfif>>
    </TD>
	</TR>

	<TR class="labelmedium">
    <TD>Enable Portal:</TD>
    <TD>
  		<input type="checkbox" class="radiol" name="EnablePortal" value="0" <cfif get.EnablePortal eq 1>checked</cfif>>
    </TD>
	</TR>


	<TR class="labelmedium">
    <TD>Record Period:</TD>
    <TD>
	    <table>
		<tr class="labelmedium">
		<td style="padding-left:0px"><input type="radio" class="radiol" name="ActionPeriod" value="0" <cfif get.ActionPeriod eq 0>checked</cfif>></td>
		<td style="padding-left:2px">No</td>
  		<td style="padding-left:4px"><input type="radio" class="radiol" name="ActionPeriod" value="1" <cfif get.ActionPeriod eq 1>checked</cfif>></td>
		<td style="padding-left:2px">Effective</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="ActionPeriod" value="2" <cfif get.ActionPeriod eq 2>checked</cfif>></td>
		<td style="padding-left:2px">Period (Effective and Expiration)</td>
		</tr>
		</table>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Workflow:</TD>
    <TD>
	
	      <cfquery name="getWF" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_EntityClass
				WHERE 	EntityCode = 'PersonEvent'
				</cfquery>
				
			<select name="entityClass" id="entityClass" class="regularxl">
				<option value="">None</option>
				<cfloop query="getWF">
				  <option value="#entityClass#" <cfif get.entityClass eq entityClass>selected</cfif>>#entityClass# - #entityClassName#</option>
			  	</cfloop>
			</select>
	
  	   </TD>
	</TR>
	
	</cfoutput>

	<TR class="labelmedium"><td colspan="2"><cf_tl id="Entity">:</td></tr>
	<TR>
	<td width="100%" colspan="2">
		<table>
		
		<tr>
			<td style="padding-left:30px">
			
			<table cellspacing="0" border="0" cellpadding="0">						
			<cfset row = 0>
		  
			<cfoutput query="Mission">
			
			<cfset row = row+1>
			
			<cfif row eq "1">
			<tr class="labelmedium">
			</cfif>						
			
			<td width="100" style="height:20px;padding-left:5px">#Mission#:</td>					
			
			<td align="center" width="35"> 
			
			 <table width="100%" cellspacing="0" cellpadding="0">
			    <tr>
				
				<td align="center">			 
				
				<cfquery name="MissionCheck" 
				datasource="appsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT * 
				    FROM   Ref_PersonEventMission
					WHERE  PersonEvent = '#get.Code#'
					AND    Mission     = '#Mission#'
				</cfquery>
				 	
				<cfif MissionCheck.Recordcount eq "1">
					 <input type="checkbox" class="radiol" name="Missions" value="#Mission#" checked>
				<cfelse>
					 <input type="checkbox" class="radiol" name="Missions" value="#Mission#">
				</cfif>
				  
				</td></tr></table>
			 
			 </TD>
						 
			 <cfif row eq "4">
			 	</tr>
				<cfset row = 0>
			 </cfif>
			
			</cfoutput>
			
			</table>
		
			</td>	
			
		</tr>
		</table>
		
	</td>	
	</TR>	
	
	<tr><td colspan="2" class="line"></td></tr>
		
</TABLE>

<cf_dialogBottom option="edit">
	
</CFFORM>


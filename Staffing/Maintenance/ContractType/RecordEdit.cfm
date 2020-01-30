<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Contract Type"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ContractType
WHERE ContractType = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

	function ask() {
		if (confirm("Do you want to remove this Contract Type ?")) {
		return true 
		}
		return false	
	}

	function hlMission(mis,cl) {
		var control = document.getElementById('mission_'+mis);
		if (control.checked) {
			document.getElementById('td_'+mis).style.backgroundColor = cl;
		}else{
			document.getElementById('td_'+mis).style.backgroundColor = '';
		}
	}

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="4"></td></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <input type="text" name="ContractType" value="#get.ContractType#" size="15" maxlength="20" class="regularxl">
	   <input type="hidden" name="ContractTypeOld" value="#get.ContractType#" size="15" maxlength="20" readonly>
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<cfquery name="Type" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AppointmentType		
		ORDER BY ListingOrder
	</cfquery>
	
	<tr>
	<td class="labelit">Appointment type:</td>
	<td>
		
		<select name="AppointmentType" class="regularxl">
		   
			<cfloop query="Type">
				<option value="#AppointmentType#" <cfif get.AppointmentType eq AppointmentType>selected</cfif>>#Description#</option>
			</cfloop>		
		</select>		
		
	</td>
	
	</tr>
	
				
	<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityClass
		WHERE  EntityCode = 'PersonContract'
	</cfquery>
	
	<tr>
	<td class="labelit">Workflow Class:</td>
	<td>
		
		<select name="Workflow" class="regularxl">
		    <option value="">N/A</option>
			<cfloop query="WorkFlow">
				<option value="#EntityClass#" <cfif get.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
			</cfloop>		
		</select>		
		
	</td>
	
	</tr>
	
	<TR>
    <TD valign="top" class="labelit" style="padding-top:4px;">Enabled for:</TD>
    <TD>
		<cfdiv id="divMission" bind="url:RecordMission.cfm?code=#get.ContractType#">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
	<td align="center" height="30" colspan="2">
	<input class="button10g" style="width:90px" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" style="width:90px" type="submit" name="Delete" value="Delete" onclick="return ask()">
    <input class="button10g" style="width:90px" type="submit" name="Update" value="Update">
	</td>	
	</tr>
		
</TABLE>

</CFFORM>
	
<cf_screenbottom layout="innerbox">	
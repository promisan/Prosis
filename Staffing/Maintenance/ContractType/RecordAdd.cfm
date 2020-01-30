<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Contract Type"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
			  
<script>
	function hlMission(mis,cl) {
		var control = document.getElementById('mission_'+mis);
		if (control.checked) {
			document.getElementById('td_'+mis).style.backgroundColor = cl;
		}else{
			document.getElementById('td_'+mis).style.backgroundColor = '';
		}
	}
</script>

<!--- Entry form --->

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
	
	<tr><td height="5"></td></tr>

    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <cfinput type="Text" name="ContractType" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
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
		   
			<cfoutput query="Type">
				<option value="#AppointmentType#">#Description#</option>
			</cfoutput>		
		</select>		
		
	</td>
	
	</tr>
	
				
	<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClass
		WHERE EntityCode = 'PersonContract'
	</cfquery>
	
	<td class="labelit">Workflow Class:</td>
	<td>
		
		<select name="Workflow" class="regularxl">
		    <option value="">N/A</option>
			<cfoutput query="WorkFlow">
				<option value="#EntityClass#">#EntityClassName#</option>
			</cfoutput>		
		</select>		
		
	</td>
	
	</tr>
	
	<TR>
    <TD valign="top" class="labelit" style="padding-top:4px;">Enabled for:</TD>
    <TD>
		<cfdiv id="divMission" bind="url:RecordMission.cfm?code=">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
	<td align="center" height="30" colspan="2">
		
	<input class="button10s" style="width:80px" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10s" style="width:80px" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
		
	</CFFORM>
	
</TABLE>


<cf_screenbottom layout="innerbox">	
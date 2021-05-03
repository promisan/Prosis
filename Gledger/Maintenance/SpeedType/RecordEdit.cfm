<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray"
			  label="Transaction Entry Settings" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Speedtype
WHERE Speedtype = '#URL.ID1#'
</cfquery>

<script language="JavaScript">


function taxtoggle(val) {

 if (val == '1') {
   document.getElementById('taxcodebox').className = "regular"
 } else {
   document.getElementById('taxcodebox').className = "hide"
 } 

}

function ask() {
	if (confirm("Do you want to remove this setting ?")) {
		return true 	
	}	
	return false	
}	

</script>
  
<cfquery name="Parent"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (select AccountParent 
	           FROM Ref_SpeedTypeParent 
			   WHERE AccountParent = L.AccountParent 
			   AND SpeedType = '#URL.ID1#') as Selected 
	FROM Ref_AccountParent	L	
</cfquery>

<cfoutput query="Get">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="92%" align="center" class="formpadding">
	 
	<tr><td height="8"></td></tr>

    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="Text" class="regularxl" name="Speedtype" value="#SpeedType#" readonly message="Please enter a code" required="Yes" size="10" maxlength="10">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
  	    <cfinput type="Text"  class="regularxl" name="Description" value="#Description#" message="Please enter a description" required="Yes" size="40" maxlength="50">
    </TD>
	</TR>
	
	<tr><td height="5"></td></tr>
	<tr><td class="labellarge" style="height:40px;color:008000">Header Settings</td></tr>
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	
	
	<TR>
    <TD class="labelmedium" style="padding-left:10px"><cf_tl id="Relation">:</TD>
    <TD> 
		
		<cfquery name="Mission" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT *  
		    FROM   Ref_Mission
			WHERE  MissionStatus = '1' <!--- not dynamic --->
		</cfquery>
		    	
    	<select name="InstitutionTree" class="regularxl" size="1">
		    <option value="">Any</option>
			<option value="Staff" <cfif get.InstitutionTree eq "Staff">selected</cfif>>Staff</option>
			<option value="Customer" <cfif get.InstitutionTree eq "Customer">selected</cfif>>Customer</option>
		    <cfloop query="Mission">
				<option value="#Mission#" <cfif get.InstitutionTree eq Mission>selected</cfif>>#Mission#</option>
			</cfloop>
	    </select>
	
    </TD>
	</TR>
	
	<cfquery name="Custom"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *, (select Topic 
	           FROM Ref_SpeedTypeTopic
			   WHERE Topic = L.Code
			   AND SpeedType = '#URL.ID1#') as Selected 
	FROM Ref_Topic	L	
	WHERE Operational = 1 
	</cfquery>
	
	<tr>
	<td colspan="2" class="labelmedium" valign="top"  style="padding-top:2px;padding-left:10px;cursor: pointer;">
		<cf_UItooltip  tooltip="Transaction custom field entry.<br>Fields are declared under Maintenance : Custom Fields">Enabled custom Fields:</cf_UItooltip></td>
	</tr>
	<tr>
	<td colspan="2" style="padding-left:30px">
	
		<table>
			<cfset row = 0>
			<cfloop query="Custom">
				<cfset row = row+1>
				<cfif row eq "1"><tr class="labelmedium" style="height:15px"><cfelse><td style="padding-left:20px"></td></cfif>				
				<td style="padding-right:3px">#Code#.</td>
				<td style="padding-right:5px">#Description#</td>
				<td style="padding-right:5px"><input type="checkbox" class="radiol" name="CustomSelect" value="#Code#" <cfif selected neq "">checked</cfif>></td>
				<cfif row eq "3"></tr><cfset row = 0></cfif>
			</cfloop>
		</table>
	  
    </TD>
	</TR>
	
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="labellarge" style="height:40px;color:008000">Line Settings</td></tr>
		      	
	<TR>
    <TD class="labelmedium" colspan="2" valign="top" style="padding-left:10px;padding-top:3px">GL Account selection Limited to:</TD>
	</tr>
	
	<tr>
    <TD colspan="2" style="padding-left:60px">
		<table cellspacing="0" cellpadding="0">
		<cfset row = 0>
		<cfloop query="Parent">
			<cfset row = row+1>
			<cfif row eq "1"><tr class="labelmedium line" style="height:15px"><cfelse><td  style="padding-left:20px"></td></cfif>				
			<td style="padding-right:3px">#AccountParent#</td>
			<td style="padding-right:8px">#Description#</td>
			<td style="padding-right:5px"><input type="checkbox" class="radio" name="ParentSelect" value="#AccountParent#" <cfif selected neq "">checked</cfif>></td>
			<cfif row eq "3"></tr><cfset row = 0></cfif>
		</cfloop>
		</table>
	  
    </TD>
	</TR>
	
	<tr><td colspan="2" class="labelit" style="height:40px;padding-left:10px">Attention: <b>Fund, Program and Object and Contribution</b> are enforced through GL Account</td></tr>
		
	<TR>
    <TD class="labelmedium" style="padding-left:10px;">External Program:</TD>
    <TD>
	  	 
  	   <select name="ExternalProgram" size"1" class="regularxl">
          <option value="1" <cfif externalprogram eq "1">selected</cfif>>Enabled</option>
		  <option value="0" <cfif externalprogram eq "0">selected</cfif>>Hide</option>
	   </select>
	   
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium" style="padding-left:10px;">Cost Center:</TD>
    <TD>
	  	 
  	   <select name="CostCenter" size"1" class="regularxl">
          <option value="1" <cfif costcenter eq "1">selected</cfif>>Enabled</option>
		  <option value="0" <cfif costcenter eq "0">selected</cfif>>Hide</option>
	   </select>
	   
    </TD>
	</TR>
		
	<cfquery name="Tax"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Tax	
	
	</cfquery>
	
	<TR>
	<td class="labelmedium" style="padding-left:10px;cursor: pointer;">
		<cf_UItooltip tooltip="Transaction Tax Code">Tax Code:</cf_UItooltip>
	</td>
    <TD>
	
	  <table cellspacing="0" cellpadding="0">
	  <tr>
	  <td>
		
		<select name="TaxCodeMode" size"1" class="regularxl" onchange="taxtoggle(this.value)">
          <option value="1" <cfif taxcodemode eq "1">selected</cfif>>Enabled</option>
		  <option value="0" <cfif taxcodemode eq "0">selected</cfif>>Hide</option>
	   </select>
	   
	   </td>
	   
	   <cfif taxcodemode eq "1">
		   <cfset cl = "regular">
	   <cfelse>
	   	   <cfset cl = "hide">
	   </cfif>
	   	   
	   <td style="padding-left:4px" id="taxcodebox" class="#cl#">
	   
	   	<select name="TaxCode" size"1" class="regularxl">
           <cfloop query="Tax">
		    <option value="#taxcode#" <cfif get.taxcode eq taxcode>selected</cfif>>#Description#</option>
		   </cfloop>
	   </select>	   
	   
	   </td>
	   
	   </tr>
	   
	   </table>
  	
    </TD>
	</TR>
		
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">		 
	
	<tr><td colspan="2" align="center">
		
		<input class="button10g" style="height:25;width:120" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		
		<cfquery name="Check" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Journal
			WHERE  Speedtype = '#URL.ID1#'
		</cfquery>
		
		<cfif check.recordcount eq "0">		
			<input class="button10g"  style="height:24;width:120" type="submit" name="Delete" value="Delete" onclick="return ask()">		
		</cfif>
		
		<input class="button10g"  style="height:24;width:120" type="submit" name="Update" value="Update">
	
	</TD></TR>
	
</TABLE>	

</CFFORM>
	
</cfoutput>

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Reason" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_StatusReason
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this entry?")) {
	return true 
	}
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
<!--- edit form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="5"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <input type="text" name="Code" id="Code" value="#get.Code#" size="15" maxlength="15" class="regularxl">
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="15" maxlength="15" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="34" maxlength="80" class="regularxl">
    </TD>
	</TR>	
	  
	<cfquery name="Mis" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
	</cfquery>
	 
	 <TR>
	 <TD class="labelit" width="150">Entity:&nbsp;</TD>  
	 <TD>
	 	<select name="Mission" id="Mission" class="regularxl">
		<option value="">[Apply to all]</option>
		<cfloop query="Mis">
		<option value="#Mission#" <cfif get.Mission eq mission>selected</cfif>>#Mission#</option>
		</cfloop>
		</select>
	 </TD>
	 </TR>
	
	<TR>
    <TD class="labelit">Reason Status:</TD>
	
	<TD class="labelit">
	    <input type="radio" name="Status" id="Status" value="2i" <cfif get.Status is "2i">checked</cfif>>
		Accept
		<input type="radio" name="Status" id="Status" value="9"  <cfif get.Status is "9">checked</cfif>>
		Deny
    </TD>	


	<TR>
    <TD class="labelit">Include Specification:</TD>
	
	<TD class="labelit">
	    <input type="radio" name="Specification" id="Specification" value="1" <cfif get.IncludeSpecification is "1">checked</cfif>>
		Yes
		<input type="radio" name="Specification" id="Specification" value="0"  <cfif get.IncludeSpecification is "0">checked</cfif>>
		No
    </TD>		
	
	<!--- Field: ListingOrder --->
    <TR>
    <TD class="labelit">Relative&nbsp;Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="Listingorder" value="#get.ListingOrder#" message="Please enter a valid number" validate="integer" required="No" visible="Yes" enabled="Yes" size="3" maxlength="3" class="regularxl">
	</TD>
	</TR>
	
	<TR>
    <TD class="labelit">Operational:&nbsp;</TD>
	
	<TD class="labelit">
	    <input type="radio" name="Operational" id="Operational" value="1" <cfif get.Operational is "1">checked</cfif>>
		Yes
		<input type="radio" name="Operational" id="Operational" value="0"  <cfif get.Operational is "0">checked</cfif>>
		No
    </TD>	
		
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	
    	<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	
	</td>
	</tr>
	
</TABLE>
		
</CFFORM>

</BODY></HTML>
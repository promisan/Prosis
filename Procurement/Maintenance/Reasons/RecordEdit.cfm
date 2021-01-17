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

<table width="92%" align="center" class="formpadding">

	<tr><td height="5"></td></tr>

    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.Code#" size="15" maxlength="15" class="regularxxl">
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="15" maxlength="15" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="34" maxlength="80" class="regularxxl">
    </TD>
	</TR>	
	  
	<cfquery name="Mis" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
	</cfquery>
	 
	 <TR class="labelmedium2">
	 <TD width="150">Entity:&nbsp;</TD>  
	 <TD>
	 	<select name="Mission" id="Mission" class="regularxxl">
		<option value="">[Apply to all]</option>
		<cfloop query="Mis">
		<option value="#Mission#" <cfif get.Mission eq mission>selected</cfif>>#Mission#</option>
		</cfloop>
		</select>
	 </TD>
	 </TR>
	
	<TR class="labelmedium2">
    <TD>Reason Status:</TD>
	
	<TD>
	    <input class="radiol" type="radio" name="Status" id="Status" value="2i" <cfif get.Status is "2i">checked</cfif>>
		Accept
		<input class="radiol" type="radio" name="Status" id="Status" value="9"  <cfif get.Status is "9">checked</cfif>>
		Deny
    </TD>	


	<TR class="labelmedium2">
    <TD>Include Specification:</TD>
	
	<TD>
	    <input class="radiol" type="radio" name="Specification" id="Specification" value="1" <cfif get.IncludeSpecification is "1">checked</cfif>>
		Yes
		<input class="radiol" type="radio" name="Specification" id="Specification" value="0"  <cfif get.IncludeSpecification is "0">checked</cfif>>
		No
    </TD>		
	
	<!--- Field: ListingOrder --->
    <TR class="labelmedium2">
    <TD>Relative&nbsp;Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="Listingorder" value="#get.ListingOrder#" message="Please enter a valid number" 
		   validate="integer" required="No" visible="Yes" enabled="Yes" size="3" maxlength="3" class="regularxxl">
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Operational:&nbsp;</TD>
	
	<TD>
	    <input class="radiol" type="radio" name="Operational" id="Operational" value="1" <cfif get.Operational is "1">checked</cfif>>
		Yes
		<input class="radiol" type="radio" name="Operational" id="Operational" value="0"  <cfif get.Operational is "0">checked</cfif>>
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
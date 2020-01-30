<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="No" 
			  layout="webapp" 
			  label="Edit Competence" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

 
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Competence 
WHERE CompetenceId = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this record ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- edit form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr>
		<td colspan="2" height="10px">
		</td>
	</tr>
<!--- Field: code --->
	 <cfoutput>
	 <TR>
	 <TD class="labelmedium" height="25px">Code:</TD>  
	 <TD>
	 	<input type="Text" name="CompetenceId" value="#get.CompetenceId#" size="10" maxlength="10"class="regularxl">
		<input type="hidden" name="CompetenceIdOld" value="#get.CompetenceId#" size="10" maxlength="10"class="regular">
	 </TD>
	 </TR>
	 
    <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	  	<input type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
				
    </TD>
	</TR>
	
	<!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a valid number" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl">
				
    </TD>
	</TR>
	
	<!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Category:</TD>
    <TD>
		<cfquery name="Category" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_CompetenceCategory
		</cfquery>
		
 		<cfselect name="CompetenceCategory" id="CompetenceCategory" class="regularxl" message="Please select a category" required="Yes">
		  <cfloop query="Category">
			<option value="#Code#" <cfif Code eq get.CompetenceCategory>selected</cfif>>#Description#</option>
		  </cfloop>
		</cfselect>
				
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" class="radiol" name="Operational" value="0" <cfif "0" eq "#get.Operational#">checked</cfif>> Disabled
		<INPUT type="radio" class="radiol" name="Operational" value="1" <cfif "1" eq "#get.Operational#">checked</cfif>> Enabled
	</TD>
	</TR>
	
</cfoutput>

	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="3"></td></tr>


	<tr><td colspan="2" align="center">
	<input class="button10g" style="width:100px" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" style="width:100px" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" style="width:100px" type="submit" name="Update" value=" Update ">
	</td></tr>
    	
</TABLE>

</CFFORM>


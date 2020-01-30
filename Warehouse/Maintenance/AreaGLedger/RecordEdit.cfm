<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AreaGLedger
	WHERE  Area = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	Area
      FROM  	ItemGLedger
      WHERE 	Area  = '#URL.ID1#'
	  UNION
      SELECT 	Area
      FROM  	Ref_TransactionType
      WHERE 	Area  = '#URL.ID1#'
    </cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  label="Area GLedger" 
			  option="Area GLedger Maintenance [#get.Area#]" 
			  scroll="Yes"
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium">
    <TD width="20%"><cf_tl id="Code">:</TD>
    <TD>
	   <!--- <cfif CountRec.recordcount eq "0">	
		   	<cfinput type="Text" name="Code" value="#get.Area#" message="Please enter a code" required="Yes" size="10" maxlength="20" class="regular">
	   <cfelse> --->
	   		#get.Area#
			<input type="hidden" name="Code" id="Code" value="#get.Area#">
	   <!--- </cfif> --->
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Area#">
    </TD>
	</TR>
	
	 <TR class="labelmedium">
    <TD><cf_tl id="Description">:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD><cf_tl id="Order">:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#" message="Please enter a numeric listing order" required="Yes" size="1" validate="integer" maxlength="3" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<!--- <cfif CountRec.recordcount eq "0"><input class="button10g" type="submit" style="width:80" name="Delete" value="Delete" onclick="return ask()"></cfif>	 --->
    <input class="button10g" type="submit" style="width:120" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>

	
</TABLE>

</CFFORM>	

<cf_screenbottom layout="webapp">
	
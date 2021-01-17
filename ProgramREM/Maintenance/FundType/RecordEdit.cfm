<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Edit" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_FundType
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Fund Type?")) {	
	return true 	
	}	
	return false	
}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="95%" align="center" class="formpadding">

    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="10" maxlength="10" class="regularxxl">
	   <input type="hidden" name="Codeold" value="#get.Code#" size="10" maxlength="10"class="regular">
    </TD>
	</TR>
	
    <TR class="labelmedium2">
    <TD>Name:</TD>
    <TD>
  	   <cfinput type="text" name="description" value="#get.description#" message="Please enter a name" required="Yes" size="20" maxlength="50" class="regularxl">
    </TD>
	</TR>
		
	<TR class="labelmedium2">
    <TD>Listing Order:</TD>
    <TD>
	
  	   <cfinput type="Text"
      	   name="ListingOrder"
	       value="#get.ListingOrder#"
    	   validate="integer"
	       required="No"
	       visible="Yes"
	       enabled="Yes"
	       size="1"
	       maxlength="2"
	       class="regularxxl">
	  
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>		
	<td colspan="2" height="35" align="center">
	
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
		
		<cfquery name="get" 
	      datasource="AppsProgram" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT *
	      FROM Ref_Fund
	      WHERE FundType  = '#get.code#' 
	    </cfquery>
		
		<cfif get.recordcount eq "0">	
		    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
		</cfif>		
	    <input class="button10g" type="submit" name="Update" value="Update">
	
	</td>	
	
</TABLE>
	
</CFFORM>


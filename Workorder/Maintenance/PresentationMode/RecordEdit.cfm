<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_PresentationMode
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	PresentationMode
      FROM  	ServiceItemUnit
      WHERE 	PresentationMode  = '#URL.ID1#' 	  
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
			  label="Presentation Mode" 			 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding formspacing">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium2">
    <TD  width="20%">Code:</TD>
    <TD>
	   <cfif CountRec.recordcount eq "0">	
		   	<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="20" maxlength="10" class="regularxxl">
	   <cfelse>
	   		#get.Code#
			<input type="hidden" name="Code" id="Code" value="#get.Code#">
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="30" 
	     class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#" message="Please enter a numeric listing order" required="Yes" size="2"
	      validate="integer" maxlength="3" class="regularxxl">
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<cfif CountRec.recordcount eq "0"><input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>	
    <input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>

</TABLE>

</CFFORM>	

<cf_screenbottom layout="webapp">
	
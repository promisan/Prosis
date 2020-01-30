<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="UoM" 
			  option="Maintaing UoM - #url.id1#" 
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_UoM
	WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this UoM?")) {	
	return true 	
	}	
	return false	
}	

</script>


<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <input type="text"   name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20"class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Description" 
		   value="#get.Description#" 
		   message="please enter a description" 
		   requerided="yes" 
		   size="30" 
	       maxlength="50" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">  	   
	   <cfinput type="Text" 
	   			name="ListingOrder" 
				id="ListingOrder" 
				value="#get.ListingOrder#" 
				message="Please enter a valid Listing Order" 
				required="Yes" 
				size="2"
				maxlength="3" 
				range="0,999" 
				class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="6"></td></tr>	
		
	<cfquery name="check" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
     	SELECT TOP 1 UoMCode
	    FROM   ItemUoM
	    WHERE  UoMCode  = '#url.id1#' 
    </cfquery>
			
	<tr>
		
	<td align="center" colspan="2">	
	    <cfif check.recordcount eq "0">
	    <input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
		</cfif>
    	<input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	</tr>
	
</table>

</cfform>
	
<cf_screenbottom layout="innerbox">

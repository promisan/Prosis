<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Object Usage" 
			  option="Maintaing Object Usage" 
			  banner="yellow"
  			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ObjectUsage
		WHERE 	Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 ObjectUsage
		FROM 	Ref_Object
		WHERE 	ObjectUsage  = '#URL.ID1#' 
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this object usage?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>


<!--- edit form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
		<cfif CountRec.recordCount eq 0>
  	   		<cfinput type="text" name="code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
		<cfelse>
		   <input type="hidden" name="Code" id="Code" value="#get.Code#">
			#get.Code#
		</cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Name:</TD>
    <TD class="regular">
	   <cfinput type="text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="35" maxlength="50" class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td height="6"></td></tr>
	
			
	<tr>
		
	<td align="center" colspan="2">	
	
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<cfif CountRec.recordCount eq 0>
    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	</cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	</tr>
	
	</CFFORM>
	
</TABLE>
	
<cf_screenbottom layout="innerbox">

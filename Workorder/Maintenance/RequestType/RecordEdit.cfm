<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Request
	WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Relationship ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  label="Request Type" 
			  layout="webapp" 
			  user="No" 
			  line="No"
			  banner="gray"
			  option="Service request type" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<table width="95%" cellspacing="4" cellpadding="4" align="center">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.Code#" size="10" maxlength="20" class="regularxl">
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelit">Descriptive:</TD>
    <TD>
  	   <input type="text" name="Description" id="Description" value="#get.Description#" size="30" maxlength="50" class="regularxl">
	   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Handling:</TD>
    <TD>
	
		<select name="TemplateApply" id="TemplateApply" class="regularxl">
				    
			<option value="RequestApplyService.cfm" <cfif get.templateApply eq "RequestApplyService.cfm">selected</cfif>>New Service/Change in service provisioning</option>
			<option value="RequestApplyAmendment.cfm" <cfif get.templateApply eq "RequestApplyAmendment.cfm">selected</cfif>>Amended Service Consumption (Unit,User) / Porting</option>
			<option value="RequestApplyTermination.cfm" <cfif get.templateApply eq "RequestApplyTermination.cfm">selected</cfif>>Termination of Service</option>
			<option value="" <cfif get.templateApply eq "">selected</cfif>>Other, such as equipment changes</option>
		
		</select>
		
	  </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" style="width:90" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
		
	<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT TOP 1 RequestType
      FROM  Request
      WHERE RequestType = '#URL.ID1#' 
    </cfquery>

	<cfif CountRec.recordcount eq "0">
	
    <input class="button10g" type="submit" style="width:90" name="Delete" id="Delete" value="Delete" onclick="return ask()">
	
	</cfif>
	
    <input class="button10g" type="submit" style="width:90" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>
	
</CFFORM>
	
</TABLE>

<cf_screenbottom layout="webapp">
	
<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_TaskOrderAction
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	ActionCode
      FROM  	RequestTaskAction
      WHERE 	ActionCode  = '#URL.ID1#' 	  
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
			  label="Task Order Action" 
			  option="Task Order Action Maintenance [#get.Description#]" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelit" width="30%">Code:</TD>
    <TD>
	   <cfif CountRec.recordcount eq "0">	
		   	<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
	   <cfelse>
	   		#get.Code#
			<input type="hidden" name="Code" id="Code" value="#get.Code#">
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelit">Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<tr>
		<td class="labelit">Mode of shipment:</td>
		<td>
			<cfquery name="lookup" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM   	Ref_ShipToMode
				ORDER BY ListingOrder
			</cfquery>
			
			<select name="ShipToMode" id="ShipToMode" class="regularxl">
				<cfloop query="lookup">
					<option value="#Code#" <cfif code eq get.shipToMode>selected</cfif>>#Description#
				</cfloop>
			</select>
			
		</td>
	</tr>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#"
	       message="Please enter a numeric listing order" required="Yes" size="1" 
		   validate="integer" maxlength="3" 
		   class="regularxl" 
		   style="text-align:center;">
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<cfif CountRec.recordcount eq "0">
	<input class="button10g" type="submit" style="width:120" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>	
    <input class="button10g" type="submit" style="width:120" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>	
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
	
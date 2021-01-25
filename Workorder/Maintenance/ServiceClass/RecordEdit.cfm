<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Service Class" 			  
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#"> 

<cfquery name="Get" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ServiceItemClass
	WHERE 	Code = '#URL.ID1#'
</cfquery>

<cfquery name="VerifyDeleteUpdate" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM     ServiceItem
    WHERE    ServiceClass = '#URL.ID1#'
 </cfquery>
 
<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<!--- edit form --->

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">
	
<table width="94%" align="center" class="formpadding">
		
	 <tr><td></td></tr>	
	 <cfoutput>
	 <TR class="labelmedium2">
	 <TD class="labelmedium2">Code:</TD>  
	 <TD>
	 	<cfif VerifyDeleteUpdate.recordCount eq 0>
		 	<cfinput type="Text" name="Code" value="#get.Code#" size="20" message="Please enter a code" required="Yes" maxlength="10" class="regularxl">
		<cfelse>
			#get.Code#
			<input type="hidden" name="Code" id="Code" value="#get.Code#">
		</cfif>
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR class="labelmedium2" valign="top">
    <TD class="labelit">Description:</TD>
    <TD>
		<cf_LanguageInput
			TableCode		= "ServiceItemClass"
			Mode            = "Edit"
			Name            = "Description"
			Id              = "Description"
			Type            = "Input"
			Value			= "#get.Description#"
			Key1Value       = "#get.Code#"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "100"
			Size            = "30"
			Class           = "regularxxl">
    </td>
	</tr>
	

	 <!--- Field: Listing Order --->
    <TR class="labelmedium2">
    <TD>Listing Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a numeric Listing Order" required="Yes" size="2" maxlength="3" validate="integer" class="regularxxl">
				
    </TD>
	</TR>
	
	<tr class="labelmedium2">
		<td>Operational:</td>
		<td colspan="3">
		<input type="radio" class="radiol" name="operational" id="operational" value="0" <cfif get.operational eq "0">checked</cfif>>No
		<input type="radio" class="radiol" name="operational" id="operational" value="1" <cfif get.operational eq "1">checked</cfif>>Yes
		</td>
	</tr>	
			
	
	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">	
	<cfif VerifyDeleteUpdate.recordCount eq 0><input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()"></cfif>
	<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">	
	</td></tr>
	
</cfoutput>
    	
</TABLE>

</CFFORM>

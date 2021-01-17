<cfparam name="url.idmenu" default="">

<cfset vOption = "Add Address Type">
<cfset vBanner = "Blue">
<cfif url.id1 neq "">
	<cfset vOption = "Maintain Address Type">
	<cfset vBanner = "Yellow">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Address Type" 			  
			  banner="#vBanner#"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_AddressType
		<cfif url.id1 neq "">
			WHERE Code = '#URL.ID1#'
		<cfelse>
			WHERE 1=0
		</cfif>
</cfquery>

<cfajaximport tags="cfform">

<cfoutput>

	<script>
	
	function ask() {
		if (confirm("Do you want to remove this address type?")) {	
			ptoken.navigate('RecordPurge.cfm?idmenu=#url.idmenu#&id1=#url.id1#','submitDelete');
			return true;
		}	
		return false;
	}	
			
	function selectEntity(m,c) {
		var vControl = document.getElementById('mission_'+m);
		var vTdControl = document.getElementById('td_'+m);
		
		if(vControl.checked) {
			vTdControl.style.backgroundColor = c;
		}else{
			vTdControl.style.backgroundColor = '';
		}
	}
	
	</script>
	
</cfoutput>

<!--- edit form --->

<cf_divscroll>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#" method="POST" name="dialog">
	
<table width="94%" class="formpadding formspacing" align="center">
	
	<tr><td height="10" id="submitDelete"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="labelmedium2">
		<cfif url.id1 neq "">
			#get.code#
		<cfelse>
			<cfinput type="text" 
		       name="Code" 
			   value="#get.Code#" 
			   message="Please enter a valid code" 
			   required="yes" 
			   size="20" 
		       maxlength="20" 
			   class="regularxxl">
		</cfif>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium2">
  	   
	    <cfinput type="text" 
	       name="Description" 
		   value="#get.Description#" 
		   message="Please enter a valid description" 
		   required="yes" 
		   size="30" 
	       maxlength="50" 
		   class="regularxxl">
		   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Selfservice:</TD>
    <TD class="labelmedium2">
  	   
	    <input type="Checkbox" class="radiol" style="width:18px;height:18px" id="selfservice" name="selfservice" <cfif get.selfservice eq 1>checked</cfif>>
		   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Order:</TD>
    <TD class="labelmedium2">
  	   
	    <cfinput type="text" 
	       name="ListingOrder" 
		   value="#get.listingorder#" 
		   message="Please enter a valid numeric order" 
		   validate="integer" 
		   required="yes" 
		   size="2" 
	       maxlength="3" 
		   class="regularxxl" 
		   style="text-align:center;">
		   
    </TD>
	</TR>
	
	<cfif url.id1 neq "">
	<TR>
    <TD class="labelmedium2" style="height:25px">Entities:</TD>
	</tr>
	<tr>
    <TD colspan="2" class="labelmedium" style="padding-left:5px">
	    <cfdiv id="divMissions" bind="url:AddressTypeMissionSelect.cfm?idmenu=#url.idmenu#&id1=#url.id1#">
    </TD>
	</TR>
	</cfif>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>	
	<tr><td colspan="2" class="linedotted"></td></tr>	
		
	<tr>
		
	<td align="center" colspan="2">
		<cfif url.id1 neq "">
			<cfquery name="Validate" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	Created
				FROM 	OrganizationAddress
				WHERE	AddressType = '#URL.ID1#'
				UNION ALL
				SELECT 	Created
				FROM	Employee.dbo.PersonAddress
				WHERE	AddressType = '#URL.ID1#'
			</cfquery>
			<cfif Validate.recordCount eq 0>
				<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
			</cfif>
		</cfif>	
    	<input class="button10g" type="submit" name="Save" id="Save" value="Save">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>

</cf_divscroll>
	
<cf_screenbottom layout="innerbox">

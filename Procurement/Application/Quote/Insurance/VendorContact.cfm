<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfif url.orgunit eq "">

<tr><td align="center">No vendor defined</td></tr>

<cfelse>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Nation
</cfquery>

<cfquery name="Address" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT top 1 *
    FROM vwOrganizationAddress
	WHERE OrgUnit = '#url.orgunit#'
	AND   AddressType = 'Office'
</cfquery>

<cfif Address.recordcount eq "0">
	
	<cf_assignid>
	
	<cftransaction>
	
		<cfquery name="Address" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO System.dbo.Ref_Address (AddressId,AddressScope,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES
			('#rowguid#','Quote','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
		</cfquery>	
			
		<cfquery name="Address" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO OrganizationAddress
			(AddressId,OrgUnit,AddressType,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES
			('#rowguid#','#url.orgunit#','Office','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
		</cfquery>		
	</cftransaction>	
		
	<cfquery name="Address" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT top 1 *
	    FROM   vwOrganizationAddress
		WHERE  OrgUnit = '#url.orgunit#'
		AND    AddressType = 'Office'
	</cfquery>
	
	<input type="hidden" name="AddressId" id="AddressId" value="<cfoutput>#rowguid#</cfoutput>">
	
<cfelse>

	<input type="hidden" name="AddressId" id="AddressId" value="<cfoutput>#Address.AddressId#</cfoutput>">  	

</cfif>

	
<cfoutput>	
	<TR class="labelmedium">
    <TD><cf_tl id="Address">:</TD>
    <TD>
	   	<cfinput class="regularxl" style="90%" type="Text" name="Address1" value="#Address.Address1#" message="Please enter an address" required="Yes" size="60" maxlength="100">	   
	</TD>
	</TR>
	
	<TR class="hide">
    <TD><cf_tl id="Address 2">:</TD>
    <TD>
	   	<input class="regularxl" type="Text" name="Address2" id="Address2" value="#Address.Address2#" size="60" maxlength="100">
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Postal code">:</TD>	
    <TD>		
		   	<input class="regularxl" type="Text" value="#Address.PostalCode#" name="PostalCode" id="PostalCode" size="15" maxlength="10">
	 	</td>
	</tr>
	
	<tr class="labelmedium">	
		<TD><cf_tl id="City">:</TD>
		<td>
		   	<cfinput class="regularxl" type="Text" name="City" value="#Address.City#" message="Please enter an city" required="Yes" size="30" maxlength="40">
		</td>	
		
	</TR>
	
	<TR class="labelmedium">
    <TD>&nbsp;&nbsp;<cf_tl id="State">/<cf_tl id="Province">:</TD>
    <TD>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr><td>		   	
		 	<input class="regularxl" type="Text" value="#Address.State#" name="State" id="State" size="20" maxlength="20">
 		</td>
		<TD class="labelit" width="90" style="padding-left:14px;padding-right:4px"><cf_tl id="Country"></TD>
		<td>
		 	<select name="Country" style="width:200px"required="No" class="regularxl">
		    <cfloop query="Nation" >
			<option value="#Code#" <cfif Address.Country eq Code>selected</cfif>>#Name#</option>
			</cfloop>
		</td>	
		</table>   
	</TD>
	</TR>	
		
    <TR class="labelmedium">
    <TD><cf_tl id="Representative">:</TD>
    <TD>
		<table cellspacing="0" cellpadding="0">
		
		<tr><td>
		 <input type="Text" name="Contact" id="Contact" value="#Address.Contact#" size="30" maxlength="40" class="regularxl">
		</td>
		<td class="labelit">&nbsp;&nbsp;<cf_tl id="DOB">:</td>
		
		<td>
		
			<cf_intelliCalendarDate9
				FieldName="ContactDOB" 
				Default="#DateFormat(Address.ContactDOB, '#CLIENT.DateFormatShow#')#"
				AllowBlank="True"
				Class="regularxl">
				
		</td>
		
		</tr>
		</table>
	
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Id">:</TD>
    <TD>
	<table cellspacing="0" cellpadding="0">
	<tr><td>
		<input type="Text" name="ContactId" id="ContactId" value="#Address.ContactId#" size="15" maxlength="20" class="regularxl">		
    	</TD>
	    <TD width="90" class="labelit" style="padding-left:4px"><cf_tl id="Profession">:</TD>
	    <TD><input type="Text" name="Remarks" id="Remarks" value="#Address.Remarks#" size="30" maxlength="40" class="regularxl">		
		</TD>
	</TR>
	</table>
	</td>
	
	<TR class="labelmedium">
    <TD>- <cf_tl id="Fiscal No">:</TD>
    <TD><input type="Text" name="FiscalNo" id="FiscalNo" size="20" maxlength="20" class="regularxl" value="#Address.FiscalNo#"> 
	</TD>
	</TR>
	
    <TR class="labelmedium">
    <TD>- <cf_tl id="Telephone">:</TD>
    <TD><table cellspacing="0" cellpadding="0">
	    <tr><td>
		 		<input type="Text" name="TelephoneNo" id="TelephoneNo" value="#Address.TelephoneNo#" size="10" maxlength="20" class="regularxl"> 
			</td>
			<TD class="labelit">&nbsp;&nbsp;<cf_tl id="Mobile">:&nbsp;</TD>
			<TD>
			   	<input type="Text" name="MobileNo" id="MobileNo" value="#Address.MobileNo#" size="10" maxlength="20" class="regularxl"> 
			</TD>
			<TD class="labelit">&nbsp;&nbsp;<cf_tl id="Fax">:&nbsp;</TD>
		    <TD>
			   	<input type="Text" name="FaxNo" id="FaxNo" value="#Address.Faxno#" size="10" maxlength="20" class="regularxl"> 
			</TD>			
		</tr>
		</table>
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>- <cf_tl id="eMail">:</TD>
    <TD class="labelit">
		<cf_tl id="Please enter a valid eMail address" class="text" var="1">
		<cfset vMsg=#lt_text#>		
	   	<cfinput type="Text" name="emailaddress" value="#Address.emailaddress#" validate="email" message="#vMsg#" required="No" size="50" maxlength="50" class="regularxl"> 
	</TD>
	</TR>
			
</cfoutput>	
	
</cfif>
	
		
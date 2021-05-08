<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="URL.scope"  default="backoffice"> 
<cfparam name="url.header" default="1">

<cf_dialogstaffing>

<cf_screentop height="100%" scroll="Yes" html="No">

<cfif url.header eq "1">

<table width="100%" align="center">

	<tr><td>
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</td></tr>
	
</table>
	
	<cfoutput>
	
	<cfset root = "#SESSION.root#">
	
		<script language="JavaScript">
		
		function address(persno) {
		    ptoken.location('AddressEntry.cfm?ID=' + persno)
		}
		
		</script>
	
	</cfoutput>

</cfif>

<!--- Query returning search results --->

<cfquery name="Search" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   A.*, B.Name, R.Description
FROM     vwOrganizationAddress A 
         INNER JOIN Ref_AddressType R ON A.AddressType = R.Code 
		 LEFT OUTER JOIN System.dbo.Ref_Nation B
  ON     A.Country = B.Code
WHERE    OrgUnit = '#URL.ID#'
<cfif url.scope neq "Backoffice">
AND      Selfservice = 1
</cfif>
ORDER BY R.ListingOrder ASC
</cfquery>
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
  <tr>
    <td height="35"><font face="Verdana" size="2">&nbsp; <cf_tl id="Contact"> / <cf_tl id="Address"></b></font></td>
    <td align="right">
	
	<cfif url.scope eq "backoffice">
	
	    <cfoutput>
		 
		 <cfinvoke component="Service.Access" 
		      method="org"  
			  orgunit="#URL.ID#" 
			  returnvariable="access">
			  
		      <cfif access eq "EDIT" or access eq "ALL">	
			  		<cf_tl id="Add" var="vAdd">
					<input type="button" value="#vAdd#" class="button10g" onClick="address('#URL.ID#')">
			  </cfif> 
			  
		</cfoutput>
		
	</cfif>	
    </td>
   </tr>
   <tr>
   
  <td width="100%" colspan="2">
  
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
  
  <tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr> 
	
  <TR bgcolor="f3f3f3">
    <td width="3%"></td>
    <td width="20%"><cf_tl id="Address Type"></td>
	<TD width="20%"><cf_tl id="Contact"></TD>
	<cfif URL.scope neq "Portal">
		<TD width="30%"><cf_tl id="Address"></TD>
	<cfelse>
		<td></td>
	</cfif>
	<TD width="15%"><cf_tl id="City"></TD>
	<TD width="15%"><cf_tl id="Country"></TD>
	
  </TR>
  
   <tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr> 
	  
	<cfset last = '1'>
	
	<cfif Search.recordcount eq "0">
	
		<tr><td colspan="6" height="30" align="center">There are no address/contact records to show in this view</td></tr>
	
	</cfif>
	
	<cfoutput query="Search">
	
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
	<td align="center" rowspan="2" height="23" width="30">
	
		<cfinvoke component="Service.Access" 
		      method="org"  
			  orgunit="#URL.ID#" 
			  returnvariable="access">
		
		<cfif url.scope eq "backoffice" AND (access eq "EDIT" or access eq "ALL")>
	    <a href="AddressEdit.cfm?ID=#URL.ID#&ID1=#AddressId#">
		
		 <img src="#SESSION.root#/Images/address.gif" alt="" name="img0_#currentrow#" 
			  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/address.gif'"
			  style="cursor: pointer;" alt="" width="13" height="13" border="0" align="absmiddle">
			  
		</a>
		</cfif>
		
	</td>	
	<td rowspan="2">&nbsp;#Description#</td>
	<TD><cfif PersonNo neq "" and url.scope eq "backoffice">
	<a href="javascript:EditPerson('#PersonNo#')"><font color="0080FF"></cfif>#Contact#</a>
	</TD>
		<cfif url.scope neq "Portal">
		<td>#City# [#PostalCode#]</td>
		<cfelse>
		<td></td>
		</cfif>
	<td>#Address1#</td>
	<td>#Name#</td>
	
	</TR>
	<cfif Address2 neq "">
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
	<td colspan="2"></td>
	<td colspan="4" align="left" class="regular">#Address2#
	</td>
	</cfif>
	
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
	
	    <td></td>
		<td colspan="5" align="left"><font face="Verdana" size="1">
		<cfif TelephoneNo is not "">
		  <font face="Verdana" size="1">Tel:<font face="Verdana" size="2" color="6688aa"> <b>#TelephoneNo# &nbsp;&nbsp;</font></b>
		</cfif>
		<cfif FaxNo is not "">
		  <font face="Verdana" size="1">Fax:<font face="Verdana" size="2"> #FaxNo#&nbsp;&nbsp;</font>
		</cfif>
		<cfif eMailAddress is not "">
		  <font face="Verdana" size="1">eMail:<font face="Verdana" size="2"> <b><a href="mailto:#eMailAddress#">#eMailAddress#</a></b></font>
		</cfif>		
		</td>
		
	</TR>
	<tr><td colspan="6" bgcolor="silver"></td></tr>
	</cfoutput>

</TABLE>

</td>

</table>
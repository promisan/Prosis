<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!--- Query returning search results --->

<cfparam name="URL.AddressType" default="">

<cfquery name="Search" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     vwOrganizationAddress A LEFT OUTER JOIN System.dbo.Ref_Nation B
	  ON     A.Country = B.Code
	WHERE OrgUnit = '#URL.OrgUnit#'
	<cfif url.addresstype neq "">
	AND A.AddressType = '#URL.addresstype#'
	</cfif>
	ORDER BY AddressType DESC
</cfquery>

	
<table width="100%" border="0" frame="hsides" cellspacing="0" cellpadding="0" bordercolor="#C0C0C0" rules="rows">
  
  <tr>
  <td width="100%" colspan="2">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
	
	<cfif Search.recordcount eq "0">
	
		<cfif url.orgunit neq "">
		<tr><td colspan="6" align="center"><font color="FF8040">No address information available (<cfoutput>#URL.Addresstype#</cfoutput>)</td></tr>
		</cfif>
		
	<cfelse>	
	
		<TR bgcolor="f8f8f8">
		    <td width="5%"></td>
		    <td width="10%">Type</td>
			<TD width="40%">Address</TD>
			<TD width="15%">City</TD>
			<TD width="15%">Country</TD>
			<TD width="15%">Contact</TD>
		</TR>
			  
		<cfoutput query="Search">
			
			<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
				<td align="center">
					
					<!--- maintain option 
				    <a href="AddressEdit.cfm?ID=#URL.ID#&ID1=#AddressId#">
					 <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#currentrow#" 
						  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/view.jpg'"
						  style="cursor: pointer;" alt="" width="14" height="14" border="0" align="middle">
					</a>
					--->
					
				</td>	
				<td>#AddressType#</td>
				<td>#Address1#</td>
				<td>#City# [#PostalCode#]</td>
				<td>#Name#</td>
				<TD>#Contact# </TD>
			</TR>
			
			<cfif Address2 neq "">
				<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
				<td colspan="2"></td>
				<td colspan="4" align="left" class="regular">#Address2#
				</td>
				</tr>
			</cfif>
			
			<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
				<td colspan="2"></td>
				<td colspan="4" align="left"><font face="Verdana" size="1">
				<cfif TelephoneNo is not "">
				  <font face="Verdana" size="1">Tel:<font face="Verdana" size="2" color="FF0000"> <b>#TelephoneNo# </b>
				</cfif>
				<cfif FaxNo is not "">
				  <font face="Verdana" size="1">Fax:<font face="Verdana" size="2"> #FaxNo#</font>
				</cfif>
				<cfif eMailAddress is not "">
				  <font face="Verdana" size="1">eMail:<font face="Verdana" size="2"> <b><a href="mailto:#eMailAddress#">#eMailAddress#</a></b></font>
				</cfif>
				
				</td>
			</TR>
		
		</cfoutput>
		
	</cfif>
		
</TABLE>
</td></tr>
</table>
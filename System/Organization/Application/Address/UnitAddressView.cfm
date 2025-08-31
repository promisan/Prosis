<!--
    Copyright © 2025 Promisan B.V.

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
<cfoutput>	

	<cfparam name="url.OrgUnit" default="0">
	<cfparam name="get.OrgUnit" default="#url.orgunit#">
					
	<cfquery name="Address" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    A.*, B.Name, R.Description
		FROM      vwOrganizationAddress A 
		          INNER JOIN Ref_AddressType R ON A.AddressType = R.Code 
				  LEFT OUTER JOIN System.dbo.Ref_Nation B ON A.Country = B.Code
		WHERE     OrgUnit = '#get.orgunit#'
		ORDER BY  AddressType DESC
	</cfquery>
						 
	<table width="98%" align="center" class="navigation_table formpadding">
	
		<tr><td style="height:10px"></td></tr>
	    
		<cfset last = '1'>
		
		<cfif Address.recordcount eq "0">
		
			<tr><td colspan="5" height="30" align="center" class="labelmedium2"><cf_tl id="There are no records to show in this view"></td></tr>
		
		<cfelse>
		
			<TR bgcolor="white" class="line labelmedium2">			    
			    <td width="15%" style="padding-left:4px"><cf_tl id="Type"></td>								
				<TD width="50%"><cf_tl id="Address"></TD>							
				<TD width="20%"><cf_tl id="Contact"></TD>
				<TD width="15%"><cf_tl id="Phone"></TD>						
		   </TR>		   
	  		
		<cfloop query="Address">
		
			<TR class="<cfif Address2 eq "">line</cfif> labelmedium2 navigation_row">
			
				<td style="height:20px;padding-left:4px">#Description#</td>			
				<td>#Address1# <cfif city neq "" and city neq address1>#City#</cfif> <cfif postalcode neq "">[#PostalCode#]</cfif>, #Name#</td>										
				<TD>#Contact# <cfif eMailAddress is not ""><a href="mailto:#eMailAddress#">#eMailAddress#</a></cfif></TD>			
				<td>#TelephoneNo# <cfif FaxNo is not ""><cf_tl id="Fax">:#FaxNo#</cfif></td>			
			
			</TR>
			
			<cfif Address2 neq "">
				<TR class="labelmedium2 line navigation_row_child">
				<td colspan="1"></td>
				<td colspan="3" align="left">#Address2#
				</td>
			</cfif>
						
								
		</cfloop>
		
		</cfif>
	
	</TABLE>
	
</cfoutput>	

<cfset ajaxonload("doHighlight")>
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
<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="URL.scope"  default="backoffice"> 
<cfparam name="url.header" default="1">
<cfparam name="url.html"   default="No">
<cfparam name="url.closeAction" default="">

<cf_dialogstaffing>

<cfif url.closeAction eq "">
	<cf_screentop height="100%" scroll="Yes" html="#url.html#" layout="webapp" banner="gray" jquery="Yes" label="Edit Address">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" html="#url.html#" layout="webapp" banner="gray" jquery="Yes" label="Edit Address" close="#url.closeAction#">
</cfif>

<cfif url.header eq "1">

<table width="96%" height="100%" align="center">

<tr><td style="height:10px" colspan="2">
	
  <cfif URL.scope eq "Portal">
  
  	<cf_tableround mode="solidcolor" color="f0f0f0">
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</cf_tableround>
	
  <cfelse>
    
  	<cfinclude template="../UnitView/UnitViewHeader.cfm">
	
  </cfif>
		
	</td></tr>	
	
	<cfoutput>
	
	<cfset root = "#SESSION.root#">
	
		<script language="JavaScript">
		
		function address(persno) {
		   ptoken.location("AddressEntry.cfm?ID=" + persno +"&html=#url.html#&closeAction=#url.closeAction#&systemfunctionid=#url.systemfunctionid#");
		}
		
		function edit(id,id1) {
			ptoken.location("AddressEdit.cfm?ID="+id+"&ID1="+id1+"&header=No&html=#url.html#&closeAction=#url.closeAction#&systemfunctionid=#url.systemfunctionid#");
		}	
		
		</script>
	
	</cfoutput>

</cfif>

<!--- Query returning search results --->


<cfoutput>
<cfsavecontent variable="address">
SELECT        S.OrgUnit, S.AddressId, 
              S.AddressType, S.TelephoneNo, S.MobileNo, S.FaxNo, S.eFaxNo, S.FiscalNo, S.webURL, S.MarkerIcon, S.MarkerColor, S.PersonNo, S.Contact, S.ContactDOB, 
              S.ContactId, S.Operational, S.OfficerUserId, S.OfficerLastName, S.OfficerFirstName, S.Created, 
			  A.AddressScope, A.Address AS Address1, A.Address2, A.AddressCity as City, A.AddressRoom, 
              A.AddressPostalCode as PostalCode, A.State, A.Country, A.Coordinates, A.eMailAddress, A.Source, A.Remarks
FROM          dbo.OrganizationAddress AS S INNER JOIN
              System.dbo.Ref_Address AS A ON S.AddressId = A.AddressId
</cfsavecontent>
</cfoutput>

<cfquery name="Search" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*, B.Name, R.Description
	FROM     (#address#) A 
	         INNER JOIN Ref_AddressType R ON A.AddressType = R.Code 
			 LEFT OUTER JOIN System.dbo.Ref_Nation B ON  A.Country = B.Code
	WHERE    OrgUnit = '#URL.ID#'
	<cfif url.scope neq "Backoffice">
	AND      Selfservice = 1
	</cfif>
	ORDER BY A.Operational DESC, R.ListingOrder ASC
</cfquery>

<cfif url.systemfunctionid neq "">

	<!--- we check the access the person has based on the conditions set for accessing this module function and
	see if the access of the person is for > level 1 --->
		
	<cfinvoke component="Service.Access" 
	      method="systemfunctionidaccess"  
		  systemfunctionid="#url.systemfunctionid#" 
		  mission="#org.Mission#"
		  returnvariable="access">		
		
<cfelse>

	<cfinvoke component="Service.Access" 
      method="org"  
	  orgunit="#URL.ID#" 
	  returnvariable="access">
	  
</cfif>	  

  <tr style="height;10px">
    <td valign="middle" style="height:45" class="labellarge"><cf_tl id="Contact"> / <cf_tl id="Address"></td>
    <td align="right">
	
	<cfif url.scope eq "backoffice">
	
	    <cfoutput>	
			  
		      <cfif access eq "EDIT" or access eq "ALL">	
			  	 	<cf_tl id="Add" var="vAdd">
					<input type="button" value="#vAdd#" class="button10g" onClick="address('#URL.ID#')">
			  </cfif> 
			  
		</cfoutput>
		
	</cfif>	
    </td>
   </tr>
 
  <tr>
   
  <td align="center" colspan="2" style="width:94%;height:100%">
  
  <cf_divscroll>
  
  <table width="100%" class="navigation_table">
	
	  <TR class="line labelmedium2 fixrow">
	    <td width="3%"></td>
	    <td><cf_tl id="Type"></td>
		<cfif url.scope neq "portal">
		<td style="padding-right:10px"><cf_tl id="Color"></td>
		</cfif>
		<TD><cf_tl id="Contact"></TD>
		<TD><cfif URL.scope neq "Portal"><cf_tl id="Address"></cfif></TD>		
		<TD style="width:100px"><cfif URL.scope neq "Portal"><cf_tl id="Created"></cfif></TD>	
	  </TR>
  	  
	<cfset last = '1'>
	
	<cfif Search.recordcount eq "0">
	
		<tr><td colspan="7" style="height:50px" class="labelmedium" align="center"><cf_tl id="There are no records to show in this view" class="message"></td></tr>
	
	</cfif>
	
		<cfoutput query="Search">
				
		<cfif operational eq "0">
		<TR class="labelmedium2 navigation_row" bgcolor="#IIf(CurrentRow Mod 2, DE('FFBBBB'), DE('FFBBBB'))#">
		<cfelse>
		<TR class="labelmedium2 navigation_row" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
		</cfif>
				
		<td align="center" height="20" width="30" style="padding-left:4px;padding-top:1px;padding-right:4px">
							
			<cfif url.scope eq "backoffice" AND (access eq "EDIT" or access eq "ALL")>
			
				<cf_img icon="open" navigation="yes" onclick="javascript:edit('#url.id#','#addressid#')">
				
			</cfif>
			
		</td>	
		
		<td>#Description#</td>
		
		<cfif url.scope neq "portal">
		<td>
			<table border="1" bordercolor="gray" height="14" width="14"><tr><td bgcolor="#markercolor#"></td></tr></table>
		</td>
		</cfif>
		
		<TD>	
		<cfif PersonNo neq "" AND url.scope eq "backoffice">
		<a href="javascript:EditPerson('#PersonNo#')">
		</cfif>
		#Contact#</a>
		</TD>
			
		<td><cfif URL.scope neq "Portal">#Address1# #City# [#PostalCode#] #Name#</cfif></td>		
		<td style="padding-right:3px">
			<cfif URL.scope neq "Portal">
				<cfif operational eq "0">
					<font color="FF0000">
					</cfif>
					#dateformat(Created,client.dateformatshow)#
				
			</cfif>
		</td>
		</tr>
		
		<!---
		
		<cfif URL.scope neq "Portal">	
				
			<cfif Address2 neq "">			
			<TR class="labelmedium2" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
			<td colspan="2"></td>
			<td colspan="4" align="left">#Address2#</td>
			</tr>
			</cfif>
			
		</cfif>
		
		--->
		
		<cfif TelephoneNo is not "" 
		     or FaxNo is not "" 
			 or eFaxNo is not "" 
			 or eMailAddress is not "">
			 
		<cfif operational eq "0">
		<TR class="labelmedium2 navigation_row_child" bgcolor="#IIf(CurrentRow Mod 2, DE('FFBBBB'), DE('FFBBBB'))#">
		<cfelse>
		<TR class="labelmedium2 navigation_row_child" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
		</cfif> 
				
		    <td></td>
			<td colspan="5" align="left">
			
			<table>
				
				<tr class="labelmedium2">			  
				  <cfif TelephoneNo neq "">
				  <td style="font-size:10px"><cf_tl id="Tel">:</td>
				  <td style="padding-left:5px;font-weight:bold">#TelephoneNo#</td>		 				
				  </cfif>
				  <cfif faxNo neq "">
				  <td style="font-size:10px;padding-left:10px"><cf_tl id="Fax">:</td>
				  <td style="padding-left:5px;font-weight:bold">#FaxNo#</td>				
				  </cfif> 
				  <cfif efaxNo neq "">				  
				  <td style="font-size:10px;padding-left:10px"><cf_tl id="eFax">:</td>
				  <td style="padding-left:5px;font-weight:bold">#eFaxNo#</td>
				  </cfif>
				  <td style="font-size:10px;padding-left:10px"><cf_tl id="Mail">:</td>
				  <td style="padding-left:5px;font-weight:bold"><a href="mailto:#eMailAddress#">#eMailAddress#</a></td>
				</tr>
				
			</table>
			
			</td>
			
		</TR>
		
		</cfif>
			
		</cfoutput>

	</TABLE>
	
	</cf_divscroll>

</td>
</tr>

</table>
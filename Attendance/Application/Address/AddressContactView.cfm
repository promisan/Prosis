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
<cfquery name="getAddress" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   vwPersonAddress
	WHERE  PersonNo = '#URL.ID#'
	AND    AddressId = '#URL.ID1#' 
</cfquery>

<cfoutput>
<table width="300" cellspacing="0" cellpadding="0">

<cfquery name="getCountry"
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT * FROM Ref_Nation	
		WHERE  Code = '#getAddress.country#'																											
   	</cfquery>	
	
  
<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Person
	WHERE  PersonNo = '#URL.ID#'	
</cfquery>	

				
<tr class="line labelmedium">
	<td><cf_tl id="Name">:</td>
	<td><a href="javascript:EditPerson('#url.id#')">#Person.FirstName# #Person.LastName# (#Person.Gender#)</a></td>
</tr>
					
<tr class="labelmedium" style="height:22px">
	<td style="min-width:87px"><cf_tl id="Country">:</td>
	<td>#getCountry.Name#</td>
</tr>

<tr class="labelmedium" style="height:22px">
    <td><cf_tl id="City">:</td>
	<td>#getAddress.AddressCity#</td>
</tr>
<tr  class="labelmedium" style="height:22px">
    <td><cf_tl id="Address">:</td>
	<td>#getAddress.Address#</td>
</tr>
<cfif getAddress.Address2 neq "">
	<tr class="labelmedium" style="height:22px">
	<td><cf_tl id="Address">:</td>
	<td>#getAddress.Address2#</td>
	</tr>
</cfif>
<tr class="labelmedium" style="height:22px">
    <td><cf_tl id="Contact">:</td>
</tr>
<tr class="labelmedium" style="height:22px">
    <td><cf_tl id="eMail">:</td>
	<td>#getAddress.eMailAddress#</td>
</tr>

<cfquery name="Contact" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	  
	   SELECT   Description,ContactCallSign as CallSign
	   FROM     PersonAddressContact PC, Ref_Contact P 
	   WHERE    PC.PersonNo  = '#url.id#' 
	   AND      PC.Addressid = '#url.id1#'
	   AND      PC.ContactCode = P.Code        
	   ORDER BY ListingOrder
	</cfquery>	

<cfloop query="Contact">
	<tr class="labelmedium">		
	<td><cf_tl id="#Description#">:</td>				
    <td style="padding-right:16px" class="labelmedium">
		<cfif callsign eq "">n/a<cfelse>#callsign#</cfif>
	</td>
	</tr>	
</cfloop>

<cfparam name="url.webapp"  default="">

<tr><td colspan="2" class="line"></td></tr>

<cfoutput>

<tr><td colspan="2" class="labelmedium"><a href="javascript:personaddress('#URL.ID#','#URL.ID1#','#url.webapp#')"><font color="0080FF">more...</font></a></td></tr>

</cfoutput>

</table>

</cfoutput>
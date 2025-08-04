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

<!--- ADDRESS --->
<!--- *************************************************************************** --->

<cfquery name="Address" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT a.*, r.description as AddressDescription
   	FROM   ApplicantAddress a left outer join Employee.dbo.Ref_AddressType R on a.addresstype = r.addresstype
  	WHERE  PersonNo = '#PHPPersonNo#'
	ORDER BY a.AddressType
</cfquery>

<cfloop query="Address">

	<cfquery name="Address_Country" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT Name
	   	FROM  Ref_Nation
	   	WHERE Code = '#Country#'
		</cfquery>	
			
<table width="100%" border="0" align="center" >
	<cfoutput>	
	<tr><td class="title">#AddressDescription# Address</td></tr>
	<tr><td bgcolor="333333"></td></tr>
	<tr><td>
	<table width="95%" border="0" align="center" >
	<cfif Address.Address1 neq "">
		<tr>
		<td>#Address1#</td>
		</tr>
	</cfif>
	<cfif Address.Address2 neq "">
		<tr>
		<td>#Address2#</td>
		</tr>
	</cfif>
	<td>#City#  #State#  #AddressPostalCode# #Address_Country.name#</td>
	</tr>
	<cfif Address.TelephoneNo neq "">
		<tr>
		<td>Telephone: #TelephoneNo#
		</tr>
	</cfif>
	<cfif Address.FaxNo neq "">
		<tr>
		<td>Fax: #FaxNo#</td>
		</tr>
	</cfif>
	<cfif Address.Contact neq "">
		<tr>
		<td>Contact: #Contact#</td>
		</tr>
	</cfif>

	</table>
	</td></tr>
	</cfoutput>
</table>	
</cfloop>

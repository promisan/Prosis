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
<cfparam name="url.elementid" default="">
<cfparam name="url.forclaimid" default="">

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td height="3"></td></tr>

<tr class="line">
	<td class="line">
		
		<table width="99%" align="center" cellspacing="0" cellpadding="0">				
		<tr><td>
		<cfset key = url.elementid>
		<cfinclude template="../Create/ElementView.cfm">
		</td>
		</tr>		
		</table>
			
	</td>
</tr>	

<tr><td height="3"></td></tr>

<!--- routine to show all relationsships also in the reverse --->
	
<tr>
	<td id="children">	
	
	<cfif url.forclaimid eq "">	
		
		<cfquery name="CaseElement" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT   *
		     FROM     ClaimElement			
			 WHERE    CaseElementId = '#url.caseelementid#'	
		</cfquery>
		
		<cfset url.forclaimid = caseelement.claimid>
	
	</cfif>	
	
	<cfinclude template="AssociationListing.cfm">		
	
	</td>
</tr>	
	
</table>

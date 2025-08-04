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
<cfparam name="first" default="0">
<cfparam name="pages" default="0">
<cfparam name="embed" default="0">
<cfparam name="header" default="1">
<cfparam name="URL.grouping" default="Journal">

<!--- provision --->
<cfif URL.ID eq "PO">
	<cfset url.id = "Journal">
</cfif>

<cfif pages gte "1">

<tr><td colspan="11" class="line"></td></tr>
<tr class="line">
   <td colspan="2" height="20">
		<cfinclude template="Navigation.cfm"> 
   </td>
</tr>

</cfif>

<TR><td colspan="2" valign="top" height="100%">

	<cfif embed eq "0">

		<cf_divscroll>		
		<cfinclude template="TransactionListingLinesContent.cfm">						
		</cf_divscroll>
		
	<cfelse>
	
		<cfinclude template="TransactionListingLinesContent.cfm">	
	
	</cfif>	
	
</td>

</tr>

 <cfif pages gte "1">	

 	 <tr><td colspan="2" class="line"></td></tr>
	 <tr class="line"><td height="14" colspan="2" class="regular">
			<cfinclude template="Navigation.cfm">
	 </td></tr>
	 
 </cfif> 
  
  
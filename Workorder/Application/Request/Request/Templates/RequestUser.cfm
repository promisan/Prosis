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
<cfif url.requestid neq "">

	<cfquery name="User" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT RW.ValueTo   as PersonNoTo
	     FROM   Request RW
		 WHERE  RW.Requestid       = '#url.requestid#'
		 AND    Amendment          = 'PersonNo'			
	 </cfquery>
	 
	 <cfset personno = User.PersonNoTo>
 
<cfelse> 

	 <cfset personno = client.personno>
 
</cfif>

<cfoutput>

<table width="100%">
			
	<tr class="hide"><td id="transferto"></td></tr>		
	
	<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Person
			WHERE   PersonNo = '#personno#'	
	</cfquery>				
	
	<input type="hidden" name="personnoto" id="personnoto" value="#personno#">
			
	<tr><td height="5"></td></tr>
	<tr>
		<td width="80" height="100%"  style="padding:4px">User/Contact:</td>
		<td>
		
		<cfif url.Accessmode eq "Edit">
		
		   <cfset link = "../Templates/RequestTransferTo.cfm?requestid=#url.requestid#">	
	
		   <cf_selectlookup
			    box        = "transferto"
				link       = "#link#"
				button     = "Yes"
				close      = "Yes"						
				icon       = "contract.gif"
				class      = "employee"
				des1       = "PersonNo">			
					
		</cfif>			
		
		</td>
		<td style="padding:4px" id="toname">
		<a href="javascript:EditPerson('#PersonNo#')"><font color="0080FF"><cfif Person.LastName eq "">N/A<cfelse>#Person.FirstName# #Person.LastName#</cfif></a>
		</td>
	</tr>
	<tr>
		<td height="100%" style="padding:4px">IndexNo:</td>
		<td></td>
		<td style="padding:4px" id="toindexno">#Person.IndexNo#</td>
	</tr>
	<tr>
		<td height="100%"  style="padding:4px">Gender:</td>
		<td></td>
		<td style="padding:4px" id="togender">#Person.Gender#</td>
	</tr>
	<tr>
		<td height="100%"  style="padding:4px">Nationality:</td>
		<td></td>
		<td style="padding:4px" id="tonationality">#Person.Nationality#</td>
	</tr>
	
</table>	

</cfoutput>
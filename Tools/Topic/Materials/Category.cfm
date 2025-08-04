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
<cfparam name="url.checked"     default="">

<cfif url.checked neq "">

	<cfif url.checked eq "true">
	
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    	INSERT INTO Ref_TopicCategory 
				(Code,
				 Category,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES(
				'#url.topic#',
				'#url.category#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
							
							
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE FROM Ref_TopicCategory
			WHERE  Code       = '#url.topic#'
			AND    Category   = '#url.category#'
		</cfquery>
		
	</cfif>
	
</cfif>


<cfquery name="Select" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT C.Category, C.Description, EC.Code as Selected
	FROM   Ref_Category C LEFT OUTER JOIN 
	       Ref_TopicCategory EC ON C.Category = EC.Category AND EC.Code = '#url.topic#'
	WHERE  C.Operational = 1	   
	ORDER BY C.TabOrder

</cfquery>

<cfset columns = 4>
<cfset cont    = 0>

<cfoutput>

<table width="100%">
		
	<cfloop query="Select">
	
		<cfif cont eq 0> <tr class="labelmedium"> </cfif>
		<cfset cont = cont + 1>
		
		<td bgcolor="<cfif selected neq "">ffffbf</cfif>">
		 	<input class="radiol" type="checkbox" value="#category#" <cfif Selected neq "">checked="yes"</cfif> 
			 onClick="javascript:ptoken.navigate('#SESSION.root#/Tools/Topic/Materials/Category.cfm?Topic=#URL.Topic#&category=#Category#&checked='+this.checked,'#url.topic#_category')">
		</td>
		<td bgcolor="<cfif selected neq "">ffffbf</cfif>" style="padding-left:3px;">#Description#</td>			
		 
		 <cfif cont eq columns> </tr> <cfset cont = 0> </cfif>
		 
	 </cfloop>
	 
	 <tr class="hide">
	 	<td colspan="#columns#" height="25" align="center">  <cfif url.checked neq "">  <font color="##0080C0"> Saved! <font/> </cfif>  </td>
	 </tr>
	 
</table>

</cfoutput>

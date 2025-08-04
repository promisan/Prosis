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

<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cftry>
	<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_TopicObject
		    (Code,
			 ObjectCode,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
		VALUES
		  ('#URL.Code#',
			'#URL.ObjectCode#',			
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#') 
	</cfquery>
	
	<cfcatch></cfcatch>
	</cftry>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM Ref_TopicObject
	  WHERE  Code      =  '#url.Code#'
	  AND    ObjectCode = '#URL.ObjectCode#'
	</cfquery>
		
</cfif>

<cfquery name="Object" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT M.*
	  FROM   Ref_TopicObject U, Ref_Object M
	  WHERE  U.Code   = '#URL.Code#' 
	  AND    U.ObjectCode = M.Code
	</cfquery>
	
   <table width="99%" align="center" border="0" class="navigation_table">			
    		   
   <cfoutput query="Object">
   
   <tr class="navigation_row labelit linedotted">
   	  <td height="17" width="20">#currentrow#.</td>
      <td width="60">#Code#</td>
	  <td width="80%">#Description#</td>		   
	  <td><cf_img icon="delete" onclick="javascript:ColdFusion.navigate('#SESSION.root#/Tools/Topic/Program/TopicListingClassObject.cfm?action=delete&Code=#URL.Code#&ObjectCode=#Code#','l#url.code#_object')"></td>
   </tr>          
   </cfoutput> 
   
   </table>
      
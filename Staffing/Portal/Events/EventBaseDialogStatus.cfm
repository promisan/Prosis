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


<cfquery name="get" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   PersonEvent
		 WHERE  EventId = '#url.id#'
   </cfquery>	
   
<cfoutput>   

<cfif get.ActionStatus eq "1">
									
	<input type="button" value="Edit" style="width:60px" name="Edit" class="button10g" 
	   onClick="eventedit('#url.id#','inquiry','1')">
								   													
<cfelseif get.ActionStatus eq "3">
									
	    <cfif getAdministrator("#get.mission#")>
												
		<img src="#session.root#/Images/check.png"  title="Completed"
		   alt="" width="25" height="25" border="0">
			
		<cfelse>
		
		<img src="#session.root#/Images/check.png" title="Completed" 
		   alt="" width="25" height="25" border="0">
		</cfif>   
		
	<!--- closed --->		
 </cfif>
 
 </cfoutput>

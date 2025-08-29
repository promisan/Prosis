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
<cfinvoke component      = "Service.Process.Vactrack.Vactrack"  
   method                = "verifyAccess"    
   orgunitadministrative = "0" 
   orgunit               = "#url.orgunit#" 
   mission               = "#url.mission#"
   mandate               = "#url.mandate#"
   posttype              = "#url.postType#"
   returnvariable        = "accessTrack">	 
         
<cfif accessTrack.status eq "0">

	<table><tr class="labelmedium"><td><cfoutput>#accessTrack.reason#</cfoutput></td></tr></table>

<cfelse>  
	
  <cfset list = accesstrack.tracks>
			
  <table>	
   		
		<cfset row = "1">
		<tr>
		<td><cfoutput>#AccessTrack.Owner#</cfoutput><input type="hidden" name="Owner" value="<cfoutput>#AccessTrack.Owner#</cfoutput>">:</td>
		<td><input type="radio" name="EntityClass" class="radiol" value="" checked><td><td stylle="padding-right:4px">N/A</td>
	    <cfoutput query="list">		
			<cfset row = row+1>
			<cfif row eq "1"><tr></cfif>		
			<td>
			<input type="radio" name="EntityClass" class="radiol" value="#EntityClass#">
			</td><td class="labelmedium" style="padding-left:5px">#EntityClassName#</td>
			<cfif row eq "1">
			</tr>
			<cfset row = "0">
			</cfif>
		</cfoutput>
  </table>
  
</cfif>  
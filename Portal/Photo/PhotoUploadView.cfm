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
<cfparam name="url.mode" 		default="user">
<cfparam name="url.destination" default="EmployeePhoto">
<cfparam name="url.style" 		default="">

<cf_assignid>

<cfoutput>

	<cfif url.mode eq "user">
	
		<table style="border:1px solid silver">
			<tr>
				<td align="center">	
						
				 <cfif FileExists("#SESSION.rootDocumentPath#\#url.destination#\#url.filename#.jpg")>	
				 
				 		<cfset myImage=ImageNew("#SESSION.rootDocumentpath#\#url.destination#\#url.filename#.jpg")>
					    <cfimage source="#myImage#" width="200" height="220" action="writeToBrowser">	 
						
						<!---						 		
					  <img src="#SESSION.rootDocument#\#url.destination#\#url.filename#.jpg?id=#rowguid#"
						     alt=""
						     style="height:200px; width:auto; #url.style#"
						     border="0px"
						     align="absmiddle">
							 
							 --->
					 
			  	 <cfelse>		 
						 
					  <img src="#SESSION.root#/Images/Logos/no-picture-male.png" alt="Not found" style="height:200px; width:auto; #url.style#" border="0px" align="absmiddle">
						  
				 </cfif>
				</td>
			</tr>
		</table>	 
		
	<cfelseif url.mode eq "applicant">
	
		<table style="border:1px dotted silver">
			<tr>
				<td align="center">	
						
				 <cfif FileExists("#SESSION.rootDocumentPath#\#url.destination#\#url.filename#.jpg")>	
				 
				 	  <cfset myImage=ImageNew("#SESSION.rootDocumentpath#\#url.destination#\#url.filename#.jpg")>
					  <cfimage source="#myImage#" width="200" height="220" action="writeToBrowser">	 		 
					
					<!---							 		
					  <img src="#SESSION.rootDocument#\#url.destination#\#url.filename#.jpg?id=#rowguid#"
						     alt=""
						     style="height:200px; width:auto; #url.style#"
						     border="0px"
						     align="absmiddle">
							 --->
					 
			  	 <cfelse>		 
						 
					  <img src="#SESSION.root#/Images/Logos/no-picture-male.png" alt="Not found" style="height:200px; width:auto; #url.style#" border="0px" align="absmiddle">
						  
				 </cfif>
				</td>
			</tr>
		</table>
	
	<cfelseif url.mode eq "staffing">

		<cfif FileExists("#SESSION.rootDocumentPath#\#url.destination#\#url.filename#.jpg")>	
		
			<cfset myImage=ImageNew("#SESSION.rootDocumentpath#\#url.destination#\#url.filename#.jpg")>
			<cfimage source="#myImage#" width="200" height="220" action="writeToBrowser">	
	
			<!---
			<img src="#SESSION.rootDocument#/#url.destination#/#url.filename#.jpg?id=#rowguid#"
				alt=""
				style="height:200px; width:auto; display:block; #url.style#"
				border="0px"
				align="absmiddle">
				--->
		
		<cfelse>		 
		
			<img src="#SESSION.root#/Images/no-profile-pic.jpg" alt="Not found" border="0px" align="absmiddle" style="display:block; height:200px; width:auto; #url.style#">
		
		</cfif>
	</cfif>
	
</cfoutput>	 
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
<cfset dateValue = "">
<CF_DateConvert Value="#url.selected#">
<cfset STR = dateValue>

<CF_DateConvert Value="#url.val#">
<cfset END = dateValue>

<cfparam name="session.agentrun" default="">
<cfset prior = session.agentrun>

<cfset session.agentrun = now()>

<cfoutput>

	<cfif STR gt END and url.mde eq "1">
	
		<script>
		 document.getElementById('#url.fld#').value = '#dateformat(STR+1,client.dateformatshow)#'			 	 				 
		</script>
		
					
	</cfif>
		
	<cfif prior eq session.agentrun>
	
	      <!--- nada --->
	
	<cfelse>
		
	<script>			    
		getinformation('#url.id#')
	</script>
	
	</cfif>

</cfoutput>



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

<cfoutput>

<cfif url.field eq "program">

	<cfif action eq "add">

		<cfif url.prior eq "">
			<cfset sel = "'#url.val#'">
		<cfelse>
			<cfset sel = "#url.prior#,'#url.val#'">
		</cfif>
		
	<cfelse>
	
		<cfset sel = replaceNoCase("#url.prior#",",'#url.val#'","")> 
		<cfset sel = replaceNoCase(sel,"'#url.val#'","")> 
		<cfif left(sel,1) eq ",">
			<cfset sel = right(sel,len(sel)-1)>
		</cfif>
		
		<cfif right(sel,1) eq ",">
			<cfset sel = left(sel,len(sel)-1)>
		</cfif>				
				
	</cfif>
	
	<input type="text" id="program" name="program" value="#sel#">	

<cfelseif url.field eq "object">
	
	<cfif action eq "add">

		<cfif url.prior eq "">
			<cfset sel = "'#url.val#'">
		<cfelse>
			<cfset sel = "#url.prior#,'#url.val#'">
		</cfif>
		
	<cfelse>
		
		<cfset sel = replaceNoCase("#url.prior#",",'#url.val#'","")> 
		<cfset sel = replaceNoCase(sel,"'#url.val#'","")> 
		<cfset sel = replaceNoCase(sel,",,",",")> 
		
		<cfif left(sel,1) eq ",">		
			<cfset sel = right(sel,len(sel)-1)>
		</cfif>
				
		<cfif right(sel,1) eq ",">
			<cfset sel = left(sel,len(sel)-1)>
		</cfif>		
		
	</cfif>
	
	<input type="text" id="object" name="object" value="#sel#">	

</cfif>


</cfoutput>

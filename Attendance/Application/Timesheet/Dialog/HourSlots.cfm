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
<cfparam name="attributes.slot"     default="1">
<cfparam name="attributes.hourslots" default="1">
<cfparam name="attributes.icon" default="No">

<cfset hourslots = attributes.hourslots>
<cfset slot      = attributes.slot>

<cfoutput>

<cfswitch expression="#hourslots#">

		<cfcase value="1">														
			00-:59							
		</cfcase>
		
		<cfcase value="2">														
		
			<cfif slot eq "1">
			00-:29		
			<cfelse>
			30-:59	
			</cfif>
									
		</cfcase>
		
		<cfcase value="3">		
		
			<cfif slot eq "1">
			    <cfif attributes.icon eq "Yes">
				<img src="#Client.VirtualDir#/images/logos/attendance/time/twenty1.png" alt="" border="0">
				<cfelse>
				00-:19
				</cfif>
			<cfelseif slot eq "2">
				  <cfif attributes.icon eq "Yes">
				  <img src="#Client.VirtualDir#/images/logos/attendance/time/twenty2.png" alt="" border="0">
				<cfelse>
				20-:39
				</cfif>
			<cfelse>
			   <cfif attributes.icon eq "Yes">
			   <img src="#Client.VirtualDir#/images/logos/attendance/time/twenty3.png" alt="" border="0">
				<cfelse>
				40-:59
				</cfif>			
			</cfif>
									
		</cfcase>
		
		<cfcase value="4">														
		
			<cfif slot eq "1">
			  <cfif attributes.icon eq "Yes">
			    <img src="#Client.VirtualDir#/images/logos/attendance/time/quarter1.png" alt="" border="0">
			  <cfelse>
				00-:14		
			  </cfif>	
			<cfelseif slot eq "2">
			  <cfif attributes.icon eq "Yes">
			   <img src="#Client.VirtualDir#/images/logos/attendance/time/quarter2.png" alt="" border="0">
			  <cfelse>
				15-:29		
			  </cfif>	
			<cfelseif slot eq "3">
			  <cfif attributes.icon eq "Yes">
			   <img src="#Client.VirtualDir#/images/logos/attendance/time/quarter3.png" alt="" border="0">
			  <cfelse>
				30-:44		
			  </cfif>	
			<cfelse>
			  <cfif attributes.icon eq "Yes">
			   <img src="#Client.VirtualDir#/images/logos/attendance/time/quarter4.png" alt="" border="0">
			  <cfelse>
				45-:59		
			  </cfif>				
			</cfif>
									
		</cfcase>
		
</cfswitch>

</cfoutput>
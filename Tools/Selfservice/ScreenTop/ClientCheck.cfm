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
<cfif client.browser eq "">
	<cfif find("MSIE","#CGI.HTTP_USER_AGENT#")>
	    <cfset client.browser = "Explorer">
	<cfelseif find("Firefox","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Firefox">	
	<cfelseif find("Chrome","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Chrome">	 	 
	<cfelseif find("Opera","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Opera">	
	<cfelseif find("Safari","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Safari">	 
	<cfelse>	
		<cfset client.browser = "undefined"> 
	</cfif>
</cfif>

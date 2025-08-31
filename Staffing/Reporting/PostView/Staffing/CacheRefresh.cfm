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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<!--- delete cached html which triggers a refresh in postview loop --->

<cftry>
	<cffile action="DELETE" file="#SESSION.rootPath#/CFReports/Cache/#link#.htm">
	<cfcatch></cfcatch>
</cftry>

<cfset lnk = "#replace(url.link,"_","&",'ALL')#">
<script language="JavaScript">
       window.location = "PostViewLoop.cfm?#lnk#&mid=#mid#" 
</script>
	
</cfoutput>

	
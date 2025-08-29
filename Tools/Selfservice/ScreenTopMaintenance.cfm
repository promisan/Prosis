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
<cfinvoke component = "Service.Process.System.Client" method= "getBrowser" returnvariable = "thisbrowser">	

<cfset standardCSS = "standard.css">
<cfif thisbrowser.name eq "Explorer" and thisbrowser.Release eq "7">
	<cfset standardCSS = "standardIE7.css">
</cfif>

<cfoutput>
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/images/css/#standardCSS#">
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#"> 		
	<!--- conflicts, disabled Hanno 17/12/2019
	<script type="text/javascript" src = "#SESSION.root#/Scripts/jQuery/jquery.js"></script>
	--->
	<script>
		var hostname = "#client.root#";
	</script>	
	<script type="text/javascript" src = "#SESSION.root#/scripts/Prosis/ProsisScript.js"></script>		
</cfoutput>

<cf_systemScript>

<cfinvoke component="Service.Access"  
    method="function"  
	SystemFunctionId="#URL.IDMenu#" 
	returnvariable="access">	
		
<cfif access eq "DENIED">	 

   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	 <tr><td align="center" height="40">
	   <font face="Verdana" color="FF0000">
		   <cf_tl id="Detected a Problem with your access"  class="Message">
	   </font>
		</td>
	 </tr>
   </table>	
   <cfabort>	
		
</cfif>		

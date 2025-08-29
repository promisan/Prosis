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
<cfset cnt = 1>
   
<cfloop index="itm" list="#url.coordinates#" delimiters=":">
        <cfif cnt eq "1">
			 <cfset latitude  = itm>
		<cfelse>
			 <cfset longitude = itm> 
		</cfif>
		<cfset cnt=cnt+1>
</cfloop>				
            
<table width="100%" height="100%" border="0" bgcolor="white">
	<tr>
    	<td align="center">
	<cftry>
	
    <cfmap centerlatitude="#latitude#" 
        centerlongitude="#longitude#" 
        doubleclickzoom="true" 
		zoomlevel="18"
        showscale="true"
        type="hybrid"
        typecontrol="advanced"
        zoomcontrol="large3d" 
        tip="#url.name#"
        height="591"
        width="604">
        
	</cfmap>
	<cfcatch>
	MAP could not be located
	</cfcatch>
	</cftry>
   	</Td>
	</tr>
</table>	
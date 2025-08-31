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
    <cfoutput>		
    <tr>
	<cfif url.outputshow eq "0">
		<td class="labelit" style="border-right: 1px solid Gray;border-bottom: 1px solid Gray;" colspan="2">
		<cf_space align="center" spaces="18" label="No.">
		</td>			
	<cfelse>
		<td class="labelit" style="border-bottom: 1px solid Gray"><cf_space spaces="2" align="center" label=""></td>
	</cfif> 			
	<td class="labelit" style="border-right: 1px solid Gray;border-bottom: 1px solid Gray">
	<cf_space spaces="80" label="Activity"></td>	
	<td class="labelit" style="border-right: 1px solid Gray;border-bottom: 1px solid Gray">
	<cf_space spaces="23" align="center" label="Start"></td>
	<td class="labelit" style="border-right: 1px solid Gray;border-bottom: 1px solid Gray">
	<cf_space spaces="23" align="center" label="End"></td>
	<td class="labelit" style="border-bottom: 1px solid Gray">
	<cf_space align="center" spaces="14" label="Dur."></td>	
	<td style="border-left: 1px solid Gray;border-bottom: 1px solid Gray">
	
	<table width="100%">
	<tr>
		
	<cfloop index="Itm" from="1" to="#Mth#">
		    	
		<td height="20" class="labelit" align="center" style="border-right: 1px solid Gray">
												
			<cf_space spaces="7">					
			<cfset mthShow = SM + Itm - 1>						
			<cfif mthShow gte 13>
    		  <cfset mthShow = mthShow - 12>
			</cfif>				
			<cfif mthShow gte 13>
    		  <cfset mthShow = mthShow - 12>
			</cfif>				
			<!--- repeated for additional year --->			
			<cfif mthShow gte 13>
    		  <cfset mthShow = mthShow - 12>
			</cfif>					
			<cfif mthShow gte 13>
    		  <cfset mthShow = mthShow - 12>
			</cfif>				
						
			<cftry>			
             #mthShow#<cfcatch>Error<cfabort></cfcatch>				 				 	
			</cftry>
							
		</td>
		
	</cfloop>
	</tr>
	</table>
	</td>		
	</tr>	
	</cfoutput>	
	
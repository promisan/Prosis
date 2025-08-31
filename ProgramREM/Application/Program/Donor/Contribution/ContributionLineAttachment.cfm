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

	<table border="0" cellspacing="0" cellpadding="0" width="100%">	
	<tr>
	<td class="n_contribution" colspan="3"></td>	
	<td style="padding:4px">
	
		<cfif mode eq "edit">
	
			<cf_filelibraryN
				DocumentPath="DonorLines"
				SubDirectory="#URL.LineId#" 
				Filter=""
				Presentation="all"
				Insert="yes"
				Remove="yes"
				width="100%"	
				Loadscript="no"				
				border="1"
				box = "r_#URL.LineId#">	
			
		<cfelse>
		
			<cf_filelibraryN
				DocumentPath="DonorLines"
				SubDirectory="#URL.LineId#" 
				Filter=""
				Presentation="all"
				Insert="no"
				Remove="no"
				width="100%"	
				Loadscript="no"				
				border="1"
				box = "r_#URL.LineId#">	
		
		
		</cfif>	
			
	</td>
	</tr>		
	</table>	
	
</cfoutput>	
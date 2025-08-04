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
	 
	   <tr class="labelmedium2 fixrow line" style="border-top:1px solid silver;background-color:c0c0c0">
	       <td align="center" width="100%"></td>
		   <td align="center" style="min-width:60px"><cf_tl id="Total"></td>
		  	 
			<cfloop query="Resource">
			       <td style="min-width:50px;border:1px solid silver;border-bottom:0px;border-top:0px;" align="center">
				   <cfif Resource.PostGradeBudget eq "Subtotal">
				        #Left(Resource.Code,8)#				   		
				         <cfset subT = subT & "-#Resource.CurrentRow#-">
				   <cfelse>
				   #Left(Resource.PostGradeBudget,6)#				  
				   </cfif>
				   </td>
			</cfloop>	
				    		
	   </tr>	
	
 </cfoutput>

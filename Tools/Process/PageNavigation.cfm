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
<cfparam name="attributes.pages" default="1">
<cfparam name="attributes.cpage" default="1">
<cfparam name="pages" default="#attributes.pages#">
<cfparam name="cpage" default="#attributes.cpage#">

<cfoutput>
		
  <cfif pages gt "1">
  
  		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
  
  	    <cfset last    = 0>
  		<cfset init    = 0>
        <cfset shownav = 1>
		<cfset cnt     = 0>
				
		<cfloop index="pg" from="1" to="#pages#" step="1">
				
		    <cfif shownav eq "1">
							
				<cfif pg gte (cpage-5)>
				   <cfif last is "0">
				 	   <cfset last = pg+9>										  					   
				   </cfif>	
				   								  
				   <cfif pg gt "1" and init eq "0">
					 <td width="80" class="labelit"><a href="javascript:list('#cpage-1#')" title="Previous"><font color="0080C0"><cf_tl id="Previous"></a></td>
					 <cfset init = 1>
				   </cfif> 
				   
				   <cfif cnt lte last>
					
					    <cfset init = 1>
						<cfif cpage eq pg>
							<td width="25" align="center" bgcolor="E6E6E6" class="labelit" style="border: 1px solid gray;"><font color="black"><b>#pg#</font></td>							
						<cfelse>
							<td width="25"
							    align="center"
								class="labelit"
								id="xpage#pg#"
							    style="cursor: pointer;"
							    onClick="javascript:list('#pg#')"
							    onMouseOver="document.getElementById('xpage#pg#').className='labelit highlight1'"
							    onMouseOut="document.getElementById('xpage#pg#').className='labelit'">
								<a title="Go to Page #pg#" href="javascript:list('#pg#')"><font color="0080C0">#pg#</font></a>
							</td>
						</cfif>
						<cfset cnt = cnt+1>
						
				   </cfif>	
									  
				   <cfif pg gt last and shownav eq "1">
					  	<td width="80" class="labelit"><a href="javascript:list('#cpage+1#')" title="Next"><font color="0080C0"><cf_tl id="Next"></a></td>
					    <cfset shownav = "0">
				   </cfif> 
								 
			   </cfif>
			   
			</cfif>   
			
		</cfloop>
		
		</tr>
		</table>
		
 </cfif>
 
</cfoutput> 
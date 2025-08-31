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
<cfparam name="url.mission" default="">
<cfparam name="url.period"  default="">

<!--- show review cycles to select --->

<cfquery name="Review" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   Ref_ReviewCycle
	  WHERE  Mission = '#url.mission#'
	  AND    Period  = '#url.period#'
	  AND    DateEffective < getDate()
	  AND    Operational = 1
	  ORDER BY DateEffective, DateExpiration		  
</cfquery>

<cfoutput>
	
	<cfif Review.recordcount eq "0">
	
		<input type="hidden" name="CycleId" id="CycleId" value="">
			
	<cfelse>
	
	 <table cellspacing="0" cellpadding="0">
	 <tr>
	 <td valign="top"><img src="#client.root#/images/join.gif" alt="" border="0"></td>
	 <td style="padding:3px" class="labelmedium">
	
	 <select style="width:190px;" class="regularxl" name="CycleId" id="CycleId" onChange="refreshListing()">
			 <option value="" selected><cf_tl id="Any Review Cycle"></option>
			 <cfloop query="Review">
				 <option value="#CycleId#">#Description#</option>		 
	    	 </cfloop>
	 </select>
	 
	 </td>
	 </tr>
	 </table>
	 
	 </cfif>
	 	
 </cfoutput>

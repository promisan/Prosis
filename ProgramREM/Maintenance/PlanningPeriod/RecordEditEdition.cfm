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

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT R.*
		FROM   ProgramAllotment P, Ref_AllotmentEdition R
		WHERE  P.EditionId = R.EditionId
		AND    P.ProgramCode IN (SELECT ProgramCode
		                         FROM   Program 
								 WHERE  Mission = '#url.Mission#')
		AND    P.Period = '#url.period#'			
</cfquery>
 
<cfif edition.recordcount eq "0">

	<input type="hidden" name="EditionId_#url.ln#" value="">
	<font color="FF0000">Record a Program Allotment for <cfoutput>#URL.Period#</cfoutput> first.</font>

<cfelse>
	
	<cfoutput>	
	
		<table cellspacing="0" cellpadding="0"><tr><td>
						   
		<select name="EditionId_#url.ln#" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
		   <cfloop query="Edition">
		   <option value="#EditionId#" <cfif url.prior eq editionid>selected</cfif>>#EditionId# : #Description# <cfif Period neq ""> #Period#</cfif></option>
		   </cfloop>
		</select>	
		
		</td>
		
		<td style="padding-left:2px">
		
		<cfparam name="url.prioralt" default="">
								   
		<select name="EditionIdAlternate_#url.ln#" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
		   <option value="">n/a</option>
		   <cfloop query="Edition">
		   <option value="#EditionId#" <cfif url.prioralt eq editionid>selected</cfif>>#EditionId# : #Description# <cfif Period neq ""> #Period#</cfif></option>
		   </cfloop>
		</select>	
		
		</td></tr></table>
	
	</cfoutput> 

</cfif>  			
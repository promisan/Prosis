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
<cfparam name="url.status" default="9">

<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Program P,
	       ProgramPeriod Pe
	WHERE  P.ProgramCode = Pe.ProgramCode 
	AND    P.ProgramCode = '#URL.ProgramCode#'		
	AND    Pe.Period     = '#URL.Period#'  	
</cfquery>	

<cfif get.PeriodHierarchy neq "" and get.recordcount eq "1">

	<!--- we disable all projects under it in this period as well --->
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ProgramPeriod 
		SET    RecordStatus        = '#url.status#',  
		       RecordStatusDate    = getDate(),
			   RecordStatusOfficer = '#session.acc#'
		WHERE  ProgramCode IN (SELECT ProgramCode 
		                       FROM   Program 
							   WHERE  Mission = '#get.mission#')					   
		AND    Period = '#URL.Period#' 		
		AND    PeriodHierarchy LIKE '#get.PeriodHierarchy#%'
	</cfquery>	
	
	<cfquery name="CheckAllotment" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     ProgramAllotmentDetail
		WHERE    ProgramCode = '#url.ProgramCode#' 
		AND      Period      = '#url.period#'
		AND      AmountBase > 0
		AND      Status = '1'
	</cfquery>
	
	<cfoutput>
	
		<table class="formspacing"><tr>
	
		<cfif url.status eq "9">
			
			<td>
			<cf_tl id="Reinstate" var="1">
			<button name="Delete" 
			 style="width:160;height:27" 
			 value="Deactivate" 
			 class="button10g"
			 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=1&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
			</td>
			
			<td> 
			<cf_tl id="Stall" var="1">
			<button name="Delete" 
			 style="width:160;height:27" 
			 value="Deactivate" 
			 class="button10g"
			 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=8&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
			</td> 
		 
		 <cfelseif url.status eq "8">
		 
		 	<td>
		    <cf_tl id="Reinstate" var="1">
			<button name="Delete" 
			 style="width:160;height:27" 
			 value="Deactivate" 
			 class="button10g"
			 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=1&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
			</td>
			
			<cfif CheckAllotment.recordCount eq "0">
			<td> 			 
			<cf_tl id="Deactivate" var="1">
			<button name="Delete" 
			 style="width:160;height:27" 
			 value="Deactivate" 
			 class="button10g"
			 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=9&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
			</td> 
			</cfif>
				 
		 <cfelse>
		 
		 	<td>
			<cf_tl id="Stall" var="1">
			<button name="Delete" 
			 style="width:160;height:27" 
			 value="Deactivate" 
			 class="button10g"
			 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=8&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
			</td>
			
			<cfif CheckAllotment.recordCount eq "0">
			<td>				 
			 <cf_tl id="Deactivate" var="1">
			 <button name="Delete" 
			 style="width:160;height:27" 
			 value="Deactivate" 
			 class="button10g"
			 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=9&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
		    </td>
			</cfif>
		 
		 </cfif>
		 
		 </tr></table>
				 
     </cfoutput>				 
				
<cfelse>

	<cfoutput>
	<script>
		alert("#get.ProgramClass# could not be deactivated.")
	</script>
	</cfoutput>		

</cfif>


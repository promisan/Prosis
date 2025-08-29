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
<cfparam name="url.reset"          default="0">
<cfparam name="url.lastcontractid" default="">
<cfparam name="url.eff"            default="#dateformat(now(),CLIENT.DateFormatShow)#">
<cfparam name="url.entry"          default="edit">
<cfparam name="url.grade"          default="">

<cfif URL.eff eq "">
	<cfset URL.eff = dateformat(now(),CLIENT.DateFormatShow)>
</cfif>

<CF_DateConvert Value="#url.eff#">
<cfset effect = dateValue>

<cfset gradeselected = url.grade>

<cfset yr = year(now())> 

<cfif url.lastcontractid neq "">

    <!--- --------------------------------------------------------- --->
	<!--- add to determine if the increment date has to be adjusted --->
	<!--- --------------------------------------------------------- --->
	
	<cfquery name="LastContract" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      PersonContract PA 
			WHERE     PA.Contractid = '#URL.lastcontractid#' 			
	</cfquery>	
				
	<cfif url.grade eq "">
		<cfset gradeselected = LastContract.Contractlevel>
		<cfset yr = lastContract.DateEffective>
	</cfif>		
			
	<cfif LastContract.recordcount eq "1" and LastContract.actionstatus eq "1">
			
	        <!--- determine the expiration date of a contract of this
			person for the same level/step --->
			
			<cfquery name="LastContractWithinCurrentGrade" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT MAX(StepIncreaseDate) as Suggested
				    FROM   PersonContract
					WHERE  PersonNo      =  '#LastContract.PersonNo#'
					AND    ContractLevel =  '#LastContract.ContractLevel#'
					AND    ContractStep  =  '#LastContract.ContractStep#'
					AND    ActionStatus  =  '1'
					<!--- AND    ContractId   !=  '#LastContract.ContractId#' --->
					AND    Mission       =  '#LastContract.Mission#'
					
			</cfquery>	
													
			<cfif LastContractWithinCurrentGrade.Suggested neq "">			
				    <cfset url.dte  = dateformat(LastContractWithinCurrentGrade.Suggested, CLIENT.DateFormatShow)>						  
			<cfelse>			
				    <cfset url.dte  = dateformat(LastContract.StepIncreaseDate, CLIENT.DateFormatShow)>						  						 
			</cfif>		
			
			<CF_DateConvert Value="#url.dte#">
			<cfset increment = datevalue>
									
			<cfif effect lt increment>
			    <cfset effect = increment>
				<cfset url.reset = 0>			
			</cfif> 
			
	</cfif>	

</cfif>	

<cfquery name="grade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_PostGrade 
		WHERE     PostGrade = '#gradeselected#' 			
</cfquery>	

<cfif IsDate(effect) and grade.PostGradeStepInterval neq "0">
        					
	<cfif url.reset eq "1">
	    <!---
		<cfset sel  = dateadd("YYYY","1",effective)>
		--->		
		<cfset sel  = dateadd("M","1",effect)>		
		<cfset sel  = dateadd("YYYY","1",effect)>
	<cfelse>		
		<cfset sel  = dateadd("YYYY","0",effect)>				
	</cfif>	
							
	<cfif month(sel) lt 10>		
		 <cfset url.sel = "01/#month(sel)#/#year(sel)#">
	<cfelse>
	     <cfset url.sel = "01/0#month(sel)#/#year(sel)#">
	</cfif>		
		
	<cfoutput>
						
		<select name="StepIncreaseDate" style="width:150px;<cfif url.entry eq 'edit'>border:0px</cfif>" class="<cfif url.lastcontractid eq "">regularxxl<cfelse>regularxxl</cfif>">
			<!--- was before; rfuentes, STL tmp 
		     <option value="" selected><cf_tl id="No applicable"></option>
			 
		     <cfloop index="yr" from="#year(sel)-20#" to="#year(sel)+20#" step="1">
			 																	--->
			 <option value="" <cfif url.entry eq "new"> selected </cfif> ><cf_tl id="No applicable"></option>
			 <cfloop index="yr" from="#yr#" to="#year(sel)+20#" step="1">
			    <cfloop index="itm" from="1" to="12" step="1">
				
						 <cfif len(itm) eq "1">
						   <cfset mt = "0#itm#"> <cfelse>  <cfset mt = "#itm#">
						 </cfif> 
					 	 <option value="01/#mt#/#yr#" 
						    <cfif url.sel eq "01/#itm#/#yr#" and url.entry eq "edit">selected</cfif>>#monthasString(itm)# #yr#
						 </option>		 
					
			    </cfloop>
		     </cfloop>
		</select>
		
	</cfoutput>
	
	<script>
	try {
	document.getElementById('nextincrement').className = "labelmedium bcell" } catch(e) {}
	</script>

<cfelse>

    <table><tr class="labelmedium"><td style="padding-left:5px"><cf_tl id="N/A"></td></tr></table>
		
	<input type="hidden" name="StepIncreaseDate" value="">
	
	<script>
	try {
	document.getElementById('nextincrement').className = "hide" } catch(e) {}
	</script>
	 

</cfif>
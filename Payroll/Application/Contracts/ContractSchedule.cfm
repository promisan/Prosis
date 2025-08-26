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

<cf_tl id="Staff contracts" var="1">	

<cf_screentop height="100%" scroll="Yes" jquery="Yes" html="Yes" layout="webapp" label="#lt_text#" MenuAccess="Yes" SystemFunctionId="#url.idmenu#">

<cf_listingscript>
<cf_calendarscript>
<cf_menuscript>

<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<table width="96%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
 
 <tr><td height="4"></td></tr>
  
 <tr>
	     <td height="20">
		 
		 <cfquery name="Schedule" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT   S.SalarySchedule, lEFT(SS.Description,27) AS Description
			FROM     SalaryScheduleMission S INNER JOIN
		             SalarySchedule SS ON S.SalarySchedule = SS.SalarySchedule
			WHERE    Mission = '#url.mission#'	
			AND      S.SalarySchedule IN (SELECT SalarySchedule FROM Employee.dbo.PersonContract WHERE Mission = '#URL.Mission#' and ActionStatus != '9')
			AND      SS.Operational = 1
			ORDER BY ListingOrder
	    </cfquery>
	   
		<table width="96%" cellspacing="0" cellpadding="0">
		   <tr>  
		    
			   <td style="min-width:100;width:10%;padding-right:10px;">
			   
			       <cfset link = "#SESSION.root#/Staffing/Application/Contract/ContractListing.cfm?year='+document.getElementById('year').value+'&month='+document.getElementById('month').value+'&expiration='+document.getElementById('expiration').value+'&id=sch&id1='+document.getElementById('schedule').value+'&mission=#url.mission#">
			   
			   	    <cfoutput>		
					   
				    <table style="border:1px solid silver;height;100%;background-color:f4f4f4;" class="formspacing">
					<tr><td style="padding=top:4px;padding-right:10px;border-right;1px solid gray;font-size:20px;height:30px;padding-left:5px;padding-right:10px">#url.Mission#</td>
					<td>
							
					    <select name="year" id="year" style="background-color:transparent;width:70px;border:0px;font-size:18px;height:30px" class="regularxl" onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ColdFusion.navigate('#SESSION.root#/Staffing/Application/Contract/ContractListing.cfm?year='+this.value+'&month='+document.getElementById('month').value+'&expiration='+document.getElementById('expiration').value+'&id=sch&id1='+document.getElementById('schedule').value+'&mission=#url.mission#','contentcontract1');">
							<cfloop index="itm" list="#year(now())#,#year(now())-1#">				
							<option value="#itm#">#itm#</option>				
							</cfloop>			
						</select>
						
				   	</td>
					
					<td style="padding-left:10px">
					
						<select name="month" id="month" style="background-color:transparent;border:0px;font-size:18px;height:30px" class="regularxl" onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ColdFusion.navigate('#SESSION.root#/Staffing/Application/Contract/ContractListing.cfm?year='+document.getElementById('year').value+'&month='+this.value+'&expiration='+document.getElementById('expiration').value+'&id=sch&id1='+document.getElementById('schedule').value+'&mission=#url.mission#','contentcontract1');">>			
							<cfloop index="itm" list="01,02,03,04,05,06,07,08,09,10,11,12">				
							<option value="#itm#" <cfif month(now()) eq itm>selected</cfif>>#monthAsString(itm)#</option>				
							</cfloop>			
						</select>
						
					</td>
					
					<td style="padding-left:10px">
					
						<select name="expiration" id="expiration" style="background-color:transparent;border:0px;font-size:18px;height:30px" class="regularxl" onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ColdFusion.navigate('#SESSION.root#/Staffing/Application/Contract/ContractListing.cfm?year='+document.getElementById('year').value+'&month='+document.getElementById('month').value+'&expiration='+this.value+'&id=sch&id1='+document.getElementById('schedule').value+'&mission=#url.mission#','contentcontract1');">			
							
							<option value="0"><cf_tl id="All Contracts"></option>	
							<option value="1"><cf_tl id="Expiring Contracts"></option>		
							<option value="2"><cf_tl id="Missing Assignment"></option>				
										
						</select>
						
					</td>
									
					</td>
				</tr>
				</table>			
						
				</cfoutput>
		   
		   </td>   
		   
		   <td class="hide"><input type="text" name="schedule" id="schedule"></td>	   
		  	      	   
		   <cfoutput query="Schedule">
		   
		   		<cfif currentrow eq "1">
				  <cfset cl = "highlight1">
				<cfelse>
				  <cfset cl = "labelmedium">  
				</cfif>
							
				<cf_menutab base = "contractsel"
				    item         = "#currentrow#" 
					target       = "contract"
					targetitem   = "1"
					padding      = "0"
					class        = "#cl#"
					name         = "#Description#"
					iframe       = "contractcontent"
					script       = "document.getElementById('schedule').value='#salaryschedule#'"
					source       = "#SESSION.root#/Staffing/Application/Contract/ContractListing.cfm?systemfunctionid=#url.idmenu#&year={year}&month={month}&expiration={expiration}&id=sch&id1=#salaryschedule#&mission=#url.mission#">		
		   		   
		   	</cfoutput>
			   
	   </tr>
	   
	   </table>   
   
   </td>
	 	 
 </tr>
 
 <tr><td height="2"></td></tr>  
 <tr><td height="1" class="line"></td></tr> 
 <tr><td height="2"></td></tr> 
 
 <tr><td height="100%"> 
 	
	<table width="100%" height="100%" style="border:0px dotted silver" id="contentcontract1">			
	</table> 
 
 </td></tr>
 					  
</table>   

<script>
  document.getElementById('contractsel1').click()
</script>

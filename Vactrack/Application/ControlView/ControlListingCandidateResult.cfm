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

<!--- obtain criteria for conditions --->
<cfinclude template = "ControlListingCandidatePrepare.cfm">

<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission = '#url.mission#'
</cfquery>

<cfset pre = mission.missionPrefix>

<cfsavecontent variable="session.selectedcandidates_#pre#">
	
	<cfoutput>		
	    SELECT  *		
		FROM    (#preservesingleQuotes(session.selectedcandidates)#) as T				
		<!--- added to make sure that some workflow were completed and might not be in the subtable --->									
		WHERE   1=1 
		<cfif vCondition neq "">
		#PreserveSingleQuotes(vCondition)#						
		</cfif>
	</cfoutput>	
	
</cfsavecontent>

<cfset qryvar = evaluate("session.selectedcandidates_#pre#")>

<cfquery name="getCandidate"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	
	    SELECT  *		
		FROM    (#preservesingleQuotes(qryvar)#) as T				
		<!--- added to make sure that some workflow were completed and might not be in the subtable --->									
		WHERE   1=1 
					
</cfquery>

<!--- header --->
	
<cfquery name="Count" dbtype="query">
	SELECT     COUNT(DISTINCT DocumentNo) as Total
	FROM       getCandidate
</cfquery>

<cfquery name="CountAll" dbtype="query">
	SELECT     COUNT(DocumentNo) as Total
	FROM       getCandidate
</cfquery> 

<cfquery name="getMapData" dbtype="query">
	SELECT     ISOCODE2,
		   	   COUNT(DISTINCT PersonNo) AS CountPersons
	FROM	   getCandidate
	GROUP BY   ISOCODE2 
</cfquery>
	
<cfset vDataList = "">

<cfloop query="getMapData">
	<cfset vDataList = vDataList & "{id:'#ISOCODE2#', value:#CountPersons#}">
	<cfif currentrow neq recordCount>
		<cfset vDataList = vDataList & ", ">
	</cfif>
</cfloop>		

<cfoutput>

	<script>	
			
		var vData =	[#vDataList#];
		loadMapData_1(vData);
			
	</script>
	
</cfoutput>

<cfif count.total eq "0">
	
	<table width="98%" align="center" border="0"><tr><td class="labelmedium2" style="padding-top:10px;font-size:20px" align="center"><cf_tl id="No records to show"></td></tr>
	<cfsavecontent variable="session.selectedcandidates"></cfsavecontent>

<cfelse>


	<table width="98%" style="height:100%" border="0" align="center">
				
		<tr class="line"><td colspan="3">
			    <table width="100%">		
					<tr class="labelmedium2">
				    <td style="font-size:29px;padding-left:20px" align="left"><b>#count.total#</b> Tracks <font size="2">with <b><a href="javascript:parent.candidatetracklisting('#url.systemfunctionid#','all','#url.status#','','#url.mission#')">#Countall.Total#</a></b> selected candidates</font> </td>			
					<!---
					<cfif url.mode neq "Portal" and url.mode neq "Print">
					<td align="right" style="padding-right:2px"><a href="javascript:printme()">Printable Version</a></td>		
					<cfelseif url.mode eq "Print">
					<td align="right" style="padding-right:2px"><a href="javascript:window.print()">[Print]</a></td>				
					</cfif>
					--->
					</tr>
				</table>
		    </td>
		</tr>		
						
		<cfif getCandidate.recordcount gte 1>
		
			<tr>	
			
			    <td>
				
					<table gwidth="100%">
					
					    <tr class="line"><td class="labelmedium2" style="height:35px;padding-left:20px;font-size:17px"><cf_tl id="Gender"></td></tr> 					
						<tr><td>	
						
						<cfquery name="Summary" dbtype="query">
							SELECT     Gender, COUNT(*) as Counted
							FROM       getCandidate
							GROUP BY Gender
						</cfquery>
															
						<cf_uichart name="candidategraph4_#mission.missionprefix#"
							chartheight="240"
							chartwidth="240"
							showlabel="Yes"
							url="javascript:candidatelisting('#url.systemfunctionid#','gender','','$ITEMLABEL$')">
										
					      <cf_uichartseries type="pie" 
						       query="#Summary#" 
							   itemcolumn="Gender" 				   
							   valuecolumn="Counted"
							   colorlist="##E08FE0,##0B8EDD" />		
							   
						 </cf_uichart>	 
						 					 
						 </td>
						 </tr>  	
					
					</table>
				
				</td>	
																
				<td align="center" valign="bottom">
				
				<table width="100%">				
							
				    <cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">									
							
					<tr class="line">
					<td class="labelmedium2" style="height:35px;padding-left:20px;font-size:17px"><cf_tl id="Country"></td></tr> 
						
					<tr><td>											
			  			<div id="candidatemap" style="height:240px; width:470px;max-width:470px;"></div>							  
					  </td>
					</tr>						
				
				</table>			
						
				</td>		
				
						
				
				<td>
				
					<table gwidth="100%">
					
					    <tr class="line"><td class="labelmedium2" style="height:35px;padding-left:20px;font-size:17px"><cf_tl id="Country group"></td></tr> 					
						<tr><td>	
						
						<cfquery name="Summary" dbtype="query">
							SELECT     CountryGroup, COUNT(*) as Counted
							FROM       getCandidate
							GROUP BY CountryGroup
						</cfquery>	
						
						<cfset vColorList = "##dea900,##6dc304,##3399ff,##a25403,##db1414">
															
						<cf_uichart name="candidategraph2_#mission.missionprefix#"
							chartheight="240"
							chartwidth="510"
							showlabel="Yes"
							url="javascript:candidatelisting('#url.systemfunctionid#','countrygroup','','$ITEMLABEL$')">
										
					      <cf_uichartseries type="pie" 
						       query="#Summary#" 
							   itemcolumn="CountryGroup" 				   
							   valuecolumn="Counted" colorlist="#vColorList#"/>		
							   
						 </cf_uichart>	 
						 					 
						 </td>
						 </tr>  	
					
					</table>
				
				</td>		
								
		 <cfelse>
				
				<td colspan="3" class="labelmedium" align="center" height="400">		
					<font color="gray">No recruitment tracks found for this selection</font>			
				</td>	
				
		 </cfif>
					
		 </tr>
		 										
	</table>	
	
</cfif>	

</cfoutput>		


<cfquery name="getMax" dbtype="query">
	SELECT 	  MAX(CountPersons) as MaxValue
	FROM 	  getMapData
</cfquery>

<cfquery name="getTotal" dbtype="query">
	SELECT 	  SUM(CountPersons) as Total
	FROM 	  getMapData
</cfquery>

<cf_tl id="Employees" var="vLblEmployee">
<cf_tl id="out of" var="vLblOutOf">	

<cfset id = "1">
<cfset ajaxOnLoad("function(){  resetMap_#id#('0', '#getMax.maxValue#', '<span style=\'font-size:14px;\'><b>[[title]]</b>: [[value]]/#getTotal.Total# #vLblEmployee#</span>', [#vDataList#]); }")>


<script>
	Prosis.busy('no')
</script>	
				
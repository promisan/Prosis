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
<!--- totals budget by fund --->

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#URL.Mission#'	
</cfquery>

<cfquery name="Fund" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    ObjectCode,
		          SUM(Total)/1000 AS Total 
	    <cfif Parameter.FundingCheckCleared eq "0">
		FROM      userQuery.dbo.#SESSION.acc#Requirement	
		<cfelse>
		FROM      userQuery.dbo.#SESSION.acc#Release
		</cfif>
		GROUP BY ObjectCode
</cfquery>	

<table width="96%" align="center" class="formpadding">

<!---

<tr><td align="center" style="padding:10px">
	
	<cf_tl id="Slice and Dice" var="1">
		<cfset tInquiry = "#Lt_text#">			
		
	<cfinvoke component="Service.Analysis.CrossTab"  
			  method      = "ShowInquiry"
			  buttonName  = "Analysis"
			  buttonClass = "button10g"
			  buttonIcon  = "#SESSION.root#/images/dataset.png"
			  buttonText  = "#tInquiry#"
			  buttonStyle = "height:40px;width:95%;font-size:20px"
			  reportPath  = "Procurement\Application\Funding\"
			  SQLtemplate = "FundingExecutionFactTable.cfm"
			  queryString = "Mission=#URL.Mission#&header=1"
			  dataSource  = "appsQuery" 
			  module      = "Procurement"
			  reportName  = "Facttable: Budget Execution Inquiry"
			  olap        = "1"
			  ajax        = "1"		  
			  table1Name  = "Allotment"
			  table2Name  = "Requirements"		
			  table3Name  = "Execution"	 	     	     	  		  
			  filter      = "1"> 	

</td></tr>

--->

<tr><td style="padding-top:10px" align="center" class="labelit"><cf_tl id="Budget by Object"> ($000)</td></tr>
<tr><td height="1" class="line"></td></tr>
<tr><td align="center">

		<cfchart format="png"
           chartheight="300"
           chartwidth="300"
           seriesplacement="default"
           font="arial"
           fontsize="9"
		   show3d="no"	
		   showlegend="yes"		   
           labelformat="number"
           tipstyle="mouseOver">
		   
		   <cfchartseries
             type="pie"
             query="Fund"
             itemcolumn="ObjectCode"
             valuecolumn="Total"			 
             serieslabel=""
             datalabelstyle="columnLabel"/>	  			 	
		   
		</cfchart>
		
</td></tr>
		   
<tr><td height="20"></td></tr>		   

<!--- this information is take by the temp files that are converted for the currency --->

<tr class="line"><td align="center" class="labelit"><cf_tl id="Commitments by Fund and Program"> ($000)</td></tr>
<tr><td height="20" align="center">

<cfoutput>
<input type="button" class="button10g" style="width:95%" value="Explore execution" 
    onclick="ptoken.open('#session.root#/procurement/application/funding/listing/ExecutionView.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&planningperiod=#url.planningperiod#&period=#url.period#')">
</cfoutput>	

</td></tr>		

<tr><td align="center">

<cfquery name="FundList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    DISTINCT Fund
		FROM      userQuery.dbo.#SESSION.acc#Invoice			
</cfquery>	

	<cfchart format="png"
	   chartheight="350"
	   chartwidth="360"
	   seriesplacement="percent"
	   font="calibri"
	   fontsize="15"	
	   show3d="no"	 
	   showlegend="no"  
	   labelformat="number"
	   tipstyle="mouseOver">
		   
	  <cfchartseries
          type="pie"           
          serieslabel="Unliquidated"
          seriescolor="##2574A9"
          datalabelstyle="rowLabel"
		  colorlist="##2574A9,##E8875D,##E8BC5D,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA"> 
			 
			 <cfloop query="FundList">
			 		
				 <cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    SUM(ObligationAmount)/1000 as Total		         
						FROM      userQuery.dbo.#SESSION.acc#Unliquidated	
						WHERE     Fund = '#Fund#'		
				 </cfquery>	
				 
				 <cfif Check.total eq "">
				 	<cfset tot = 0>
				 <cfelse>
				 	<cfset tot = check.total>
				 </cfif>
				 
				 <cfchartdata item="#Fund#" value="#tot#">
			 
			 </cfloop>
			 			 
		</cfchartseries>
		   
		<cfchartseries
             type="pie"                 	 
             serieslabel="Disbursed"
			 seriescolor="##E8875D"
             datalabelstyle="rowLabel"
			 colorlist="##2574A9,##E8875D,##E8BC5D,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
			 
			 <cfloop query="FundList">
			 		
				 <cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    SUM(InvoiceAmount)/1000 as Total		         
						FROM      userQuery.dbo.#SESSION.acc#Invoice	
						WHERE     Fund = '#Fund#'	
				 </cfquery>	
				 
				 <cfif Check.total eq "">
				 	<cfset tot = 0>
				 <cfelse>
				 	<cfset tot = check.total>
				 </cfif>
				 
				 <cfchartdata item="#Fund#" value="#tot#">
			 
			 </cfloop>			 
		   		 
			</cfchartseries>	 			 	
					   
		</cfchart>
		   
</td></tr>
</table>		   


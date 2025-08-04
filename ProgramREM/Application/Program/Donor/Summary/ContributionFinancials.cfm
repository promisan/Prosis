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

<cfquery name="get"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Contribution
    WHERE    ContributionId = '#url.contributionid#'
</cfquery>	

<cfset vColorlist = "##2ABB9B,##663399,##5C97BF,##E87E04,##81CFE0,##E08283,##52B3D9,##9B59B6,##4DAF7C,##E08283,##87D37C">

<table width="95%" align="center">

<tr><td  class="labellarge" style="height:33"><cfoutput>#get.Reference#</cfoutput></td></tr>

<tr><td class="linedotted"></td></tr>

<tr><td align="center">
		
	<cfquery name="getAllocations"
		    datasource="AppsProgram" 
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			
		    SELECT   O.Description, 					
					 O.ListingOrder,		 
					 ROUND(SUM(C.Amount),2) as Allocation						  
		            						   
		    FROM     ProgramAllotmentDetail AS D INNER JOIN
		             Ref_Object AS R ON D.ObjectCode = R.Code  INNER JOIN 
					 Ref_Resource AS O ON R.Resource = O.Code  INNER JOIN 
					 ProgramAllotmentDetailContribution C ON C.TransactionId = D.TransactionId	 
	 
		    WHERE    D.ProgramCode IN (SELECT ProgramCode 
			                           FROM   Program 
									   WHERE  ProgramCode = D.ProgramCode 
									   AND    Mission = '#get.Mission#')	
									   					
			AND       C.ContributionLineId IN (SELECT ContributionLineId 
			                                   FROM   ContributionLine 
										       WHERE  ContributionId = '#url.ContributionId#'
											   AND    ContributionLineId = C.ContributionLineId
											   AND    ActionStatus <> '9')   							
			AND       D.Status = '1'
					
		    GROUP BY  O.Description, 					  
					  O.ListingOrder 	
			ORDER BY O.ListingOrder  
			 
	</cfquery>	
	
	<cfif getAllocations.recordcount eq "0">
	
		<table width="100%">
			<tr><td height="360" align="center" class="labelit">No allocations recorded</td></tr>
		</table>
	
	<cfelse> 	
	
	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
	<cfchart style = "#chartStyleFile#" format="png"
	      title="Allocation of the contribution"
		  chartheight="390"
		  chartwidth="840"
		  seriesplacement="default"
		  show3d="no"	
		  labelformat="currency">
				   
		   <cfchartseries type="pie"
             query="getAllocations"
             itemcolumn="Description"
             valuecolumn="Allocation"
             serieslabel="Allocation"
			 colorList		 = "#vColorlist#"/>	  			 	
				   
	</cfchart>
	
	</cfif>

</td>
</tr>


<tr><td align="center">

<cfquery name="getExecution"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
				
	SELECT   ROUND(SUM(AmountBase), 2) AS Contribution,
	
	         (SELECT   ROUND(SUM(Amount),2)
	          FROM     ProgramAllotmentDetailContribution AS D
	          WHERE    ContributionLineId IN (SELECT  ContributionLineId
				                              FROM    ContributionLine AS O
	                                          WHERE   ContributionId = C.ContributionId)

			   <!--- only valid allotments lines to be used for this total --->
			  AND      TransactionId      IN  (SELECT TransactionId 
				                                FROM   ProgramAllotmentDetail 
										        WHERE  TransactionId = D.TransactionId 
										        AND    Status = '1') 
			  ) AS Allocated,
											
	         (SELECT     ROUND(SUM(TransactionAmount), 2) AS Expr1
	          FROM       Accounting.dbo.TransactionLine AS A
			  WHERE      Journal IN (SELECT Journal FROM  Accounting.dbo.Journal WHERE Mission = '#GET.mission#') 
			  AND        A.TransactionSerialNo <> 0
	          AND        ContributionLineId IN
		                        (SELECT  ContributionLineId
		                         FROM    ContributionLine AS O
		                         WHERE   ContributionId = C.ContributionId)) AS Executed
							 
	FROM      ContributionLine AS C
	WHERE     ContributionId = '#url.ContributionId#' 
	AND       ActionStatus <> '9'
	GROUP BY  ContributionId

</cfquery>

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">

<cfchart style = "#chartStyleFile#" format="png"
	           chartheight="320"
    	       chartwidth="840"
			   Title="Status of Execution"
	           seriesplacement="cluster"
			   showlegend="yes"
        	   labelformat="currency"
	           pieslicestyle="sliced">
				   
	<cfchartseries
    	     type="bar"
	         query="getExecution"
    	     itemcolumn="Fund"
	         valuecolumn="Contribution"
    	     serieslabel="Contribution"
			 seriescolor = "2ABB9B"
			 colorList		 = "#vColorlist#"/>	  	

	<cfchartseries
         type="bar"
         query="getExecution"
         itemcolumn="Fund"
         valuecolumn="Allocated"
         serieslabel="Allocation"
		 seriescolor = "E87E04"
		 colorList		 = "#vColorlist#"/>	 

	<cfchartseries
         type="bar"
         query="getExecution"
         itemcolumn="Fund"
         valuecolumn="Executed"
         serieslabel="Execution"
		 seriescolor = "663399"
		 colorList		 = "#vColorlist#"/>	  			  			 		 	
				   
</cfchart>


</td>
</tr>

</table>
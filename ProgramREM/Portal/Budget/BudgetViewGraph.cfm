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

<!--- generate a chort --->

<cfquery name="Base" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AllotmentEdition
	WHERE  EditionId = '#url.edition#' 	
</cfquery>	

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE    E.Version = V.Code
	AND      ControlEdit = 1		
	AND      E.Mission     = '#Base.Mission#'   	
	AND      E.Version     = '#Base.Version#' 
	AND      (Period is NULL 
	              or 
		      Period IN (SELECT Period 
			               FROM   Ref_Period 
						   WHERE  DateEffective >= (SELECT DateEffective 
						                            FROM   Ref_Period  
													WHERE  Period = '#URL.Period#')
						  )							
			 )
	
	ORDER BY E.ListingOrder, Period	
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="4"></td></tr>

<cfoutput query="Edition">

<tr><td>&nbsp;#Description#</td></tr>

<cfquery name="Resource" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *	         
	FROM      Ref_Resource R
	WHERE     R.Code IN (SELECT Resource 
	                   FROM   Ref_Object 
					   WHERE  ObjectUsage = '#ObjectUsage#')
	ORDER BY R.ListingOrder			   
</cfquery>	

<!---
<cfquery name="Resource" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    R.Code, 
	          R.Description, 
			  R.Listingorder, SUM(PA.AmountBase * (PAE.Percentage / 100)) AS Amount
	FROM      ProgramAllotmentDetail PA INNER JOIN
              ProgramAllotmentEarmark PAE ON PA.ProgramCode = PAE.ProgramCode AND PA.Period = PAE.Period AND PA.EditionId = PAE.EditionId INNER JOIN
              Ref_ProgramCategory R ON PAE.ProgramCategory = R.Code LEFT OUTER JOIN
              Ref_Object O ON PA.ObjectCode = O.Code AND PAE.Resource = O.Resource
	WHERE     PA.Period      = '#url.period#' 
	  AND     PA.EditionId   = '#editionid#' 
	  AND     PA.ProgramCode IN (SELECT ProgramCode 
	                             FROM   ProgramPeriod 
								 WHERE  Period = '#URL.Period#'
								 AND    Status != '9' 
								 AND    OrgUnit = '#url.id1#')    
	  AND     PA.Status IN ('0', '1')
	  <!---
	  AND     R.AreaCode = '#URL.area#'
	  --->
	GROUP BY  R.Code, R.Description, R.Listingorder	
	HAVING    SUM(PA.AmountBase * (PAE.Percentage / 100)) > 0
	ORDER BY  R.Listingorder	
</cfquery>	
--->

<tr><td align="center">

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png"
           chartheight="220"
           chartwidth="730"
           scalefrom="0"
           gridlines="6"
           showxgridlines="yes"
           seriesplacement="default"
           font="Verdana"
           fontsize="11"          
           labelformat="number"
           show3d="yes"
           tipstyle="mouseOver"
           tipbgcolor="F4F4F4"
           showmarkers="yes"
           markersize="30"
           pieslicestyle="sliced"
           backgroundcolor="ffffff">
		   
		 			 
		<cfchartseries
             type="bar"
          
             seriescolor="0000CC"            	 			 
             paintstyle="light"
             markerstyle="mcross"
             colorlist="##CCCC66,##3399FF,##66CC66,##999999,##FFFF99,##9966FF,##FF7777,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
			 
			 <cfloop query="Resource">
									 
			 <cfquery name="Data" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				 
				SELECT    SUM(PA.AmountBase) as Amount
				FROM      ProgramAllotmentDetail PA 
				WHERE     PA.Period      = '#url.period#' 
				  AND     PA.EditionId   = '#edition.editionid#' 
				  AND     PA.ProgramCode IN (SELECT ProgramCode 
					                         FROM   ProgramPeriod 
							    			 WHERE  Period = '#URL.Period#'
											 AND    Status != '9' 
											 AND    OrgUnit = '#url.id1#')    
				  AND     PA.Status IN ('0', '1')
				  AND ObjectCode IN (SELECT Code 
				                     FROM Ref_Object 
									 WHERE Resource = '#Code#')		
			 </cfquery>
			 
			 <cfif data.amount eq "">
			  <cfset d = "0">
			 <cfelse>
			  <cfset d = "#numberformat(Data.Amount,'____.__')#"> 
			 </cfif>
			 						 
			 <cfchartdata item="#Description#" value="#d#">
			 			 
			 </cfloop>
			 
		 </cfchartseries>
				 
		</cfchart>
		

		</td></tr>
		
		<tr><td colspan="2"></td></tr>
		
</cfoutput>
		
</table>
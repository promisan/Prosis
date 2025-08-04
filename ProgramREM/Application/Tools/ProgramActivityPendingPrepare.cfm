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
 
<cfparam name="UnitFilter" default="">
<cfparam name="DateFilter" default="">
 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending#FileNo#"> 

<!--- ----------------------------------------------- --->  	   		
<!--- retrieve the last progress report for an output --->
<!--- ----------------------------------------------- --->

<cfsavecontent variable="lastoutputreported">
		  
    <cfoutput>
	 SELECT   P.Mission, 
			  O.OutputId, 
			  MAX(O.Created) AS LastSubmitted 				 
	 FROM     ProgramActivityProgress O, Program P
	 WHERE    P.ProgramCode = O.ProgramCode	
	 AND      P.#preserveSingleQuotes(ProgramFilter)#			
	 <cfif DateFilter neq "">
	 AND      #preserveSingleQuotes(DateFilter)# 
	 </cfif> 
	 <!--- valid progress report --->
	 AND      O.RecordStatus != '9'  
	
	 GROUP BY P.Mission,
	          O.OutputId 
	</cfoutput>		  
						
</cfsavecontent>
  
<!---
<cfoutput>1.#now()#:#cfquery.executionTime#<br></cfoutput>
--->
 
<!--- retrieve all activities of which the defined output is not in the table completed for each last output report --->

<cfquery name="IncompleteActivity" 
 datasource="AppsProgram" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT DISTINCT 
	        O.ProgramCode,
			(SELECT PeriodParentCode
			 FROM   ProgramPeriod
			 WHERE  ProgramCode = P.ProgramCode
			 AND    Period      = '#url.period#') as ParentCode,			
			O.ActivityPeriod, 
			O.ActivityId, 
	        'Pending' AS Status, 
		    PA.ActivityDateStart, 
			PA.ActivityDate,
			PA.ActivityDescription,
			PA.ActivityWeight,
			PA.OrgUnit
	 INTO   userQuery.dbo.#SESSION.acc#ActivityPending#FileNo#		
	 FROM   ProgramActivity PA INNER JOIN
	        Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
	        ProgramActivityOutput O ON PA.ProgramCode = O.ProgramCode AND PA.ActivityPeriod = O.ActivityPeriod AND PA.ActivityId = O.ActivityId 
	 WHERE  <!--- only valid projects --->	
	         PA.ProgramCode NOT IN  (SELECT  ProgramCode 
									 FROM    ProgramPeriod 
									 WHERE   ProgramCode = PA.ProgramCode
									 AND     Period      = PA.ActivityPeriod 
									 AND     RecordStatus = '9' ) 	  	 
	  AND   O.#preserveSingleQuotes(ProgramFilter)#	
	  
	  AND    PA.ActivityPeriod = '#url.period#' <!--- added to show only this periods activities --->
	  <cfif UnitFilter neq "">
	    AND #preserveSingleQuotes(UnitFilter)# 
	 </cfif>	
	 
	 <!--- ---------------------------------------------------------------- --->
	 <!--- ----- exclude activities that are reported as completed -------- --->
	 <!--- ---------------------------------------------------------------- --->
	 
	  AND   O.OutputId NOT IN (  
	  
					     <!--- select output which is completed based on the last progress report --->
					   	
					     SELECT   Pr.OutputId 		
						 FROM     ProgramActivityProgress Pr,
						          (#preservesinglequotes(lastoutputreported)#) as Last 
						 WHERE    Pr.OutputId  = Last.OutputId 
				        	AND   Pr.Created   = Last.LastSubmitted
							<!--- get only the completed ones --->
						    AND   Pr.ProgressStatus = (SELECT DISTINCT ProgressCompleted 
							                           FROM   Ref_ParameterMission 
													   WHERE  Mission = Last.Mission) 
							<!--- excluded the diabled progress reports --->						   
						    AND   Pr.RecordStatus != '9' 		
	                        AND   Pr.ProgramCode     = O.ProgramCode
				            AND   Pr.ActivityPeriod  = O.ActivityPeriod
							AND   Pr.OutputId = O.OutputId
	
							)
					  
							   
							   
	  <!--- only valid acitivties --->					   
	  AND   PA.RecordStatus <> '9' 
	  <!--- only valid outputs --->				
	  AND   O.RecordStatus  <> '9'	
 	 
</cfquery>

 <!---	
 <cfoutput>2.#now()#:#cfquery.executionTime#<br></cfoutput>
 --->

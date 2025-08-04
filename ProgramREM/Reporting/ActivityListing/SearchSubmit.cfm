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
<!--- store search request --->

<cfparam name="Form.Description" default="New Search">

    <cfquery name="Clear" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE ProgramSearch WHERE Status = '0' AND OfficerUserId = '#SESSION.acc#'
     </cfquery>

  <cfquery name="AssignNo" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Parameter SET SearchNo = SearchNo+1
     </cfquery>

  <cfquery name="LastNo" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM Parameter</cfquery>
	 
   <cfset LastNo = #LastNo.SearchNo#>
   
   <cfquery name="InsertSearch" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearch
         (SearchId,
		 SearchCategory,
		 Description,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
      VALUES ('#LastNo#',
	      'Activity',
	      '#Form.Description#', 
          '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.dateSQL)#')
    </cfquery>
	
	<cfparam name="URL.ID" default="#LastNo#">
	

<!--- ---------------------- --->			
<!--- ----- insert code --- --->

<cfif #Form.ProgramCode# neq "">
      <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'ProgramCode', 
          '#Form.ProgramCode#','#Form.ProgramCode#','3')
    </cfquery>
</cfif>	

<cfif #Form.ProgramName# neq "">
      <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'ProgramName', 
          '#Form.ProgramName#','#Form.ProgramName#','3')
    </cfquery>
</cfif>	

<cfif #Form.ProgramGoal# neq "">
      <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'ProgramGoal', 
          '#Form.ProgramGoal#','#Form.ProgramGoal#','3')
    </cfquery>
</cfif>	

	
<!--- ------------------------------------ --->		
<!--- insert criteria category operator --->

<cfparam name="Form.CategoryStatus" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'CategoryOperator', 
          '#Form.CategoryStatus#','#Form.CategoryStatus#','3')
      </cfquery>

<!--- insert category entries --->

<cfparam name="Form.Category" type="any" default="">

<cfloop index="Item" 
        list="#Form.Category#" 
        delimiters="' ,">
		
			<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Category', 
          '#Item#','3')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramSearchLine
	 SET    SelectDescription = S.Description
	 FROM   ProgramSearchLine INNER JOIN Ref_ProgramCategory S ON ProgramSearchLine.SelectId =  S.Code 
	 WHERE  ProgramSearchLine.SearchId = '#URL.ID#'
	 AND    ProgramSearchLine.SearchClass = 'Category'
    </cfquery>
</cfloop>		


<!--- ------------------------------------ --->		
<!--- insert criteria funding operator --->

<cfparam name="Form.FundingStatus" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'FundingOperator', 
          '#Form.FundingStatus#','#Form.FundingStatus#','3')
      </cfquery>

<!--- insert funding entries --->

<cfparam name="Form.Funding" type="any" default="">

<cfloop index="Item" 
        list="#Form.Funding#" 
        delimiters="' ,">
		
			<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Funding', 
          '#Item#','3')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramSearchLine
	 SET    SelectDescription = S.Description
	 FROM   ProgramSearchLine INNER JOIN Ref_Fund S ON ProgramSearchLine.SelectId =  S.Code 
	 WHERE  ProgramSearchLine.SearchId = '#URL.ID#'
	 AND    ProgramSearchLine.SearchClass = 'Funding'
    </cfquery>
</cfloop>	



>>>>>
<!--- ------------------------------------ --->		
<!--- insert criteria Resource operator --->

<cfparam name="Form.ResourceStatus" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
        VALUES ('#URL.ID#',
	       'ResourceOperator', 
          '#Form.ResourceStatus#','#Form.ResourceStatus#','3')
      </cfquery>

<!--- insert Resource entries --->

<cfparam name="Form.Resource" type="any" default="">

<cfloop index="Item" 
        list="#Form.Resource#" 
        delimiters="' ,">
		
			<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Resource', 
          '#Item#','3')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramSearchLine
	 SET    SelectDescription = S.Description
	 FROM   ProgramSearchLine INNER JOIN Ref_Resource S ON ProgramSearchLine.SelectId =  S.Code 
	 WHERE  ProgramSearchLine.SearchId = '#URL.ID#'
	 AND    ProgramSearchLine.SearchClass = 'Resource'
    </cfquery>
</cfloop>	

<!--- ------------------------------------ --->		
<!--- insert criteria mission operator --->

<cfparam name="Form.MissionStatus" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'MissionOperator', 
          '#Form.MissionStatus#','#Form.MissionStatus#','3')
      </cfquery>

<!--- insert mission entries --->

<cfparam name="Form.Mission" type="any" default="">

<cfloop index="Item" 
        list="#Form.Mission#" 
        delimiters="',">
		
			<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Mission', 
          '#Item#','3')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramSearchLine
	 SET    SelectDescription = S.MissionName
	 FROM   ProgramSearchLine INNER JOIN Organization.dbo.Ref_Mission S ON ProgramSearchLine.SelectId =  S.Mission
	 WHERE  ProgramSearchLine.SearchId = '#URL.ID#'
	 AND    ProgramSearchLine.SearchClass = 'Mission'
    </cfquery>
</cfloop>	



<!--- ------------------------------------ --->		
<!--- insert period operator --->

<cfparam name="Form.PeriodStatus" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'PeriodOperator', 
          '#Form.PeriodStatus#','#Form.PeriodStatus#','3')
      </cfquery>

<!--- insert period entries --->

<cfparam name="Form.Period" type="any" default="">

<cfloop index="Item" 
        list="#Form.Period#" 
        delimiters="',">
		
			<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Period', 
          '#Item#','3')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramSearchLine
	 SET    SelectDescription = S.Description
	 FROM   ProgramSearchLine INNER JOIN Ref_Period S ON ProgramSearchLine.SelectId =  S.Period
	 WHERE  ProgramSearchLine.SearchId = '#URL.ID#'
	 AND    ProgramSearchLine.SearchClass = 'Period'
    </cfquery>
</cfloop>	


<!--- ------------------------------------ --->		
<!--- insert activyclass operator --->

<cfparam name="Form.ActivityClassStatus" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'ClassOperator', 
          '#Form.ActivityClassStatus#','#Form.ActivityClassStatus#','3')
      </cfquery>

<!--- insert activity class entries --->

<cfparam name="Form.ActivityClass" type="any" default="">

<cfloop index="Item" 
        list="#Form.ActivityClass#" 
        delimiters="',">
		
			<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Class', 
          '#Item#','3')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramSearchLine
	 SET    SelectDescription = S.Description
	 FROM   ProgramSearchLine INNER JOIN Ref_ActivityClass S ON ProgramSearchLine.SelectId =  S.Code
	 WHERE  ProgramSearchLine.SearchId = '#URL.ID#'
	 AND    ProgramSearchLine.SearchClass = 'Class'
    </cfquery>
</cfloop>	

<!--- ------------------------------------ --->		

<!--- insert activydate range operator --->

<cfparam name="Form.ActivityDates" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'DateOperator', 
          '#Form.ActivityDates#','#Form.ActivityDates#','3')
      </cfquery>

<!--- insert subperiod entry --->

<cfparam name="Form.StartDate" type="any" default="">

<cfif #Form.ActivityDates# eq "SPECIFIC">

<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
      VALUES ('#URL.ID#',
	       'StartDate', 
          '#Form.StartDate#','#Form.StartDate#','3')
    </cfquery>
	
<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
      VALUES ('#URL.ID#',
	       'EndDate', 
          '#Form.EndDate#','#Form.EndDate#','3')
    </cfquery>

</cfif>
									
<!--- insert Status entry --->

<cfparam name="Form.ActivityStatus" type="any" default="">

<cfif #Form.ActivityStatus# neq "">

<cfquery name="Insert" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Status', 
          '#Form.ActivityStatus#','3')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramSearchLine
	 SET    SelectDescription = S.Description
	 FROM   ProgramSearchLine INNER JOIN Ref_Status S 
	 	ON ProgramSearchLine.SelectId =  S.Status
		AND S.ClassStatus = 'Progress'
	 WHERE  ProgramSearchLine.SearchId = '#URL.ID#'
	 AND    ProgramSearchLine.SearchClass = 'Status'
    </cfquery>
</cfif>
								
		
<cflocation url="QuerySearch.cfm?ID=#URL.ID#&Mission=#URL.Mission#" addtoken="No">
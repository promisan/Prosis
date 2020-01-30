<!--- store search request --->

<cfparam name="Form.Description" default="New Search">

    <cfquery name="Clear" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE PersonSearch WHERE Status = '0' AND OfficerUserId = '#SESSION.acc#'
     </cfquery>

  <cfquery name="AssignNo" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Parameter SET SearchNo = SearchNo+1
     </cfquery>

  <cfquery name="LastNo" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM Parameter</cfquery>
	 
   <cfset LastNo = #LastNo.SearchNo#>
   
   <cfquery name="InsertSearch" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonSearch
         (SearchId,
		 Description,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
      VALUES ('#LastNo#',
	       '#Form.Description#', 
          '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.DateSQL)#')
    </cfquery>
	
	<cfparam name="URL.ID" default="#LastNo#">

<!--- insert criteria class --->

<cfparam name="Form.EmployeeStatus" type="any" default="">

  	   <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'Status', 
          '#Form.EmployeeStatus#','#Form.EmployeeStatus#', '3')
       </cfquery>
	
<!--- ---------------------- --->			
<!--- ----- insert index --- --->

<cfif #Form.IndexNo# neq "">
<cfparam name="Form.Status" type="any" default="">
      <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'IndexNo', 
          '#Form.IndexNo#','#Form.IndexNo#','3')
    </cfquery>
</cfif>	

<cfif #Form.LastName# neq "">
      <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'LastName', 
          '#Form.LastName#','#Form.LastName#','3')
    </cfquery>
</cfif>	

<cfif #Form.FirstName# neq "">
      <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'FirstName', 
          '#Form.FirstName#','#Form.FirstName#','3')
    </cfquery>
</cfif>	

<cfif #Form.ContractExpiration# neq "">
      <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'ContractExpiration', 
          '#Form.ContractExpiration#','#Form.ContractExpiration#','3')
    </cfquery>
</cfif>	
	
<!--- ---------------------- --->			
<!--- insert criteria gender --->

<cfparam name="Form.Gender" type="any" default="">
  	   <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'Gender', 
          '#Form.Gender#','#Form.Gender#','3')
    </cfquery>
	
<!--- ------------------------------------ --->		
<!--- insert criteria nationality operator --->

<cfparam name="Form.NationalityStatus" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'NationalityOperator', 
          '#Form.NationalityStatus#','#Form.NationalityStatus#','3')
      </cfquery>

<!--- insert nationality entries --->

<cfparam name="Form.Nationality" type="any" default="">

<cfloop index="Item" 
        list="#Form.Nationality#" 
        delimiters="' ,">
		
			<cfquery name="Insert" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Nationality', 
          '#Item#','3')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE PersonSearchLine
	 SET SelectDescription = S.Name
	 FROM PersonSearchLine INNER JOIN System.dbo.Ref_Nation S ON PersonSearchLine.SelectId =  S.Code 
	 WHERE PersonSearchLine.SearchId = '#URL.ID#'
	 AND   PersonSearchLine.SearchClass = 'Nationality'
    </cfquery>
</cfloop>			

<!--- ----------------------------------- --->		
<!--- insert criteria Mission operator --->

<cfparam name="Form.SalaryScheduleStatus" type="any" default="">

   	   <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
        VALUES ('#URL.ID#',
	       'SalaryGroupOperator', 
          '#Form.SalaryScheduleStatus#','#Form.SalaryScheduleStatus#','3')
    </cfquery>
		
<!--- insert language entries --->

<cfparam name="Form.SalarySchedule" type="any" default="">

<cfloop index="Item" 
        list="#Form.SalarySchedule#" 
        delimiters="' ,">
		
			<cfquery name="Insert" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
      VALUES ('#URL.ID#',
	       'SalaryGroup', 
          '#Item#','#Item#', '3')
    </cfquery>
		
	
</cfloop>	

<!--- ----------------------------------- --->		
<!--- insert criteria grade operator --->

<cfparam name="Form.GradeStatus" type="any" default="">

  	   <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'GradeOperator', 
          '#Form.GradeStatus#','#Form.GradeStatus#','3')
       </cfquery>
	   	   
<!--- insert grade entries --->

<cfparam name="Form.Grade" type="any" default="">

<cfloop index="Item" 
        list="#Form.Grade#" 
        delimiters="' ,">
		
			<cfquery name="Insert" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
      VALUES ('#URL.ID#',
	       'Grade', 
          '#Item#','#Item#', '3')
    </cfquery>
		
</cfloop>	

<!--- ----------------------------------- --->		
<!--- insert criteria grade operator --->

<cfparam name="Form.TriggerStatus" type="any" default="">

  	   <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'TriggerOperator', 
          '#Form.TriggerStatus#','#Form.TriggerStatus#','3')
       </cfquery>
	   	   
<!--- insert trigger entries --->

<cfparam name="Form.Trigger" type="any" default="">

<cfloop index="Item" 
        list="#Form.Trigger#" 
        delimiters="' ,">
		
			<cfquery name="Insert" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
      VALUES ('#URL.ID#',
	       'Trigger', 
          '#Item#','#Item#', '3')
    </cfquery>
		
</cfloop>	

		
<cflocation url="QuerySearch2.cfm?ID=#URL.ID#&Mission=#URL.Mission#" addtoken="No">
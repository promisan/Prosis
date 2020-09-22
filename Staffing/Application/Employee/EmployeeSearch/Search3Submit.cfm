<!--- store search request --->

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

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

<cfif #Form.FullName# neq "">
      <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'FullName', 
          '#Form.FullName#','#Form.FullName#','3')
    </cfquery>
</cfif>	

<cfif Form.ContractExpiration neq "">
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
        delimiters="',">
		
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

<cfparam name="Form.MissionStatus" type="any" default="">

   	   <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
        VALUES ('#URL.ID#',
	       'MissionOperator', 
          '#Form.MissionStatus#','#Form.MissionStatus#','3')
    </cfquery>
		
<!--- insert language entries --->

<cfparam name="Form.Mission" type="any" default="">

<cfloop index="Item" 
        list="#Form.Mission#" 
        delimiters="',">
		
			<cfquery name="Insert" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
      VALUES ('#URL.ID#',
	       'Mission', 
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
        delimiters="',">
		
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

<cfparam name="Form.PostTypeStatus" type="any" default="">

  	   <cfquery name="Insert" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO PersonSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'CategoryOperator', 
          '#Form.PostTypeStatus#','#Form.PostTypeStatus#','3')
       </cfquery>
	   	   
<!--- insert category entries --->

<cfparam name="Form.PostType" type="any" default="">

<cfif Form.PostType neq "" or getAdministrator(url.mission) eq "1">
     <cfset listPte = Form.PostType>
<cfelse>   
     <cfset listPte = Form.PteMaxForm>
</cfif>

<cfloop index="Item" 
        list="#listPte#" 
        delimiters="',">
		
			<cfquery name="Insert" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonSearchLine
         (SearchId,SearchClass,SelectId, SelectDescription, SearchStage)
      VALUES ('#URL.ID#','Category','#Item#','#Item#','3')
    </cfquery>
		
</cfloop>	

<cfinclude template="QuerySearch3.cfm">

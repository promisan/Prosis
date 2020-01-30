
<!--- store search request --->
	
    <cfquery name="Clear" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     DELETE RosterSearch 
		 FROM   RosterSearch S
   		 WHERE  Status = '0' 
		 AND    OfficerUserId = '#SESSION.acc#'
		 AND    SearchId NOT IN (SELECT SearchId 
		                         FROM   RosterSearchLine
								 WHERE  SearchId = S.SearchId)
     </cfquery>

	<cfquery name="AssignNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     	UPDATE Parameter SET SearchNo = SearchNo+1
     </cfquery>

	<cfquery name="LastNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT *
	     FROM Parameter
	</cfquery>
	 
   	<cfset LastNo = LastNo.SearchNo>
        
   	<cfquery name="InsertSearch" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO RosterSearch
		         (SearchId,
				 Description,
				 Mode,
				 Owner,
				 SearchCategory,
				 SearchCategoryId,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
	      VALUES ('#LastNo#',
			      'Shortlist', 		  
				  '#URL.Mode#',
				  '#URL.Owner#',
				  'Vacancy',
				  '#URL.DocNo#',
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  '#DateFormat(Now(),CLIENT.DateSQL)#')
      </cfquery>
	
	  	<!--- insert criteria --->

     	<cfquery name="Vacancy" 
        datasource="AppsVacancy" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
	        SELECT *
			FROM   Document
			WHERE  DocumentNo = '#URL.DocNo#'
        </cfquery>

<!--- see comment on line 97.. --->
		
<cfset url.id = lastno>		
<cfset url.mode = "vacancy">
<cfset url.functionno = Vacancy.FunctionNo>
<cfinclude template="Search2Shortlist.cfm">
				
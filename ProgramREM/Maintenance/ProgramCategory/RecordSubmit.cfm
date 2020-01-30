
<!--- define parent of parent --->
	
	<cfset PCode        = "#Form.Code#">
	<cfset PDescription = "#Form.Description#">
	
	<cfquery name="Parent" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ProgramCategory
	WHERE Code = '#Form.Parent#'
    </cfquery>
	
	<cfif Parent.recordCount neq "0">
	
    	<cfset PCode        = "#Parent.Code#">
    	<cfset PDescription = "#Parent.Description#">
				
		<cfif Parent.Parent neq "">
		
			<cfquery name="Parent" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ProgramCategory
			WHERE Code = '#Parent.Parent#'
		    </cfquery>
			
			<cfif Parent.recordCount neq "0">
	
				<cfset PCode        = Parent.Code>
				<cfset PDescription = Parent.Description>
			
			</cfif>
			
		</cfif>  
		
	</cfif>	

<cfif ParameterExists(Form.Insert)> 

	<cfparam name="Form.EarmarkPercentage" default="0">
	<cfparam name="Form.ProgramClass" default="">
	
	<cfset code = replaceNoCase(Form.Code," ","","ALL")>
	
	<cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ProgramCategory
	WHERE  Code  = '#Code#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("A classification record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   			
	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_ProgramCategory
	         (code,
			 Description,
			 Parent,
			 AreaCode,
			 Area,
			 ProgramClass,
			 Listingorder,
			 EntryMode,
			 EarmarkPercentage,
			 DescriptionMemo, 
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	    VALUES ('#Code#',
	          '#Form.Description#', 
			  '#Form.Parent#',
			  '#PCode#',
		      '#PDescription#',
			  <cfif Form.ProgramClass neq "">
			  '#Form.ProgramClass#',
			  <cfelse>
			  NULL,
			  </cfif>			
			  '#Form.Listingorder#',
			  '#Form.EntryMode#',
			  '#Form.EarmarkPercentage#',
			  '#Form.DescriptionMemo#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	  </cfquery>
	  
	  <cfparam name="form.missionselect" default="">
			
	  <cfloop index="itm" list="#form.missionselect#">
		
			<cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ParameterMissionCategory
		         (Category,
				 Mission,		
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		    VALUES ('#Code#',
		          '#itm#', 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
			</cfquery>
		  	
	  </cfloop> 
	  
	  <cfset vThisCategory = Code>
	  <cfinclude template="ClassificationDetailSubmit.cfm">
		  
	  <cfoutput>	  
	  <script language="JavaScript">
   	     window.location = "recordadd.cfm?idmenu=#url.idmenu#&parent=#Form.Parent#"		
		 opener.history.go()	        
	  </script>  
	  </cfoutput>
		  
     </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cftransaction>

	<cfparam name="Form.EarmarkPercentage" default="0">
	<cfparam name="Form.DescriptionMemo"   default="">
	<cfparam name="Form.ProgramClass"      default="">
	<cfparam name="Form.Operational"       default="0">
	<cfparam name="Form.EnableTarget"      default="0">
		
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ProgramCategory
	SET   Code              = '#Form.code#',
	      Description       = '#Form.Description#',
		  Parent            = '#Form.Parent#',
		  AreaCode          = '#PCode#',
		  Area              = '#PDescription#',
		  DescriptionMemo   = '#Form.DescriptionMemo#',
		  EnableTarget      = '#Form.EnableTarget#',
		  <cfif Form.ProgramClass neq "">
		  ProgramClass      = '#Form.ProgramClass#',
		  <cfelse>
		  ProgramClass      = NULL,
		  </cfif>
		  Listingorder      = '#Form.ListingOrder#',
		  Operational       = '#Form.Operational#',
		  EntryMode		    = '#Form.EntryMode#',
		  EarmarkPercentage = '#Form.EarmarkPercentage#'
	WHERE Code              = '#Form.CodeOld#' 
	</cfquery>
	
	<cfparam name="form.missionselect" default="">
	
	<cfquery name="Clean" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ParameterMissionCategory
		WHERE Category = '#Form.code#'
	</cfquery>
	
	<cfquery name="MissionList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *	   
		FROM   Ref_ParameterMission L
		WHERE Mission IN (SELECT Mission 
		                  FROM   Organization.dbo.Ref_MissionModule 
						  WHERE  SystemModule = 'Program')
	</cfquery>
	
	<cfloop query="MissionList">
	
		<cfparam name="mission_#currentrow#" default="">
		<cfset mis = evaluate("mission_#currentrow#")>
		
		<cfparam name="earmark_#currentrow#" default="0">
		<cfset ear = evaluate("earmark_#currentrow#")>
		
		<cfif mis neq "">
					
			<cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ParameterMissionCategory
		         (Category,
				 Mission,	
				 BudgetEarmark,	
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		    VALUES ('#Form.Code#',
		          '#mis#', 
				  '#ear#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
			</cfquery>
		
		</cfif>
	  	
	</cfloop> 
	
	<cfset vThisCategory = Form.code>
	<cfinclude template="ClassificationDetailSubmit.cfm">
		
	</cftransaction>
		
	<cfoutput>
	<script language="JavaScript">
	
	    parent.window.close()
	 	parent.opener.location.reload()
    	        
	</script>  
	</cfoutput>	

</cfif>	

<cfif ParameterExists(Form.Delete)> 

    <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#tmpCategory">

    <cfquery name="CountRec0" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT Code
	  INTO userQuery.dbo.#SESSION.acc#tmpCategory
	  FROM  Ref_ProgramCategory
      WHERE Code = '#Form.codeOld#' 
    </cfquery>
	
	<cfquery name="CountRec1" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      INSERT INTO userQuery.dbo.#SESSION.acc#tmpCategory
	  SELECT Code
	  FROM  Ref_ProgramCategory 
      WHERE Parent IN (SELECT Code FROM userQuery.dbo.#SESSION.acc#tmpCategory) 
    </cfquery>
	
	<cfquery name="CountRec2" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      INSERT INTO userQuery.dbo.#SESSION.acc#tmpCategory
	  SELECT Code
	  FROM  Ref_ProgramCategory 
      WHERE Parent IN (SELECT Code FROM userQuery.dbo.#SESSION.acc#tmpCategory) 
    </cfquery>

	<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT ProgramCategory
      FROM ProgramCategory
      WHERE ProgramCategory IN (SELECT Code FROM userQuery.dbo.#SESSION.acc#tmpCategory) 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Code is in use. Operation aborted.")
		        
	     </script>  
	 
    <cfelse>
					
		<cfquery name="Delete" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_ProgramCategory
			WHERE code IN (SELECT Code FROM userQuery.dbo.#SESSION.acc#tmpCategory) 
	    </cfquery>
		
	</cfif>
	
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#tmpCategory">
	
	<script language="JavaScript">

     parent.window.close()
	 parent.opener.location.reload()
        
	</script>  
		
</cfif>	

<!--- ---------------- --->
<!--- update hierarchy --->
<!--- ---------------- --->
			
	<cfquery name="SearchResult"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *		   
			FROM     Ref_ProgramCategory
			WHERE   (Parent is NULL or Parent = '')
			ORDER BY ListingOrder 
	</cfquery>
		
	<cfset ord = 10>
	
	<cfloop query="SearchResult">
		
			<cfset Ord = Ord + 1>	
					
			<cfquery name="Update"
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     UPDATE  Ref_ProgramCategory
					 SET     HierarchyCode  = '#Ord#' 
					 WHERE   Code = '#Code#'
			</cfquery>
			
			<cfquery name="Sub1"
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT   *
				 FROM     Ref_ProgramCategory
				 WHERE    Parent = '#SearchResult.Code#'
				 ORDER BY ListingOrder
			</cfquery>
			
			<cfset sub = 10>
			
			<cfloop query="sub1">
			
				<cfset sub = sub+1>
			
				<cfquery name="Update"
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     UPDATE  Ref_ProgramCategory
					 SET     HierarchyCode  = '#Ord#.#sub#'
					 WHERE   Code = '#Sub1.Code#' 
				</cfquery>
				
				<cfquery name="Sub2"
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT   *
				 FROM     Ref_ProgramCategory
				 WHERE    Parent = '#sub1.Code#'
				 ORDER BY ListingOrder
				</cfquery>
				
				<cfset subsub = 10>
				
				<cfloop query="sub2">
				
					<cfset subsub = subsub+1>
				
					<cfquery name="Update"
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     UPDATE  Ref_ProgramCategory
						 SET     HierarchyCode  = '#Ord#.#sub#.#subsub#'
						 WHERE   Code = '#Sub2.Code#' 
					</cfquery>
				
				</cfloop>			
								
			</cfloop>
				
	</cfloop>




<cf_compression>

<!--- check --->
<cfquery name="Class" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_AuthorizationRole
	 WHERE  Role = '#URL.Role#'	  
</cfquery>
	
<cfif url.op eq "True">
	  <cfset op = 1>
<cfelse>
      <cfset op = 0>	  
</cfif>

<cfif url.del eq "True">
	  <cfset del = 1>
<cfelse>
      <cfset del = 0>	  
</cfif>

<cftransaction action="BEGIN">

<cfif URL.ID1 eq "">

	<cfquery name="Insert" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Ref_ReportControlRole 
	         (ControlId,
			 Role,
			 ClassParameter,			 
			 Delegation,
			 Operational,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#URL.ID#',
	      	  '#url.Role#',
			   <cfif class.Parameter eq "Owner">
			  '#url.param#',
			  <cfelse>
			  NULL,
			  </cfif>
			  '#del#',
			  '#op#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#') 
	</cfquery>
	
	<cfset url.id1 = url.role>
	
<cfelse>
	
	   <cfquery name="Update" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE Ref_ReportControlRole
		  SET Operational = '#op#', 
		      <cfif class.Parameter eq "Owner">
		      ClassParameter = '#param#',
			  </cfif>
		      Delegation= '#del#' 			 
		 WHERE ControlId = '#URL.ID#'
		 AND Role = '#URL.ID1#' 
    	</cfquery>
				
		<cfquery name="Update" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    DELETE FROM Ref_ReportControlRoleMission		
		    WHERE ControlId = '#URL.ID#'
			AND   Role = '#URL.ID1#' 
		</cfquery>
			
</cfif>

<cfparam name="Form.Missionsel" default="">

<cfif Form.MissionSel neq "">

	<cfloop index="mis" list="#form.missionsel#">

		<cfquery name="Insert" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    INSERT INTO Ref_ReportControlRoleMission		
			(ControlId,Role,Mission) 
			VALUES ('#URL.ID#','#URL.ID1#','#mis#')
		</cfquery>
		
	</cfloop>	

</cfif>

</cftransaction>

<cfset url.id1 = "">

<cfinclude template="Role.cfm">
 
   

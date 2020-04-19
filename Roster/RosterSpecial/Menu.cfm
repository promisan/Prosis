<cf_divscroll>
<cf_screentop label="Special Rosters" html="No" height="100%" ValidateSession="No">

<cf_submenuLogo module="Roster" selection="Process">

<!--- provision to add acdess to general roster --->

<cfquery name="Check" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
 SELECT TOP 1 Created
 FROM   RosterAccessAuthorization
 WHERE  UserAccount = '#SESSION.acc#'
</cfquery>	

<cfif check.recordcount eq "0">
    <cfinclude template="RosterView/RosterViewAccess.cfm">
</cfif>

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfquery name="OwnerList" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_ParameterOwner P
	WHERE  Operational = 1
	
	AND   Owner IN (SELECT owner FROM Ref_SubmissionEdition WHERE Owner = P.Owner)
	
	<!--- 18/3/2010 removed the condition --->
	
	<cfif SESSION.isAdministrator eq "No">
	
	AND (
	
		    Owner IN (SELECT DISTINCT A.ClassParameter
				      FROM  Organization.dbo.OrganizationAuthorization A 
			          WHERE A.UserAccount = '#SESSION.acc#'
					  AND   A.ClassParameter = P.Owner
				      AND   A.Role = 'AdminRoster')
	
	    OR
	
			Owner IN (SELECT DISTINCT S.Owner
				  FROM  RosterAccessAuthorization A INNER JOIN
                        FunctionOrganization FO ON A.FunctionId = FO.FunctionId INNER JOIN
                        Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition
			      WHERE A.UserAccount = '#SESSION.acc#'
				  AND   S.Owner = P.Owner)
				  
		OR
				
			Owner IN (SELECT DISTINCT A.ClassParameter
            	  FROM   Organization.dbo.OrganizationAuthorization A
		          WHERE  A.Role = 'OrgUnitManager' 
				  AND    A.AccessLevel = '3'
				  AND    A.UserAccount = '#SESSION.acc#')
		
		OR 
	 
	        Owner IN (SELECT  AccountOwner
                  		FROM  System.dbo.UserNames
		                WHERE Account = '#SESSION.acc#') 
					
		)		
		
	 </cfif>	
	 		 
</cfquery>


<table width="94%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="5"></td></tr>

<div id="modulelog"></div>

<tr><td>

<table width="99%" align="center">

<cfquery name="Function" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Ref_ModuleControl
		WHERE  SystemModule = 'Roster'
		AND    FunctionClass = 'Roster'
		AND    FunctionName = 'General Roster'		
</cfquery>	
	
<cfloop query="OwnerList">

	<cfset own    = "#Owner#">
	<cfset show   = "#DefaultRosterShow#">
	<cfset roster = "#DefaultRoster#">
			
	<cfquery name="Step" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Ref_StatusCode R
		WHERE  R.Owner = '#Own#'
		AND    RosterAction = '1'
		AND    ID = 'Fun'
	</cfquery>
	
	<cfset st = "'0'">
	
	<cfloop query="Step">
	
	    <cfif st eq "">
			<cfset st = "'#Status#'">
		<cfelse>
			<cfset st = "#st#,'#Status#'">
		</cfif>
	    
	</cfloop>	
	
	<cfif SESSION.isAdministrator eq "Yes" or findNoCase(own,SESSION.isOwnerAdministrator)>
	
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT  *
				FROM    Ref_SubmissionEdition E
				WHERE   E.Owner = '#Own#'
				<cfif show eq "0">
				AND     E.SubmissionEdition != '#roster#'
				</cfif>				
				AND     E.Operational = 1 
		</cfquery>
		
	<cfelse>
		
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
				SELECT  DISTINCT FO.SubmissionEdition, 
				        E.EditionDescription, 
						E.ExerciseClass
				FROM    RosterAccessAuthorization A, 
				        FunctionOrganization FO, 
						Ref_SubmissionEdition E
				WHERE   FO.FunctionId = A.FunctionId
				AND     A.UserAccount = '#SESSION.acc#'
				AND     A.AccessLevel in (#preserveSingleQuotes(st)#)
				AND     FO.SubmissionEdition = E.SubmissionEdition
				<cfif show eq "0">
					AND     Fo.SubmissionEdition != '#roster#'
				</cfif>
				AND     E.Owner = '#Own#'
				AND     E.Operational = 1 
				
								
				UNION
				
				<!--- ------------------------------------------------ --->
				<!--- access granted through a posttype of the edition --->
				<!--- ------------------------------------------------ --->
				
				SELECT  R.SubmissionEdition, 
				        R.EditionDescription, 
						R.ExerciseClass
				FROM    Organization.dbo.OrganizationAuthorization AS OA INNER JOIN
                        Ref_SubmissionEdition AS R ON OA.ClassParameter = R.PostType INNER JOIN
                        Organization.dbo.Ref_Mission AS M ON OA.Mission = M.Mission AND R.Owner = M.MissionOwner
				WHERE   OA.UserAccount = '#SESSION.acc#' AND OA.Role = 'VacOfficer'		
				AND     R.Owner = '#Own#'	
				AND     R.Operational = 1 		
				
				UNION
				
				SELECT  R.SubmissionEdition, 
				        R.EditionDescription, 
						R.ExerciseClass
				FROM    Organization.dbo.OrganizationAuthorization AS OA INNER JOIN
                        Ref_SubmissionEdition AS R ON OA.ClassParameter = R.Owner 
				WHERE   OA.UserAccount = '#SESSION.acc#' 
				AND     OA.Role = 'AdminRoster'		
				AND     R.Owner = '#Own#'	
				AND     R.Operational = 1 			
				
		</cfquery>
	
	</cfif>	
			
		 <tr class="line"><td colspan="6" style="padding-left:2px;height:38px;font-size:25px" class="labelmedium">
		 
		 <cfquery name="OwnerName" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
			    FROM   Ref_AuthorizationRoleOwner
				WHERE Code = '#own#'
			</cfquery>
		 
		    <cfoutput>#OwnerName.Description#</cfoutput>
			</td>
		</tr>
		   		
			
	  <cfif Check.recordcount gte "1">
					  
		   <cfset row = 0>
		   <cfoutput query="Check">
		  
			    <cfset row = row + 1>
			  	<cfset module 			 = "'Roster'">
				<cfset class 			 = "'Special'">
				<cfset menuclass 		 = "Special">
				<cfset functionClass     = "Maintain">
				<cfset functionTarget    = "_blank">
				<cfset functionName      = "#EditionDescription#">
				<cfset functionMemo      = "#ExerciseClass#">
				<cfset functionIcon      = "roster">
				<cfset functionPath      = "RosterView/RosterView.cfm">
				<cfset functionCondition = "systemfunctionid=#function.systemfunctionid#&owner=#own#&mode=generic&edition=#SubmissionEdition#">
				<cfinclude template      = "../../Tools/SubmenuRoster.cfm">
			   	   
			    <cfif row eq "2">
			     	 <cfset row = "0">
			    </cfif>	 
		         
		    </cfoutput>
			
			
		<cfelse>
			 			
			<tr><td align="center" height="30" class="labelmedium"><font color="gray">There are no editions to show in this view.</td></tr>
						
		</cfif>
					
</cfloop>

	</table>   	
	
	</tr>
	
</table>
</cf_divscroll>
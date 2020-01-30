
<cfif not ParameterExists(Form.Crit0_FieldName)> 
      Search aborted.
	  <cfabort>
</cfif>	

<cfparam name="missionselect" default="">
<cfparam name="form.Crit9_Value" default="">
<cfparam name="form.Crit5_Value" default="1">

<cfif Form.Crit5_Value eq "1">
    <cfset missionselect = form.mission>	
	<cfset SESSION.staffsearch["mission"] = missionselect>	
<cfelse>
	<cfset missionselect = "">
</cfif>

<cfset SESSION.staffsearch["IndexNo"] = Form.Crit1_Value>	

<CFSET Criteria = ''>

<CF_Search_AppendCriteria
    FieldName="#Form.Crit0_FieldName#"
    FieldType="#Form.Crit0_FieldType#"
    Operator="#Form.Crit0_Operator#"
    Value="#Form.Crit0_Value#">
			
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1a_FieldName#"
    FieldType="#Form.Crit1a_FieldType#"
    Operator="#Form.Crit1a_Operator#"
    Value="#Form.Crit1a_Value#">	
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3a_FieldName#"
    FieldType="#Form.Crit3a_FieldType#"
    Operator="#Form.Crit3a_Operator#"
    Value="#Form.Crit3a_Value#">	
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3b_FieldName#"
    FieldType="#Form.Crit3b_FieldType#"
    Operator="#Form.Crit3b_Operator#"
    Value="#Form.Crit3b_Value#">		
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">	
		
<cfparam name="Form.Nationality" default="">	

<cfparam name="Form.Days_Value" default="30">	

<cfset days = form.days_value>

<cfset nmc = "">

<cfif Form.Crit2_Value neq "">

	<cfset value = Form.Crit2_Value>
		
	<CFSET Value = Replace( Value, "'", "''", "ALL" )>

	<CFIF Form.Crit2_Operator is 'EQUAL'>       <CFSET name = " = '#Value#' #CLIENT.Collation# ">
		<CFELSEIF Form.Crit2_Operator is 'NOT_EQUAL'>   <CFSET name = " <> '#Value#' #CLIENT.Collation# ">
		<CFELSEIF Form.Crit2_Operator is 'GREATER_THAN'><CFSET name = " > '#Value#' #CLIENT.Collation# ">
		<CFELSEIF Form.Crit2_Operator is 'SMALLER_THAN'><CFSET name = " < '#Value#' #CLIENT.Collation# ">
		<CFELSEIF Form.Crit2_Operator is 'CONTAINS'>    <CFSET name = " LIKE '%#Replace(Value," ","%","ALL")#%' #CLIENT.Collation# ">
		<CFELSEIF Form.Crit2_Operator is 'BEGINS_WITH'> <CFSET name = " LIKE '#Value#%' #CLIENT.Collation# ">
		<CFELSEIF Form.Crit2_Operator is 'ENDS_WITH'>   <CFSET name = " LIKE '%#Value#' #CLIENT.Collation# ">
	</CFIF>

	<cfset name = "(LastName #name# OR MaidenName #name#)">
	
	<cfif Criteria eq "">
	<cfset criteria = name>
	<cfelse>
	<cfset criteria = criteria & "AND" &name>
	</cfif>
	
</cfif>

<cfif Form.Nation IS "0">
     <cfif Form.Nationality IS NOT "">
	     <cfif Criteria eq "">
	          <CFSET Criteria = "Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )">
	      <cfelse>
		      <CFSET Criteria = "#Criteria# AND Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )">	
	     </cfif>
	</cfif>
</cfif>	

<cfoutput>

<cfset dateValue = "">
<cfset vPastYear= DateAdd('yyyy',-1,now()) >
<CF_DateConvert Value="#DateFormat(vPastYear,CLIENT.DateFormatShow)#">
<cfset vPastYear = dateValue>
		
<cfsavecontent variable="LastValidContract">
	
	<cfoutput>
	
		SELECT   PC.PersonNo, 
		         PC.Mission,
			     MAX(PC.DateEffective) as DateEffective		
		FROM     PersonContract PC 
		WHERE    PC.ContractStep >= '01'
		
		<cfif missionselect neq "">
		AND      PC.Mission = '#missionselect#'		
		</cfif>		
		
		AND      PC.ActionStatus IN ('0','1')	<!--- not cancelled --->
		GROUP BY PC.PersonNo, PC.Mission 
		
	</cfoutput>	

</cfsavecontent>


<cfset SESSION.StaffSearch["mode"] = Form.Crit5_Value>
  
<cfinvoke 
  component= "Service.Access"  
  method   = "staffing" 
  role     = "'HROfficer'"
  returnvariable="accessStaffing">

<cfsavecontent variable="qry">
	
	FROM   Person PE
	WHERE  1=1
	<cfif criteria neq ""> 
	
	AND #PreserveSingleQuotes(Criteria)# 	
	
		
	</cfif>
	
	<cfif Form.Crit5_Value neq "0" and missionselect neq "">
	
		 AND PersonNo IN 
	 
	 	<!--- has an active assignment for this mission ---> 
	           (SELECT PersonNo
			    FROM   PersonAssignment PA 
				WHERE  PersonNo = Pe.PersonNo 
				AND    PositionNo IN (SELECT PositionNo 
				                      FROM   Position 
									  WHERE  Positionno = PA.PositionNo 
									  AND    Mission    = '#missionselect#')
				AND    AssignmentStatus IN ('0','1')
				AND    DateExpiration >= getdate()) 				
			
		<cfif Form.Crit9_Value eq "5">
			
			AND Month(BirthDate) = '#Month(now())#'
			AND Day(BirthDate) IN ('#Day(now())#','#Day(now()+1)#')
						
		<cfelseif Form.Crit9_Value eq "2">
			
			AND Personno NOT IN (SELECT Personno 
			                     FROM   System.dbo.UserNames
								 WHERE  PersonNo IS NOT NULL)
								 			
		<cfelseif Form.Crit9_Value eq "7">
		
			<!--- and has an SPA expiration in the coming 30 days --->
		
			AND PersonNo IN (SELECT PersonNo 
						 FROM ( SELECT PersonNo, MAX(DateExpiration) as Expiration
				                FROM   PersonContractAdjustment  
					            WHERE  ActionStatus IN ('0','1')
								GROUP BY PersonNo ) as B
				         WHERE  B.Expiration <= getDate() + #days# 
						 AND    B.Expiration >= getDate() - 10
				        )		  				
			
		<cfelseif Form.Crit9_Value eq "8">
		
		    <!--- step increment --->
		
			AND PersonNo IN (
		 
					SELECT   PC.PersonNo
					FROM     PersonContract PC INNER JOIN (#preserveSingleQuotes(LastValidContract)#) A1
							   ON  PC.PersonNo        = A1.PersonNo 
							   AND PC.Mission         = A1.Mission
						       AND PC.DateEffective   = A1.DateEffective 
					WHERE    PC.StepIncreaseDate >= getDate()- 30
					AND      PC.StepIncreaseDate <= getDate()+ #days# 
					
					<!--- process only if the last record is cleared --->
					AND      PC.ActionStatus  IN ('0','1')	
					
					<!--- added by hanno to prevent we extend beyond the contract --->
					
					AND      (PC.StepIncreaseDate < PC.DateExpiration OR PC.DateExpiration is NULL) 
					
					
					)	
						
		<cfelseif Form.Crit9_Value eq "9">
		
		    <!--- contract expiration --->
		
			AND PersonNo IN (SELECT PersonNo 
						     FROM ( SELECT   PersonNo, MAX(DateExpiration) as Expiration
				                    FROM     PersonContract  
					                WHERE    ActionStatus IN ('0','1')
								    AND      Mission = '#missionselect#'
								    GROUP BY PersonNo ) as B
				             WHERE  B.Expiration <= getDate() + #days#  
						     AND    B.Expiration >= getDate() - 10
				        )		  				 
		
		</cfif>
		
	
	</cfif>
	
	<cfif getAdministrator("*") eq "1">
	
		<!--- no filtering --->

	<cfelse>			
	
	AND
	
	(
	
	 (
	    EXISTS (SELECT 'X' 
	                 FROM   PersonAssignment PA
					 WHERE  PersonNo = PE.PersonNo
					 AND    PA.AssignmentStatus IN ('0','1')
					 AND    PositionNo IN (SELECT PositionNo 
					                       FROM   Position 
										   WHERE  Positionno = PA.PositionNo
										   AND    Mission IN (SELECT DISTINCT Mission 
										                      FROM   Organization.dbo.OrganizationAuthorization 
														 	  WHERE  UserAccount = '#SESSION.acc#'
															  AND    Role IN (SELECT Role
															                  FROM   Organization.dbo.Ref_AuthorizationRole
																		      WHERE  SystemModule = 'Staffing')
															)
										)
					)		
					
		OR
		
		EXISTS (SELECT 'X' 
		             FROM   PersonContract PC
					 WHERE  PC.PersonNo = PE.PersonNo
					 AND    PC.ActionStatus != '9'
					 AND    (Mission IN (SELECT DISTINCT Mission 
					                    FROM   Organization.dbo.OrganizationAuthorization 
									    WHERE  UserAccount = '#SESSION.acc#'
									    AND    Role IN (SELECT Role
										                FROM   Organization.dbo.Ref_AuthorizationRole
													    WHERE  SystemModule = 'Staffing')
										)
										
							)
					)
					
		OR
		
		EXISTS (SELECT 'X' 
		             FROM   PersonEvent PC
					 WHERE  PC.PersonNo = PE.PersonNo
					 AND    PC.ActionStatus != '9'
					 AND    Mission IN (SELECT DISTINCT Mission 
					                    FROM   Organization.dbo.OrganizationAuthorization 
									    WHERE  UserAccount = '#SESSION.acc#'
									    AND    Role IN (SELECT Role
										                FROM   Organization.dbo.Ref_AuthorizationRole
													    WHERE  SystemModule = 'Staffing')
										)
					)			
	
	
	)
		
	<!--- Following statement is added to retrieve only those people who have not been having an
	assignment for the past year.  In other words, an HR officer might be working on a profile before
	sitting that person on a post and thus create a linkage to a Mission. If that happens, then the person
	does not have a mission but it should show. We allowed the period of not having a valid assignment to be 
	at the most one year. 
	---->	
	
	<cfif accessStaffing neq "NONE">
	   OR 
	   (
	       NOT EXISTS
			 (SELECT 'X' 
			  FROM    Position P INNER JOIN 
			          PersonAssignment PA ON PA.PositionNo = P.PositionNo AND PA.personNo = PE.PersonNo	AND PA.AssignmentStatus IN ('0','1')
			  )
			  
			  <!--- dropped 3/5/2016
			AND PE.CREATED >= #vPastYear#
			--->
		)
	</cfif>		
	
	)
	     													
	</cfif>
</cfsavecontent>

</cfoutput>

<!--- Query returning search results --->

<cftransaction isolation="READ_UNCOMMITTED">

	<cfquery name="SearchResult" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT count(*) as Result 
		#preservesinglequotes(qry)#
	</cfquery>
	
</cftransaction>

<cfif Searchresult.result gt "5000">

	 <cf_message message = "Your search resulted in more than 5000 matches. Operation aborted. "
	  return = "back">
	  <cfabort>

</cfif>

<cfset FileNo = round(Rand()*10)>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Person_#fileNo#">

<!---
<cftry>
--->

	<cftransaction isolation="READ_UNCOMMITTED">
		
	<!--- Query returning search results --->
	<cfquery name="SearchResult" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		INTO   userQuery.dbo.#SESSION.acc#Person_#fileNo# 
		
		FROM (
		   
			SELECT *, 
							
				
			   (SELECT       COUNT(*) 
				FROM         Organization.dbo.OrganizationObjectAction AS OA INNER JOIN
                	         Organization.dbo.OrganizationObject AS OO ON OA.ObjectId = OO.ObjectId 
				WHERE        OO.PersonNo = PE.PersonNo
                AND          OO.Operational = 1 
				<cfif missionselect neq "">
				AND          OO.Mission = '#missionselect#'
				</cfif>
				AND          OA.ActionStatus = '0') as PendingAction,
		
				
			    <!--- last contract / title --->
			   (SELECT       ContractLevel
				FROM         PersonContract AS PS
				WHERE        ContractId IN
                             (SELECT    TOP (1) ContractId
                               FROM     PersonContract 
                               WHERE    PersonNo = PE.PersonNo 
							   AND      ActionStatus IN ('0', '1') 
							   AND      DateEffective < GETDATE()
							   <cfif missionselect neq "">
							   AND      Mission = '#missionselect#'
							   </cfif>
                               ORDER BY DateEffective DESC)) as ContractLevel,			   
			
			
		       (SELECT 		COUNT(*) 
			    FROM   		PersonAssignment 
				WHERE  		PersonNo = Pe.PersonNo 
				AND    		AssignmentStatus IN ('0','1')
				AND    		DateExpiration >= getdate()) as Assignment,
				
			   (SELECT 		TOP 1 P.MissionOperational	
				FROM   		PersonAssignment PA 
				            INNER JOIN Position P ON PA.PositionNo = P.PositionNo 
							INNER JOIN Applicant.dbo.FunctionTitle F ON P.FunctionNo = F.FunctionNo
				WHERE  		PA.PersonNo   = PE.PersonNo
				<cfif missionselect neq "">
				AND    		P.Mission     = '#missionselect#'		
				</cfif>
				AND    		PA.AssignmentStatus IN ('0','1')
				AND    		PA.DateEffective < GETDATE()
				AND    		PA.Incumbency > 0		
				ORDER BY 	PA.DateEffective DESC) as Mission,	
				
			   (SELECT 		TOP 1 P.PositionNo	
				FROM   		PersonAssignment PA 
				            INNER JOIN Position P ON PA.PositionNo = P.PositionNo 
							INNER JOIN Applicant.dbo.FunctionTitle F ON P.FunctionNo = F.FunctionNo
				WHERE  		PA.PersonNo   = PE.PersonNo
				<cfif missionselect neq "">
				AND    		P.Mission     = '#missionselect#'		
				</cfif>
				AND    		PA.AssignmentStatus IN ('0','1')
				AND    		PA.DateEffective < GETDATE()
				AND    		PA.Incumbency > 0		
				ORDER BY 	PA.DateEffective DESC) as PositionNo,		
								
			   (SELECT 		TOP 1 F.FunctionDescription	
				FROM   		PersonAssignment PA 
				            INNER JOIN Position P ON PA.PositionNo = P.PositionNo 
							INNER JOIN Applicant.dbo.FunctionTitle F ON P.FunctionNo = F.FunctionNo
				WHERE  		PA.PersonNo   = PE.PersonNo
				<cfif missionselect neq "">
				AND    		P.Mission     = '#missionselect#'		
				</cfif>
				AND    		PA.AssignmentStatus IN ('0','1')
				AND    		PA.DateEffective < GETDATE()
				AND    		PA.Incumbency > 0		
				ORDER BY 	PA.DateEffective DESC) as FunctionDescription
						
			#preservesinglequotes(qry)# 
			
			) as B
			
			<cfif Form.PersonStatus neq "">
			WHERE ContractLevel IN (SELECT PostGrade FROM Ref_PostGrade WHERE PostGradeParent IN (#preservesinglequotes(Form.PersonStatus)#))
			</cfif>
			
			
	</cfquery>
	
	<!---	
	<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;#cfquery.executiontime#</cfoutput>
	--->
		
	</cftransaction>	
	
<!---
<cfcatch>

		<table align="center"><tr><td align="center" height="300" class="labelmedium">A problem occurred executing your request. <a href="javascript:history.back()"><font color="0080C0">Please try again.</font></a></td></tr></table>
		<cfabort>
		
</cfcatch>

</cftry>

--->

<cfset url.mode = Form.Crit5_Value>
<cfif form.Crit9_value neq "0">
	<cfset url.mode = Form.Crit9_Value>
</cfif>
<cfinclude template="PersonSearchResult.cfm">

<script>
	Prosis.busy('no')
</script>
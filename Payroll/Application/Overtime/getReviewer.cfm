
<cfparam name="URL.id"         		default ="">
<cfparam name="URL.Mission"    		default="">
<cfparam name="URL.LeaveType"  		default="CTO">
<cfparam name="URL.Mode"    		default="combo">
 	 
<cfquery name="Assignment" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   TOP 1 *
		 FROM     PersonAssignment PA, Organization.dbo.Organization O
		 WHERE    PersonNo = '#url.id#'
		 AND      O.Mission          = '#url.mission#'
		 AND      Pa.OrgUnit         = O.OrgUnit
		 --AND	  GETDATE() BETWEEN PA.DateEffective AND DATEADD(DAY, 1, DATEADD(SECOND,-1,PA.DateExpiration))
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass = 'Regular'
		 AND      PA.AssignmentType  = 'Actual'
		 AND      PA.Incumbency      > '0' 
		 ORDER BY PA.DateEffective DESC
		 <!----provision for a person who already left, but a few days after, overtime must be recorded --->
</cfquery>	

<cfquery name="LeaveType" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">		 
		 SELECT *
		 FROM   Ref_LeaveType
		 WHERE  LeaveType = '#URL.LeaveType#'		 
</cfquery>

<cfif LeaveType.LeaveReviewer eq "Staffing">
	 
	<cfquery name="Supervisor" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">				
			SELECT   DISTINCT 
			         U.Account,
					 U.FirstName, 
					 U.LastName,
					 U.PersonNo,
					 '0' as PostOrder				 
			FROM     Organization.dbo.OrganizationAuthorization OA, 
			         System.dbo.UserNames U
			WHERE    OA.UserAccount = U.Account
			AND      U.Disabled = 0		
			
			AND      OA.Role IN  (SELECT    Role
				                  FROM      Organization.dbo.Ref_Entity
				                  WHERE     EntityCode = 'EntOvertime') 
								  
			AND      OA.OrgUnit = '#Assignment.OrgUnit#'
					
			AND      U.Personno != '#URL.ID#'
			
			ORDER BY PostOrder	
			
	</cfquery>	

	<cfif Supervisor.recordcount eq "0">
		  
		<cfquery name="Supervisor" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
				SELECT   DISTINCT 
				         U.Account,
						 U.FirstName, 
						 U.LastName,
						 U.PersonNo,
						 '0' as PostOrder				 
				FROM     Organization.dbo.OrganizationAuthorization OA, 
				         System.dbo.UserNames U
				WHERE    OA.UserAccount = U.Account
				AND      U.Disabled = 0		
				
				AND      OA.Role IN  (SELECT    Role
					                  FROM      Organization.dbo.Ref_Entity
					                  WHERE     EntityCode = 'EntOvertime') 
									 
									  
				AND     ( OA.OrgUnit IN (SELECT OrgUnit 
				                   FROM   Organization.dbo.Organization 
								   WHERE  HierarchyRootUnit = '#Assignment.HierarchyRootUnit#'
								   AND    Mission           = '#Assignment.Mission#'
								   AND    MandateNo         = '#Assignment.MandateNo#') 	
								   
				OR (OA.Mission = '#Assignment.Mission#' and OA.OrgUnit is NULL)	
				
				)
				
				
				AND      U.Personno != '#URL.ID#'
				
				ORDER BY PostOrder	
				
		</cfquery>			
		
		<!--- now we go even wider --->
		  
		<cfif Supervisor.recordcount eq "0">
		
			<cfquery name="Supervisor" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT 
						 U.Account,
						 U.FirstName, 
						 U.LastName,
						 U.PersonNo,
						 R.PostOrder
				FROM     PersonAssignment PA, System.dbo.UserNames U, Position P, Ref_PostGrade R
				WHERE    P.PositionNo=PA.PositionNo
				AND      R.PostGrade=P.PostGrade
				AND      U.Disabled = 0
				AND      PA.OrgUnit IN (SELECT OrgUnit 
				                   FROM   Organization.dbo.Organization 
								   WHERE  HierarchyRootUnit = '#Assignment.HierarchyRootUnit#'
								   AND    Mission           = '#Assignment.Mission#'
								   AND    MandateNo         = '#Assignment.MandateNo#') 
				AND      PA.PersonNo = U.Personno		
				AND	  	 GETDATE() BETWEEN PA.DateEffective AND DATEADD(DAY, 1, DATEADD(SECOND,-1,PA.DateExpiration))
			    AND      PA.Incumbency > '0'
				AND      PA.AssignmentStatus < '8' <!--- planned and approved --->
		        AND      PA.AssignmentClass = 'Regular'
			    AND      PA.AssignmentType  = 'Actual'
				AND      U.Disabled = 0
				AND      U.Personno != '#URL.ID#'
			</cfquery>	
		
		</cfif>  
		
	</cfif>	

	<cfif Supervisor.recordCount gt 0>
		
		<cfif URL.Mode eq "combo">
	
			<cfoutput>
			
			<select name="#FieldName#" id="#FieldName#" class="regularxl">
			
			  <cfif FieldName eq "SecondReviewerUserId">
			  	<option value="">[n/a]</option>
			  <cfelse>
			    <option value="">-- select --</option> 	
			  </cfif>
			  
			  <cfloop query="Supervisor">
			 	<option value="#Account#">#FirstName# #LastName# (#Account#)</option>		  
			  </cfloop>
							  
			</select>
					
			</cfoutput>
	
		</cfif>
	
		<cfif URL.Mode eq "table">
			<table>
			
				<cfif Supervisor.recordCount eq 0>
					<tr>
						<td class="labelit">
							( <cf_tl id="No reviewers defined for this person"> )
						</td>
					</tr>
				</cfif>
				
				<cf_tl id="View user" var="lblUser">
				<cf_tl id="View person" var="lblPerson">
				<cfoutput query="Supervisor">
					<cfset vPersonLink = "##">
					<cfif trim(PersonNo) neq "">
						<cfset vPersonLink = "javascript:EditPerson('#personNo#')">
					</cfif>
					<tr>
						<td class="labelit">
							(<a href="javascript:ShowUser('#URLEncodedFormat(Account)#')" style="color:##1760A8;" title="#lblUser#">#Account#</a>)
						</td>
						<td class="labelit" style="padding-left:5px;">
							<a href="#vPersonLink#" style="color:##1760A8;" title="#lblPerson#">#UCASE(LastName)# #FirstName#</a>
						</td>
					</tr>
			  	</cfoutput>
				
			</table>
		</cfif>

	<cfelse>
		<table>
			<tr>
				<td class="labelit">
					[<cf_tl id="No reviewers defined">]
				</td>
			</tr>
		</table>
	</cfif>
		
<cfelseif LeaveType.LeaveReviewer eq "Role">	  	

<!--- I involved the Position and Ref_PostGrade
	   as we need these tables to show the right order 
	   Jorge Mazariegos Jan 27th 2010 --->
	   
	 	  
	  <cfquery name="Reviewer" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		   			
			<!--- include the overtime processor 
		
			SELECT   DISTINCT U.Account,
					 U.FirstName, 
					 U.LastName,
					 '1' as PostOrder
					 				 
			FROM     Organization.dbo.OrganizationAuthorization OA, 
			         System.dbo.UserNames U
			WHERE    OA.UserAccount = U.Account
			AND      OA.Role IN
	                   (SELECT    Role
	                    FROM      Organization.dbo.Ref_Entity
	                    WHERE     EntityCode IN ('EntOvertime','EntLVE'))
			 AND     OA.OrgUnit = '#URL.OrgUnit#'
			
			AND      U.Personno != '#URL.PersonNo#'
			
			UNION
			
			 include the designated timekeeper --->
		
			SELECT   DISTINCT U.Account,
					 U.FirstName, 
					 U.LastName,
					 '0' as PostOrder				 
			FROM     Organization.dbo.OrganizationAuthorization OA, 
			         System.dbo.UserNames U
			WHERE    OA.UserAccount = U.Account
			AND      OA.Role        = 'Timekeeper'	       
			AND      OA.OrgUnit     = '#Assignment.OrgUnit#'		
			AND      U.AccountType  = 'Individual'
			<cfif url.fieldName neq "FirstReviewerUserId">	
			AND      U.Personno    != '#URL.ID#'		
			</cfif>			
			<cfif url.fieldName eq "FirstReviewerUserId">
			AND      OA.AccessLevel = '1'
			<cfelse>
			AND      OA.AccessLevel = '2'
			</cfif>
			ORDER BY PostOrder	
			
	  </cfquery>		  
	  	  
	  <cfif Reviewer.recordcount eq "0">
	  	  	  
	  	  <!--- we drop the access condition inorder to show more --->
		  
		  <cfquery name="Reviewer" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
						   			
				<!--- include the overtime processor 
			
				SELECT   U.Account,
						 U.FirstName, 
						 U.LastName,
						 '1' as PostOrder
						 				 
				FROM     Organization.dbo.OrganizationAuthorization OA, 
				         System.dbo.UserNames U
				WHERE    OA.UserAccount = U.Account
				
				AND      OA.Role IN  (SELECT    Role
					                  FROM      Organization.dbo.Ref_Entity
					                  WHERE     EntityCode IN ('EntOvertime','EntLVE'))
									  
				AND      OA.OrgUnit = '#URL.OrgUnit#'
				AND      U.AccountType  = 'Individual'				 
				<cfif url.fieldName neq "FirstReviewerUserId">	
				AND      U.Personno != '#URL.PersonNo#'		
				</cfif>
								
				UNION
				
				--->
				
				<!--- include the designated timekeeper --->
			
				SELECT   U.Account,
						 U.FirstName, 
						 U.LastName,
						 '0' as PostOrder				 
				FROM     Organization.dbo.OrganizationAuthorization OA, 
				         System.dbo.UserNames U
				WHERE    OA.UserAccount = U.Account
				AND      OA.Role       = 'Timekeeper'	       
				AND      OA.OrgUnit    = '#Assignment.OrgUnit#'	
				<cfif url.fieldName neq "FirstReviewerUserId">	
				AND      U.Personno   != '#URL.ID#'		
				</cfif>
				
				ORDER BY PostOrder	
				
		  </cfquery>	
			  	  
	  </cfif>
	  
	  <cfquery name="Last" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
			 SELECT  TOP 1 FirstReviewerUserId, SecondReviewerUserId
			 FROM    Payroll.dbo.PersonOvertime
			 WHERE   PersonNo  = '#URL.ID#'		 			 
			 AND     Mission   = '#URL.Mission#'
			 AND     FirstReviewerUserId IS NOT NULL
			 AND     Status NOT IN ('8','9')
			ORDER BY Created DESC		
	  </cfquery>
	  
	  <cfoutput>
	  
	  <select name="#FieldName#" id="#FieldName#" required class="regularxl enterastab" style="min-width:340px">
						
			  <cfif FieldName eq "SecondReviewerUserId" and LeaveType.ReviewerTwoForce eq "0">
			  	  <option>--<cf_tl id="select">--</option>
			  </cfif>
			  
			  <cfif FieldName eq "FirstReviewerUserid">
			  
				 <cfloop query="Reviewer">
				 	<option value="#Account#" <cfif account eq last.FirstReviewerUserid>selected</cfif>>#FirstName# #LastName# (#Account#)</option>		  
				 </cfloop>
				  
			  <cfelse>
			  
			  	 <cfloop query="Reviewer">
				 	<option value="#Account#" <cfif account eq last.SecondReviewerUserid>selected</cfif>>#FirstName# #LastName# (#Account#)</option>		  
				 </cfloop>
			  
			  </cfif>	  
							  
		</select>
			
		</cfoutput>	
	  	  
</cfif>
	
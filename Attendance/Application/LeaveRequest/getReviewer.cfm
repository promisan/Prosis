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
<cfparam name="URL.LeaveType"  default="">
<cfparam name="URL.FieldName"  default ="FirstReviewerUserId">
<cfparam name="URL.PersonNo"   default ="">
<cfparam name="URL.OrgUnit"    default="">
<cfparam name="URL.HierarchyRootUnit" default="">
<cfparam name="URL.Mission"    default="">
<cfparam name="URL.MandateNo"  default="">
<cfparam name="URL.PostOrder"  default="">

<cfquery name="LeaveType" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">		 
		 SELECT *
		 FROM   Ref_LeaveType
		 WHERE  LeaveType = '#URL.LeaveType#'		 
</cfquery>

<!--- used to potentially preselect the last selection on the reviewers --->

<cfquery name="Last" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">		 
		 SELECT  TOP 1 FirstReviewerUserId, SecondReviewerUserId
		 FROM    PersonLeave
		 WHERE   PersonNo  = '#URL.PersonNo#'		 
		 AND     LeaveType = '#URL.LeaveType#'
		 AND     Mission   = '#URL.Mission#'
		 AND     FirstReviewerUserId IS NOT NULL
		 AND     Status NOT IN ('8','9')
		ORDER BY Created DESC		
</cfquery>

<cfif LeaveType.LeaveReviewer eq "Staffing">

  <!--- I involved the Position and Ref_PostGrade
	   as we need these tables to show the right order 
	   dev dev Jan 27th 2010 --->
	  
	  <cfquery name="Reviewer" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		    <!--- get users through person with same or higher grade --->
			
			SELECT   DISTINCT 
					 U.Account,
					 U.FirstName, 
					 U.LastName,
					 R.PostOrder			
					 
			FROM     PersonAssignment PA, 
			         System.dbo.UserNames U, 
					 Position P, 
					 Ref_PostGrade R
					 
			WHERE    P.PositionNo = PA.PositionNo
			AND      R.PostGrade  = P.PostGrade
			
			AND      PA.OrgUnit IN (SELECT OrgUnit 
					                   FROM   Organization.dbo.Organization 
									   WHERE  HierarchyRootUnit = '#URL.HierarchyRootUnit#' 
									   AND    Mission           = '#URL.Mission#'
									   AND    MandateNo         = '#URL.MandateNo#') 
									   
			AND      PA.PersonNo        = U.Personno		
			AND      PA.DateEffective  <= getdate() 
		    AND      PA.DateExpiration >= getdate()
		    AND      PA.Incumbency > '0'
			
			<!--- same level or higher than this person --->
			
			AND      R.PostOrder <= '#URL.PostOrder#' 
			
			<!--- planned and approved --->
			AND      PA.AssignmentStatus IN ('0','1')
            AND      PA.AssignmentClass = 'Regular'
		    AND      PA.AssignmentType  = 'Actual'
			
			AND      U.Disabled = 0			
			AND      U.Personno != '#URL.PersonNo#'
						
			UNION
			
			<!--- include the overtime processor --->
		
			SELECT   U.Account,
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
			
			<!--- include the designated timekeeper --->
		
			SELECT   U.Account,
					 U.FirstName, 
					 U.LastName,
					 '0' as PostOrder				 
			FROM     Organization.dbo.OrganizationAuthorization OA, 
			         System.dbo.UserNames U
			WHERE    OA.UserAccount = U.Account
			AND      OA.Role = 'Timekeeper'	       
			AND      OA.OrgUnit = '#URL.OrgUnit#'			
			AND      U.Personno != '#URL.PersonNo#'			

			ORDER BY PostOrder	
			
	  </cfquery>	
	  
<cfelseif LeaveType.LeaveReviewer eq "Role">	  	

<!--- I involved the Position and Ref_PostGrade
	   as we need these tables to show the right order 
	   dev dev Jan 27th 2010 --->
	   
	 	  
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
			AND      OA.OrgUnit     = '#URL.OrgUnit#'		
			AND      U.AccountType  = 'Individual'
			<cfif url.fieldName neq "FirstReviewerUserId">	
			AND      U.Personno    != '#URL.PersonNo#'		
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
				AND      OA.OrgUnit    = '#URL.OrgUnit#'	
				<cfif url.fieldName neq "FirstReviewerUserId">	
				AND      U.Personno   != '#URL.PersonNo#'		
				</cfif>
				
				ORDER BY PostOrder	
				
		  </cfquery>	
			  	  
	  </cfif>
	  	  
</cfif>

<script language="JavaScript">
	try { document.getElementById('reviewerselect').className  = "regular"} catch(e) {}
	try { document.getElementById('reviewerselect1').className = "regular"} catch(e) {}
	try { document.getElementById('reviewerselect2').className = "regular"} catch(e) {}
</script>

<cfoutput>

	<cfif (LeaveType.LeaveReviewer eq "Staffing" or LeaveType.LeaveReviewer eq "Role") and Reviewer.RecordCount gt 0>	
		
		  	<select name="#FieldName#" id="#FieldName#" required class="regularxxl enterastab" style="min-width:340px">
						
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
			
		
		<cfelse>
		
			<script>
				try { document.getElementById('reviewerselect').className  = "regular"} catch(e) {}
				try { document.getElementById('reviewerselect1').className = "regular"} catch(e) {}
				try { document.getElementById('reviewerselect2').className = "regular"} catch(e) {}
			</script>
			
			<table>
				<tr>
						
					<cfset link = "#session.root#/Attendance/Application/LeaveRequest/getPerson.cfm?personno=#url.personno#&leaveid=&field=#FieldName#">						
																
					<td>
						<cfdiv bind="url:#link#&Account=" id="#FieldName#_box"/>						
					</td>
					
					<td width="20" style="padding-left:1px">
						
					   <cf_selectlookup
						    box        = "#FieldName#_box"
							link       = "#link#"
							button     = "Yes"
							close      = "Yes"						
							icon       = "lookup.png"
							iconheight = "26"
							iconwidth  = "26"
							style      = "border:1px solid silver;border-left:0px"
							filter2    = "onboard"							
							class      = "user"
							des1       = "Account">
							
					</td>	
				    								
				</tr>
			</table>	
			
	
	</cfif>
	
	<!--- hide/show information --->
	
	
	
	<cfif LeaveType.ReviewerActionCodeOne eq "" and LeaveType.ReviewerActionCodeTwo eq "">
				
			<script>			
			try {document.getElementById('reviewerselect').className = "hide"} catch(e) {}
			</script>					
		
	</cfif>
	
	<cfif LeaveType.ReviewerActionCodeOne eq "">
		
		<script>		   
			try { document.getElementById('reviewerselect1').className = "hide"} catch(e) {}
		</script>
		
	</cfif>	
		
	<cfif LeaveType.ReviewerActionCodeTwo eq "">
		
		<script>
			try {document.getElementById('reviewerselect2').className = "hide"} catch(e) {}
		</script>	
	
	</cfif>
	

</cfoutput>

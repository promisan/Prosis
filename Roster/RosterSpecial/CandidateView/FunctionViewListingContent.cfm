
<cfset currrow = 0>

<cfparam name="URL.Page"           default="1">
<cfparam name="URL.Print"          default="0">
<cfparam name="URL.View"           default="LastName">
<cfparam name="URL.Mode"           default="1">
<cfparam name="URL.Tab"            default="">
<cfparam name="URL.Process" 	   default="">
<cfparam name="URL.ProcessStatus"  default="">
<cfparam name="URL.ProcessMeaning" default="">
<cfparam name="URL.Level"          default="0">
<cfparam name="URL.Filter"         default="x">
<cfparam name="URL.search"         default="0">
<cfparam name="URL.fld"            default="">
<cfparam name="URL.source"         default="#url.box#">
<cfparam name="day"                default="0">
<cfparam name="url.day"            default="#day#">

<cfif url.print eq "1">
    <cfoutput>
	<title>Print Bucket</title>	
    <link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
	</cfoutput>
	<script>
		window.print()
	</script>
<cfelseif URL.print neq "3">
	 <cfset url.print = "0">
</cfif>

<cfinvoke component="Service.Access"  
		  method="Bucket" 
		  role="RosterClear" 
		  functionId="#URL.IDFunction#"
		  level="All"
		  returnvariable="Access">
	
<cfinvoke component="Service.Access"  
	  	  method="Bucket" 
		  role="RosterClear" 
		  functionId="#URL.IDFunction#"
	      level="1"
	      returnvariable="Access1">
   
<cfinvoke component="Service.Access"  
	      method="Bucket" 
	      role="RosterClear" 
	      functionId="#URL.IDFunction#"
	      level="2"
	      returnvariable="Access2">   		  		  

<cfquery name="FO" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    FunctionOrganization FO INNER JOIN
            Ref_SubmissionEdition R ON FO.SubmissionEdition = R.SubmissionEdition
	WHERE   FunctionId = '#URL.IDFunction#'
</cfquery>

<!--- 
<cfset FileNo = round(Rand()*30)>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#tmp#FileNo#"> 

<cfquery name="FunctionAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
--->

<cfsavecontent variable="candidates">
<cfoutput>
	SELECT DISTINCT 
	       A.FunctionId, 
		   A.Status, 
		   A.RosterGroup, 	      
	       A1.PersonNo,
		   R.Meaning, 
	       A1.IndexNo, 
		   A1.LastName, 
		   A1.FirstName, 
		   A1.Nationality, 
		   (SELECT Name FROM System.dbo.Ref_Nation WHERE Code = A1.Nationality) as NationalityName,
		   (SELECT Continent FROM System.dbo.Ref_Nation WHERE Code = A1.Nationality) as Continent,
		   (SELECT CountryGroup FROM System.dbo.Ref_Nation WHERE Code = A1.Nationality) as CountryGroup,
		   S.ApplicantNo, 		    
		   A1.Gender, 
		   A1.DOB, 
		   A1.eMailAddress,
		   A.FunctionJustification,
		   
		   (
		   		SELECT    Count(*)
				FROM      ApplicantBackground AB
				WHERE     ApplicantNo = S.ApplicantNo 	  
						  AND ExperienceCategory = 'Employment'
				
			) AS Employment, 
			
			(	
				SELECT    Count(*)
				FROM      ApplicantBackground AB 
				WHERE     ApplicantNo = S.ApplicantNo		  
						  AND  ExperienceCategory = 'University'
			) AS University, 
		   
   			(	
				SELECT    Count(*)
				FROM      ApplicantLanguage AL
				WHERE     AL.ApplicantNo = S.ApplicantNo
			) AS Language, 
			
			(	
				SELECT    MAX(ActionEffective) 
				FROM      ApplicantFunctionAction AFS INNER JOIN
	                      RosterAction RA ON AFS.RosterActionNo = RA.RosterActionNo
				WHERE     ApplicantNo = S.ApplicantNo		  
						  AND  FunctionId = A.FunctionId
			) AS LastRosterAction, 
		   
		   A.OfficerFirstName,
		   A.OfficerLastName,
           A.Created
		   
	<!--- INTO   userQuery.dbo.#SESSION.acc#tmp#FileNo# --->
	
	FROM   Applicant A1, 
	       ApplicantSubmission S,
	       ApplicantFunction A, 
		   Ref_StatusCode R
	WHERE  A.FunctionId     = '#URL.IDFunction#' 
		 
	 <!--- hide people that should not be shown --->
	 
	 <cfif SESSION.isAdministrator eq "Yes" or findNoCase(FO.owner,SESSION.isOwnerAdministrator)>
	 
	 <!--- no filter --->
	 
	 <cfelse>
	  
	 AND   A1.PersonNo NOT IN (
	                           SELECT AR.PersonNo 
	                           FROM   ApplicantAssessment AR, 
							          Ref_PersonStatus R
							   WHERE  AR.PersonStatus = R.Code
							   AND    AR.PersonNo     = A1.PersonNo
							   AND    R.RosterHide    = 1
							   AND    AR.Owner        = '#FO.Owner#'
							   )
							   
	 </cfif>						   
	 
	 <cfif URL.search eq "1">
	 
		 AND  S.PersonNo IN (SELECT PersonNo FROM Applicant WHERE
		 
		  PersonNo = S.PersonNo AND
		 
		  <cfswitch expression="#URL.tpe#">
		  	  <cfcase value="name">
			      (A1.LastName 
				  <cfif URL.opt eq "1">
					  LIKE '%#URL.fld#%'
				  <cfelse>
				  	  LIKE '% #URL.fld# %'
				  </cfif>
				  OR  A1.FirstName 
				  <cfif URL.opt eq "1">
					  LIKE '%#URL.fld#%'
				  <cfelse>
				  	  LIKE '% #URL.fld# %'
				  </cfif>)
			  </cfcase>
			    <cfcase value="indexno">
				  A1.IndexNo 
				  <cfif URL.opt eq "1">
					  LIKE '%#URL.fld#%'
				  <cfelse>
				  	  LIKE '% #URL.fld# %'
				  </cfif>
				
				</cfcase>
		  </cfswitch>
		   <cfif URL.Nat neq "all">
			 AND Nationality = '#URL.Nat#'
		   </cfif>)
	   
	 <cfelseif URL.Source eq "Manual">
	 
	 	  AND A.Source = 'Manual' 
	 
	 <cfelse>
	 
		 AND  A.Status = '#URL.Filter#'
		 
		 <!--- process from --->
		 <cfif URL.Level neq URL.Filter>
		 
		 <!--- was processed to the filtered status FROM the selected process level status --->		 
		 AND  A.ApplicantNo IN  
			     (
				  SELECT  ApplicantNo
	              FROM    ApplicantFunctionAction S
				  WHERE   S.ApplicantNo = A.ApplicantNo
				  AND     S.FunctionId = '#URL.IDFunction#'
				  <!--- take action --->
				  AND     RosterActionNo = (
				                            SELECT TOP 1 RosterActionNo 
				                            FROM     ApplicantFunctionAction
											WHERE    ApplicantNo = S.ApplicantNo
											AND      FunctionId  = S.FunctionId
											AND      Status != '#URL.Filter#'
											ORDER BY RosterActionNo DESC
											)
				  <!--- last action must have the selected status --->							
			   	  AND     S.Status     = '#URL.Level#'
				  )
         </cfif>
		 
	 </cfif>
	 
	 AND  A.ApplicantNo = S.ApplicantNo
	 AND  S.PersonNo    = A1.PersonNo
	 AND  R.Status      = A.Status
	 AND  R.Owner       = '#URL.Owner#'
	 AND  R.Id          = 'FUN'   	
	 
	 </cfoutput>
</cfsavecontent>

<!---	 
 
</cfquery>  
--->

<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterOwner
	WHERE  Owner  = '#URL.Owner#'
</cfquery>

<cfquery name="ParameterMain" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Parameter
</cfquery>

<cfif URL.print eq "3">
	<cfset FileNo = round(Rand()*30)>
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Roster_#FileNo#">
	
</cfif>
	
<cfquery name="Searchresult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT   DISTINCT R.*, 
	         L.Mission, 
		     L.OrgUnitName as OrganizationUnit, 
		     H.Source, 						 
				 (SELECT TOP 1 DocumentNo 
				  FROM   Vacancy.dbo.skCandidateSelected_#URL.Owner# 
				  WHERE  PersonNo   = R.PersonNo 				  
				  AND    Status     = 'Selected') as DocumentNo,
		     C.ContractLevel, 
			 C.ContractStep, 
			 C.DateExpiration,
			 L.PersonStatusDescription,
			 L.Personstatus
	
	<cfif URL.print eq "3">
		INTO UserQuery.dbo.#SESSION.acc#Roster_#FileNo#
	</cfif>
	
	FROM     <!--- userQuery.dbo.#SESSION.acc#tmp#FileNo# R LEFT OUTER JOIN --->
	
			(#preservesingleQuotes(candidates)#) R LEFT OUTER JOIN
	
	         <!--- retrieve assignments to be shown in the result listing --->
			 
			 (
				SELECT  P.PersonNo,
				        IndexNo,
						P.LastName,
				        Org.OrgUnitName AS OrgUnitName, 
						Org.Mission AS Mission, 
				        P.PersonStatus, 
						S.Description as PersonStatusDescription				
			    FROM    Employee.dbo.PersonAssignment PA, 
			            Organization.dbo.Organization Org,
			            Employee.dbo.Person P,
						Employee.dbo.Ref_Personstatus S
						
				WHERE   PA.PersonNo       = P.PersonNo 
				
				<!---
				<cfif quotedValueList(get.IndexNo) neq "">
				AND     P.IndexNo IN (#quotedValueList(get.IndexNo)#)	
				<cfelse>
				AND     1=0
				</cfif>
				--->
				
				AND     PA.OrgUnit        = Org.OrgUnit
				AND     Org.Mission IN (SELECT Mission 
			                        	FROM   Organization.dbo.Ref_Mission 
										WHERE  Mission      = Org.Mission
			                            AND    MissionOwner = '#URL.Owner#') 		  
				AND		P.PersonStatus    = S.Code					   	
			    AND     PA.DateEffective  <= #now()# 
				AND     PA.DateExpiration >= #now()# 
				AND     PA.AssignmentStatus IN ('0', '1') 
				AND     PA.AssignmentClass = 'Regular'		
								 
				 ) L ON L.IndexNo = R.IndexNo AND L.LastName = R.LastName  <!--- correction to prevent matching for duplicated indexno --->
			
			 <!--- contract --->	 
			 
		 	 LEFT OUTER JOIN Employee.dbo.skPersonContract C ON L.PersonNo = C.PersonNo 	
			 
			 <!--- submission --->
			 
			 LEFT OUTER JOIN ApplicantSubmission H ON R.PersonNo = H.PersonNo		 
	
	<cfif Parameter.DefaultPHPSource eq "">
		AND      H.Source   = '#ParameterMain.PHPSource#' 
	<cfelse>		 
		AND      H.Source   = '#Parameter.DefaultPHPSource#' 
	</cfif>
	
	ORDER BY R.Status, <cfif URL.View eq "CreatedA">R.Created,
	                   <cfelseif URL.View eq "CreatedD">R.Created DESC,
   					   <cfelseif URL.View eq "Nationality">R.Nationality,
					   <cfelseif URL.View eq "Gender">R.Gender,
					   </cfif>R.LastName, R.FirstName, R.PersonNo, R.ApplicantNo 				   
					   
		   
</cfquery>

<cfif url.print eq "3">
	<cfinclude template="FunctionViewListingExport.cfm">
</cfif>

<!---
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#tmp#FileNo#">
--->

<cfif url.print eq "1">

	<table width="96%" height="100%" align="center">
	
	<cfquery name="Function" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT F.*, Fo.*, R.Owner, R.EnableManualEntry, R.EditionDescription
	 FROM   FunctionTitle F, 
	        FunctionOrganization Fo, 
		    Ref_SubmissionEdition R
	 WHERE  F.FunctionNo = Fo.FunctionNo
	 AND    Fo.FunctionId = '#URL.IDFunction#'
	 AND    R.SubmissionEdition = Fo.SubmissionEdition 
	</cfquery>

	<tr><td colspan="12" height="40">
				  
		<table width="100%" align="center" class="formpadding">
			<cfoutput>	
			
			<tr><td width="20%" class="labelit"><cf_tl id="Edition">:</td>
			    <td class="labelmedium">#Function.EditionDescription#</td>
				<cfif function.mission neq "">
			    <td width="20%" class="labelit"><cf_tl id="Mission">:</td>
			    <td class="labelmedium">#Function.Mission#</td>
				</cfif>	
			</tr>	
			
			<tr><td width="20%" class="labelit"><cf_tl id="Owner">:</td>
			    <td class="labelmedium">#Function.Owner#</td>						
			    <td width="20%" class="labelit"><cf_tl id="Reference">:</td>
			    <td class="labelmedium">#Function.ReferenceNo#</td>						
			</tr>						
			<tr><td width="150" class="labelit"><cf_tl id="Functional Title">:</td>
			<td class="labelmedium">#Function.GradeDeployment# #Function.FunctionDescription# 
			<cfif Function.FunctionRoster eq "0" and Function.ReferenceNo neq "Direct">
				<img src="#SESSION.root#/Images/caution.gif" alt="" border="0">
				[Functional title for this level is currently not identified as a roster function].
			</cfif>
						
			</td>
			</tr>
						  
			<tr><td width="20%" class="labelit"><cf_tl id="Bucket Expiration">:</td>
			    <td class="labelmedium">#dateformat(Function.dateexpiration,CLIENT.DateFormatShow)#</td>						
			    <td width="20%"></td>
			    <td></td>						
			</tr>							
						
			<cfquery name="Status" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Ref_StatusCode
			 WHERE  Owner = '#Function.Owner#'
			 AND    Id = 'FUN'
			 AND    Status = '#url.Filter#' 
			</cfquery>
			
			<tr><td width="20%" class="labelit"><cf_tl id="Roster Status">:</td>
			    <td class="labelmedium">#status.meaning#</td>						
			    <td width="20%"></td>
			    <td></td>						
			</tr>	
									
			</cfoutput>	
			
		</table>
		
	</td>
</tr>	

<cfelse>

<table width="100%" height="100%" align="center">

</cfif>

<cfoutput>

<cfif search eq "0" and url.print eq "0">
	
	<cfif URL.Source eq "Manual">
	
	  <tr>
	
	  <td colspan="5" align="left" style="height:31px">
	    <table cellspacing="0" cellpadding="0">
	    <cfoutput>
		    <tr><td style="padding-left:4px;padding-right:4px">
		       <img src="#SESSION.root#/Images/<cfif #URL.Source# eq 'Manual'>HR_EmployeeIncoming<cfelse>position_duplicate</cfif>.gif" alt="Candidate listing" border="0" align="absmiddle">
			   </td>
			<td style="padding-left:4px;padding-right:4px">   	   
			    <i class="fas fa-caret-right"></i>
			</td>
			<td class="labelmedium" style="font-size:18px"><a href="javascript:candidate('#URL.Idfunction#')"><cf_tl id="Press here to register candidate"></font></a></td>
			</tr>	
	    </cfoutput>
	    </table>
	  </td>
	  
	  </tr>
		   
	</cfif>   

</cfif>

</cfoutput>

<cfset col = "18">

<cfif URL.print neq "3">
<tr>
    <td style="border:0px solid silver;padding-right:10px" height="100%" valign="top" colspan="<cfoutput>#col#</cfoutput>">
	
	<cfif url.print eq "1">		
		<cfinclude template="FunctionViewListingContentDetail.cfm">		
	<cfelse>
	
		<cf_divscroll>		
			<cfinclude template="FunctionViewListingContentDetail.cfm">
		</cf_divscroll>
		
	</cfif> 

</td>
</tr>	
</table>	
</cfif>


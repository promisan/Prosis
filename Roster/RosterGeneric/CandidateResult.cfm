<!--- Create Criteria string for query from data entered thru search form --->


<cfparam name="URL.Status"    default="0">
<cfparam name="URL.Page"      default="1">
<cfparam name="URL.Mission"   default="">
<cfparam name="url.height"    default="#client.height#">
<cfparam name="own"           default="DPKO">

<cfparam name="URL.ID" default="0">

<cfif URL.ID is "0">

   <cfinclude template="CandidateSearchCriteria.cfm">
   <cfset CLIENT.FilterCan    = Criteria>
   
<cfelseif URL.ID is "9">  

   <!--- nada --->
   
<cfelse>

   <cfset CLIENT.FilterCan  = " AND A.OfficerUserId='#SESSION.acc#' AND A.CandidateStatus = '0'"> 
   
</cfif>

<cfoutput>

<cfquery name="Parameter" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT * FROM Parameter
</cfquery> 

<!--- limited : is driven by a specific menu function ---> 

<cfif URl.scope eq "Roster">
      
	  <!--- save and show records --->
	   
	  <cfquery name="AssignNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE Parameter 
		 SET    SearchNo = SearchNo+1
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
				 Owner,
				 SearchCategory,
				 RosterStatus,
				 Mode,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
	      VALUES ('#LastNo#',
		      'Direct search', 
			  '#URL.Owner#',
			  'Direct',
			  '#URL.Status#',
			  '#URL.Mode#',
	          '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate()
			  )
	    </cfquery>
		
		<cfif URL.DocNo neq "">
	
			<cfquery name="Update" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE RosterSearch 
			 SET    SearchCategory    = '#url.mode#', 
			        SearchCategoryId  = '#URL.DocNo#'
			 WHERE  SearchId = '#LastNo#'
		     </cfquery>
	
		</cfif>
		
</cfif>		

<cfinvoke component="Service.Access"  
		   method="roster" 
		   role="'AdminRoster'"
		   returnvariable="AdminAccess">		  
		   
	<!--- define the roster status to be shown --->
		  
	<cfquery name="OwnerSelect"
	   datasource="AppsOrganization"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
		SELECT   TOP 1 ClassParameter as Owner
		FROM     OrganizationAuthorization 
		WHERE    UserAccount = '#SESSION.acc#' 
		 AND     Role IN ('RosterClear','AdminRoster')
	</cfquery>
	
	<!--- wildcard --->
	
	<cfif OwnerSelect.recordcount eq "0">
	
		<cfquery name="OwnerSelect"
		   datasource="AppsSystem"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		      SELECT   *
			  FROM     UserNames
			  WHERE    Account = '#SESSION.acc#'
	  	</cfquery>
		
		 <cfif OwnerSelect.AccountOwner neq "">
		     <cfset own = "#OwnerSelect.AccountOwner#">			 
		 </cfif>
		 
	<cfelse>
		
		<cfset own = "#OwnerSelect.Owner#">	
			
	</cfif>	
	
<cfif client.filtercan eq "">
    <cf_waitEnd>
	<cf_message message="Sorry but you need to enter one or more filter criteria" return="no"> 
	<cfabort>
</cfif>	
	
<cfif own eq "">
    <cf_waitEnd>
	<cf_message message="Sorry not able to determine the roster OWNER setting for your account. Please contact your administrator" return="no"> 
	<cfabort>
</cfif>

<cfquery name="Parameter" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_ParameterOwner
  WHERE  Owner = '#Own#' 
</cfquery>

<cfif Parameter.recordcount eq "0">
   <cfset sel = "">
<cfelse>
   <cfset sel = own>
</cfif>

<cfset stp = "">		   

<cfsavecontent variable="query">

FROM  Applicant A	  
	  INNER JOIN ApplicantSubmission B ON A.PersonNo = B.PersonNo 	
WHERE 
	  A.LastName is not null
	  <cfif SESSION.isAdministrator eq "No">
	  AND  A.PersonNo NOT IN (SELECT AR.PersonNo 
			                  FROM   ApplicantAssessment AR, 
								     Ref_PersonStatus R
							  WHERE  AR.PersonStatus = R.Code
							  AND    AR.PersonNo     = A.PersonNo
							  AND    R.RosterHide    = 1
							  AND    AR.Owner        = '#Own#')
	</cfif>						  
	
	#PreserveSingleQuotes(CLIENT.FilterCan)# 
	
	  <cfif AdminAccess neq "NONE">
	  
	  <!--- search all :
	  
	  or accessread eq "READ" readaccess can now be defined differently level 0 by defining
	  all the steps---> 	  	 
	
	  <cfelseif AdminAccess eq "NONE" and URL.Mode neq "Limited" and url.docno eq ""> 	
		  
	    <!--- granted on the bucket level and not for a vacancy track --->  
	  			  	   
		<cfquery name="Steps" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_StatusCode
			WHERE    Owner = '#Own#'
			AND      Id    = 'FUN' 
			ORDER BY Status 
		</cfquery>		
		
		<!--- define steps to which this user has search access for any bucket with this owner --->	
		
		<cfloop query="steps">
					 
				<cfinvoke component="Service.Access.Roster"  
		   	 	 method         = "RosterStep" 
			  	 returnvariable = "Access"
			     Status         = "#Status#"												
				 Process        = "Search"
		   		 Owner          = "#Own#">	
				 
				<cfif Access eq "1">
										
					 <cfif stp eq "">
					     <cfset stp = "'#steps.status#'">
					 <cfelse>
					     <cfset stp = "#stp#,'#steps.status#'">
					 </cfif>  
								
				</cfif>	
				
		</cfloop>	
		
	   <!--- applicant is connected to a bucket with a STATUS to which the user has been granted access for any bucket under that owner --->	
		  
	   AND B.ApplicantNo IN
			   (SELECT    AF.ApplicantNo
			   
				FROM      ApplicantFunction AF INNER JOIN
		                  FunctionOrganization VA INNER JOIN
		                  RosterAccessAuthorization A ON VA.FunctionId = A.FunctionId ON AF.FunctionId = VA.FunctionId						   
						  
				WHERE     A.UserAccount = '#SESSION.acc#'
				AND       AF.ApplicantNo = B.ApplicantNo
				AND       AF.Status IN (#preserveSingleQuotes(stp)#)) 		
					
	  <cfelseif URL.Owner neq "" and URL.Scope neq "Roster" <!--- and #check.recordcount# gt "0" --->>		
	  
	     <!--- wildcard access --->
		 
		 <cfset stp = "">

		<cfquery name="Steps" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_StatusCode
			WHERE Owner = '#URL.Owner#'
			AND   Id    = 'FUN' 
			AND   ShowRoster = '1'
			ORDER BY Status 
		</cfquery>	
		
		<cfloop query="steps">
												
			 <cfif stp eq "">
			     <cfset stp = "'#steps.status#'">
			 <cfelse>
			     <cfset stp = "#stp#,'#steps.status#'">
			 </cfif>  
								
		</cfloop>		
	  	  
	     AND B.ApplicantNo IN
	      (SELECT  DISTINCT AF.ApplicantNo
			FROM   Ref_SubmissionEdition R INNER JOIN
    	           FunctionOrganization FO ON R.SubmissionEdition = FO.SubmissionEdition INNER JOIN
        	       ApplicantFunction AF ON FO.FunctionId = AF.FunctionId
			WHERE  R.Owner = '#URL.Owner#'
			AND    AF.ApplicantNo = B.ApplicantNo
			AND AF.Status IN (#preserveSingleQuotes(stp)#)) 
	  	
	  </cfif> 	    
	  	  
 </cfsavecontent>
 
 <cfif AdminAccess neq "NONE" or url.docno neq "">
 
 <cfelse>
 
 	<cfif stp eq "">
			
		<cf_waitEnd>
		<cf_message message="Problem, you have not been granted roster access (#Own#) to retrieve candidate information." return="no">
		<cfabort>
				
	</cfif>	
	
 </cfif>	
 	
 <cfquery name="SearchTotal" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT count(DISTINCT A.PersonNo) as Total
		#preserveSingleQuotes(query)# 	
 </cfquery>		   

<cfset rows    = ceiling((url.height-150)/22)>
<!--- provision for 0 result --->
<cfif rows lte 0>
	<cfset rows = 25>
</cfif>
<cfset cpage   = url.page>
<cfset first   = ((cpage-1)*rows)+1>
<cfset top     = cpage*rows>
<cfset pages   = Ceiling(SearchTotal.total/rows)>
<cfif  pages lt "1">
	   <cfset pages = '1'>
</cfif>

<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	<cfif URL.scope eq "Roster">
	
		INSERT INTO RosterSearchResult (SearchId, PersonNo)
		SELECT DISTINCT '#LastNo#', A.PersonNo	
		
	<cfelse>
		
		SELECT DISTINCT TOP #top# A.*,
		
			 (SELECT    TOP 1 ActionTimeStamp
			  FROM      ApplicantInquiryLog
			  WHERE     PersonNo = A.PersonNo
			  ORDER BY  ActionTimeStamp DESC ) as LastViewed,	
			  
			 (SELECT 	TOP 1 ApplicantNo 
			  FROM 		ApplicantSubmission S			 
			  WHERE 	PersonNo = A.PersonNo			   
			  AND       ApplicantNo IN (SELECT ApplicantNo 
										FROM   ApplicantBackGround
										WHERE  ApplicantNo = S.ApplicantNo 
										AND    Status < '9')			  
			  ) as ApplicantNo,		
			  
			  (SELECT 	count(*)
			  FROM 		ApplicantSubmission S			 
			  WHERE 	PersonNo = A.PersonNo			   
			  AND       ApplicantNo IN (SELECT ApplicantNo 
										FROM   ApplicantBackGround
										WHERE  ApplicantNo = S.ApplicantNo 
										AND    Status < '9')			  
			  ) as Submissions,	  	 
												
													
		<cfif sel neq "">
		
		<!--- recruitment indicator --->
	    (SELECT TOP 1 Status 
		 FROM   Vacancy.dbo.skCandidateSelected_#own# O 
		 WHERE  A.PersonNo = O.PersonNo) as Indicator,
		 
	  	<cfelse>
		
		'' as Indicator,
		
		</cfif>
		
		<!--- define if has last assignment --->
		<cfif Parameter.showLastAssignment eq "1">				
				  (SELECT count(*)  
				   FROM   Employee.dbo.PersonAssignment E 
		           WHERE  E.PersonNo = A.EmployeeNo
				   AND    E.AssignmentStatus IN ('0','1')
				   AND    DateEffective < getDate()
				   AND    DateExpiration > getDate()) as ShowAssignment
		<cfelse>
				 '0' as ShowAssignment
		</cfif>
		
	</cfif>
	#preserveSingleQuotes(query)#	
	<cfif URL.scope neq "Roster"> ORDER BY LastName, FirstName </cfif> 	
	
</cfquery>

<cfquery name="Owner" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 ClassParameter
	FROM      OrganizationAuthorization
	WHERE     UserAccount = '#SESSION.acc#' 
	AND       Role IN ('AdminRoster','CandidateProfile','RosterClear')
</cfquery>
		
</cfoutput>

<cfif URl.scope eq "Roster">

	<cfset url.id   = "GEN">
	<cfset url.id1  = LastNo>
	<cfset url.id2  = "B">
	<cfset url.Id3  = "GEN">
	<cfset height   = "#client.height-100#">
	<cfset url.back = "0">	
	
	<table height="100%" width="100%" align="center">
	<tr><td style="height:100% width:100%">
	<cfoutput>
	<iframe width="100%" height="100%" src="#SESSION.root#/roster/rostergeneric/RosterSearch/ResultListing.cfm?mode=#url.mode#&docno=#url.docno#&id=GEN&id1=#LastNo#&id2=B&id3=GEN&height=#height#&back=0&mid=#url.mid#" 
	scrolling="no" frameborder="0"></iframe>
	</cfoutput>
	</td></tr>
				
<cfelse>

		
		 
		<table height="100%" width="100%" align="center">
		  
		  <cfif searchresult.recordcount gt "0">
		  
			  <tr class="line">
			  <td style="padding-left:3px;height:30px;font-size:20px0" class="labellarge"><font color="gray">
			     <cfoutput>
					#SearchTotal.total# <cf_tl id="matching records found">...				    
				</cfoutput>
			  </td>	
			  <td colspan="2" align="right">		  
				  <cf_pagenavigation cpage="#cpage#" pages="#pages#">
			  </td>
			  </tr>
			 			  
		  </cfif>
		  	  		 
		  <tr><td colspan="3" height="100%"> 	 
		  
		    <cf_divscroll>
		  				
			<table border="0" width="99%" class="formpadding navigation_table">
			
			<TR class="fixrow labelmedium line">
			    <TD style="min-width:26"></TD>
			    <TD style="width:100%;min-width:200px"><cf_tl id="Name"></TD>				
			    <TD style="min-width:40"><cf_tl id="Nat."></TD>
			    <TD style="min-width:30">S</TD>
			    <TD style="min-width:120"><cf_tl id="BirthDate"></TD>
			    <TD style="min-width:100"><cfoutput>#client.IndexNoName#</cfoutput></TD>
				<TD style="min-width:150"><cf_tl id="Reference"></TD>			    
			    <TD style="min-width:100"><cf_tl id="Entered"></TD>
				<TD style="min-width:110"><cf_tl id="Accessed"></TD>
				<td style="min-width:40" align="center"></td>							
			 </TR>
				
			<cfquery name="Parameter" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
		    	FROM Parameter
			</cfquery>
									
			<cfif searchresult.recordcount eq "0">
			
			<tr><td height="35" colspan="12" align="center" class="labelmedium"><font color="6688aa"><cf_tl id="No records were found that match your selection"></b></font></td></tr>
			
			</cfif>
			
			<cfset currrow = 0>   
					 		
			<CFOUTPUT query="SearchResult" startrow="#first#">
			
				<cfif currentrow-first lt rows>		
						      
					<TR style="cursor:pointer;height:16px" class="line labelmedium navigation_row">
						
					<TD style="padding-left:4px;padding-top:2px;padding-right:4px" class="navigation_action" onClick="javascript:ShowCandidate('#PersonNo#')"><cf_img icon="select"></TD>
					<TD style="padding-right:4px"><a href="javascript:ShowCandidate('#PersonNo#')">#LastName# #LastName2#, #FirstName# #MiddleName#</a></TD>					
					<TD style="padding-right:4px">#Nationality#</TD>
					<TD style="padding-right:4px">#Gender#</TD>
					
					 <cfif dob neq "">
						 
						 <cfset age =  year(now()) - year(DOB)>
						 <cfif dayOfYear(DOB) gt dayOfYear(Now())>
						  <cfset age = age-1>
						 </cfif>
						 
						 <cfif age gte "120">	 
							 <cfset age = "">		 
						 <cfelse>	 
							 <cfset age = "#age#">	 
						 </cfif>		 
						 
					 <cfelse> 
					 	<cfset age = ""> 	 
					 </cfif>	
					
					<td style="padding-right:4px">#DateFormat(DOB, CLIENT.DateFormatShow)# (#age#)</td>
					<TD><a title="Employee details" href="javascript:EditPerson('#IndexNo#')">#IndexNo#</a></TD>					
					<TD style="padding-right:4px"><cfif documentReference neq "">#DocumentReference#<cfelseif eMailAddress neq "">#emailAddress#</cfif></TD>
					<td style="padding-right:4px">#DateFormat(Created, CLIENT.DateFormatShow)#</td>					
					<td style="padding-right:4px">
						<cfif dateformat(LastViewed,"YYYY") eq year(now())>
							#dateformat(LastViewed,"DD/MM")# #timeformat(LastViewed,"HH:MM")#
						<cfelse>
							#dateformat(LastViewed,client.dateformatshow)# #timeformat(LastViewed,"HH:MM")#
						</cfif>
					</td>
					
					<td colspan="1" align="right" style="padding-right:5px">
					
						<cfif submissions eq "0">
						
							<!--- no button shown --->
																
					    <cfelseif submissions eq "1">				
				
							<cf_RosterPHP 
								DisplayType = "HLink"
								Image       = "#SESSION.root#/Images/pdf_small.gif"
								DisplayText = ""
								style       = "height:14;width:16"
								Script      = "#currentrow-first + 1#"
								RosterList  = "#ApplicantNo#"
								Format      = "Document">
							
						<cfelse>
						
							<cfquery name="Submission" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							  SELECT 	*
							  FROM 		ApplicantSubmission S
							  WHERE 	PersonNo = '#personno#'
							  AND       ApplicantNo IN (SELECT ApplicantNo 
							  							FROM   ApplicantBackGround A 
														WHERE  ApplicantNo = S.ApplicantNo 
														AND    Status < '9')
							</cfquery>
						
							<table width="100%">
							
							<tr class="labelit">
							
							<cfset row = currentrow>
							
							<cfloop query="Submission">
														
								<td align="right" style="padding-right:5px">
							
								<cf_RosterPHP 
									DisplayType = "HLink"
									Image       = "#SESSION.root#/Images/pdf_small.gif"
									DisplayText = "#left(Source,2)#"
									style       = "height:14;width:16"
									Script      = "#row-first + 1#"
									RosterList  = "#ApplicantNo#"
									Format      = "Document">	
									
									</td>				
							
							</cfloop>  
							
							</tr>
							</table>									
						
						</cfif>	
					  
					</td>
										
					</TR>				
					
					<cfif remarks neq "">
				 
				 		<tr class="labelmedium" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F9F9F9'))#">
						 <td></td> 						
						 <td colspan="9" style="padding-left:4px"><font color="gray">#remarks#</td>
						</tr>
						
					</cfif>
															
					<cfif indicator neq "">		
						<cfset col          = "11">		
						<cfinclude template="../Candidate/Details/Functions/ApplicantFunctionSelection.cfm">
					</cfif>
					
					<cfif showassignment gte "1">
				
					<cfset col          = "11">						 		 
					<cfinclude template = "../Candidate/Details/Functions/ApplicantFunctionIncumbency.cfm">
				
					</cfif>
								
				</cfif>
				
			</CFOUTPUT>
			
			</TABLE>
			
			</cf_divscroll>
					
		</td></tr>
				
	</table>  

</cfif>
<cfset ajaxonload("doHighlight")>

<script>
Prosis.busy('no')
</script>

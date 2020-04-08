
<cfset linestatus = "h">
<cfparam name="currentrow" default="1">
<cfparam name="candidate" default="0">
<cfparam name="url.line" default="#currentrow#">

<cfif candidate eq "0">
		
		<cfquery name="DocParameter" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Vacancy.dbo.Parameter
		</cfquery>
		
		<cfquery name="Searchresult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		    SELECT A.IndexNo as IndexNoA, 
			       A.PersonNo, 
				   DC.Status, 
				   D.Owner,
				   Description, 
				   DC.Remarks, 
			       DC.OfficerLastName, 
				   DC.OfficerFirstName, 
				   DC.TsInterviewStart, 
				   DC.Created,
			   	   A.LastName, 
				   A.FirstName, 
				   A.Nationality, 
				   A.Gender, 
				   A.DOB, 
				   R.Color, 
				   DC.EntityClass as CandidateClass,
				   (SELECT  count(*) 
					FROM    Applicant.dbo.ApplicantReview A
					WHERE   A.PersonNo = DC.PersonNo 
					AND     A.Owner    = D.Owner) as ReviewInitiated
				   
		    FROM   Vacancy.dbo.Document D,
			       Vacancy.dbo.DocumentCandidate DC, 
			       Vacancy.dbo.Ref_Status R, 
				   Applicant.dbo.Applicant A
				   
			WHERE  D.DocumentNo = '#URL.ajaxid#' 
			AND    DC.Status = R.Status
			AND    D.DocumentNo = DC.DocumentNo
			AND    R.Class = 'Candidate' 
			AND    A.PersonNo = DC.PersonNo 			
			AND    DC.Status NOT IN ('2s','3')
			ORDER BY DC.Status DESC, DOB, A.LastName
		</cfquery>
		
		<cfif SearchResult.recordcount eq "0">
		
		<cfquery name="Searchresult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		 SELECT A.IndexNo as IndexNoA, 
			       A.PersonNo, 
				   DC.Status, 
				   D.Owner,
				   Description, 
				   DC.Remarks, 
			       DC.OfficerLastName, 
				   DC.OfficerFirstName, 
				   DC.TsInterviewStart, 
				   DC.Created,
			   	   A.LastName, 
				   A.FirstName, 
				   A.Nationality, 
				   A.Gender, 
				   A.DOB, 
				   R.Color, 
				   DC.EntityClass as CandidateClass,
				   (SELECT  count(*) 
					FROM    Applicant.dbo.ApplicantReview A
					WHERE   A.PersonNo = DC.PersonNo 
					AND     A.Owner    = D.Owner) as ReviewInitiated
				   
		    FROM   Vacancy.dbo.Document D,
			       Vacancy.dbo.DocumentCandidate DC, 
			       Vacancy.dbo.Ref_Status R, 
				   Applicant.dbo.Applicant A
				   
			WHERE  D.DocumentNo = '#URL.ajaxid#' 
			AND    DC.Status = R.Status
			AND    D.DocumentNo = DC.DocumentNo
			AND    R.Class = 'Candidate' 
			AND    A.PersonNo = DC.PersonNo 						
			ORDER BY DC.Status DESC, DOB, A.LastName	
			</cfquery>	
		
		</cfif>		
		
		<cfquery name="RosterParameter" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Applicant.dbo.Ref_ParameterOwner
			WHERE Owner = '#SearchResult.Owner#'
		</cfquery>
		
		<cfparam name="s" default="1">
		
		<cfif s eq "0">
		<cfparam name="cls" default="hide">
		<cfelse>
		<cfparam name="cls" default="regular">
		</cfif>
		
		<cfquery name="Doc" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Vacancy.dbo.Document
				WHERE DocumentNo = '#URL.ajaxid#'
		</cfquery>
		
	<cfif SearchResult.recordcount eq "0">
	
	<table width="100%" border="0" bgcolor="ffffef" align="center" id="shortlist">
			 <tr>
			 <td align="center" class="labelmedium" style="width:100%;height:40px"><font color="gray">No candidates have been listed for this recruitment track.</font></td>
			 </tr>
	</table>		 
	
	</cfif>	
		
	<cfif SearchResult.recordCount neq "0">
	
	<table width="100%" class="<cfoutput>#cls#</cfoutput>" border="0"	        			
			 bgcolor="ffffff"
			 align="center" 
			 id="shortlist">
			
		<cfquery name="Validation" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Vacancy.dbo.DocumentValidation
				WHERE DocumentNo = '#URL.ajaxid#'
				AND   ValidationCode = 'OverwriteSelection'
		</cfquery>		
		
		<cfinvoke component = "Service.Access"  
		   method           = "RoleAccess" 
		   role             = "'VacOfficer'"
		   mission          = "#doc.mission#"
		   accesslevel      = "'2'" 	  
		   returnvariable   = "accessOverwrite">			
		
	<cfif (RosterParameter.SelectionDaysOverwrite eq "1" and accessOverwrite eq "GRANTED") or Validation.recordcount eq "1" or getAdministrator("*") eq "1">
		
		<tr class="line"><td>
		
			<cfoutput>
			<table cellspacing="0" cellpadding="0">
			    				
				<cfif Validation.Recordcount eq "1">
			
				<tr><td height="20" class="labelmedium" style="padding-left:20px">	
					<font color="gray">Candidate selection validation is overruled by <b>#Validation.OfficerFirstName# #Validation.OfficerLastName#</b> on #dateformat(Validation.created, CLIENT.DateFormatShow)#</font>
					</td>
				</tr>	
					
				<cfelse>
					
				<tr><td height="20" style="height:25px;padding-left:20px" id="selectionvalidation" class="labelmedium">	
					 <a href="javascript:ColdFusion.navigate('DocumentCandidateValidation.cfm?documentNo=#url.ajaxid#','selectionvalidation')">					 
					 Press here</a> to overwrite the candidate selection limitation
					</td>
				</tr>	
			
				</cfif>
			
			</table>
			</cfoutput>
		
		</td></tr>	
		
	</cfif>
	
	<cfquery name="Search" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT A.*
		FROM     Vacancy.dbo.DocumentCandidate DC, Applicant.dbo.RosterSearch A
		WHERE    DC.SearchId = A.SearchId
		 AND     DC.DocumentNo = '#URL.AjaxId#'	
	</cfquery>
	
	<cfif Search.Recordcount gte "1">
		<tr class="line">
			<td style="padding-left:20px;padding-top:5px;fon-weight:200" class="labelmedium">The below candidates were shortlisted through the following roster searches: <cfoutput query="Search">
			<a href="javascript:searchview('#url.ajaxid#','#searchid#')">#searchid# (#OfficerlastName#)</a>
			<cfif currentrow neq recordcount>,</cfif> </cfoutput></td>
		</tr>
	</cfif>
	
	<tr><td>
	
	<table width="96%" align="center" class="formpadding navigation_table">
	
	    <TR class="labelmedium line">
	   	  <TD></TD>
		  <td></td>
	   	  <TD><cf_tl id="Id"></TD>
	      <TD><cf_tl id="LastName"></TD>
	      <TD><cf_tl id="FirstName"></TD>
		  <TD><cf_tl id="Nationality"></TD>
	      <TD><cf_tl id="Gender"></TD>
		  <TD><cf_tl id="BirthDate"></TD>
	   	  <TD><cf_tl id="Status"></TD>
		  <td></td>
		  <TD><cf_tl id="B"></TD>
	  	  <td></td>
	    </TR>			
		
		<cfquery name="Mission" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_Mission
			WHERE  Mission = '#Doc.Mission#'
		</cfquery>
			 	
		<cfoutput query="SearchResult">
			
		<TR class="labelmedium <cfif currentrow neq recordcount>line</cfif> navigation_row" style="height:20px">
		
		<td width="30" align="center" style="padding-top:4px">
		
			<cfquery name="Check" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 *
			    FROM   OrganizationObject
				WHERE  ObjectKeyValue1 = '#URL.ajaxid#'
				AND    ObjectKeyValue2 = '#PersonNo#'
				AND    Operational  = 1
			</cfquery>
			
		    <cfif Check.recordcount eq "1">
			
			   <td width="30" align="center" style="padding-top:4px">
			   <cf_img icon="open"  onClick="showdocumentcandidate('#URL.ajaxid#','#PersonNo#')">
			   </td>
			   
			   <!---
			
			   <img src="#SESSION.root#/Images/subflow.png" 
			   alt="Open recruitment track" 
			   border="0" 
			   align="absmiddle" 
			   style="border-color: Silver; cursor: pointer;" 
			   onClick="showdocumentcandidate('#URL.ajaxid#','#PersonNo#')">
			   
			   --->
					   
			<cfelse>
				<td width="30" align="center">
				#currentrow#.	   
				</td>
			</cfif>	   
		   

		
		<cfif dob neq "">
			
			<cfset age = year(now())-year(DOB)>
			<cfif dayofyear(now()) lt dayofyear(DOB)>
			  <cfset age = age -1>
			</cfif>
		
		<cfelse>
		
			<cfset age = "undefined">
			
		</cfif>
		
		<td><A HREF ="javascript:ShowCandidate('#PersonNo#')"><cfif IndexNoA neq "">#IndexNoA#<cfelse>#PersonNo#</cfif></a></td>
	    <td>#LastName#</td>
		<td>#FirstName#</td>
		
		<cfquery name="Nat" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   System.dbo.Ref_Nation
				WHERE  Code = '#nationality#'				
			</cfquery>
		
		<td>#Nat.Name#</td>
		<td><cfif Gender eq "F">Female<cfelse>Male</cfif></td>
		<td>#dateFormat(DOB,CLIENT.DateFormatShow)# <cfif DocParameter.MaximumAge lt Age><font color="FF0000">alert&nbsp;</cfif>age:<b>#age#</b></font></td>
		<td>#Description#<cfif Status eq "2s" and CandidateClass eq "">&nbsp;<b>:&nbsp;Flow</b></cfif></td>
		<td width="30">
		
		<cfif TsInterviewStart neq "">
		
				<cfquery name="Check" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  TOP 1 *
				    FROM    Vacancy.dbo.DocumentCandidateInterview
					WHERE   DocumentNo = '#url.ajaxid#'
					AND     PersonNo   = '#PersonNo#'
					ORDER By Created DESC
				</cfquery>
		
		     <img src="#SESSION.root#/Images/interview.gif" alt="See interview notes" 
				name="a#CurrentRow#" border="0" class="regular" 
				onMouseOver="document.a#currentrow#.src='#SESSION.root#/Images/interview.gif'" 
				onMouseOut="document.a#currentrow#.src='#SESSION.root#/Images/interview.gif'"
				align="ansmiddle" style="cursor: pointer;" 
				onClick="personnote('#PersonNo#','view')">
				
		<cfelse>
		
			<!--- --->
				
		</cfif>
		
		</td>
		
		<td>
		<cfif reviewInitiated eq "0">
		<table><tr><td width="10" height="12" bgcolor="FF0000" style="border:1px solid black"></td></tr></table>
		</cfif>
		</td>
		
		<td>	
							
			<cfparam name="dialogAccess" default="edit">	
									
			<cfif Status lte "2s">
					
				<cfif dialogAccess eq "EDIT">
				 
				   <cf_img icon="delete" onClick="personcancel('#URL.ajaxid#','#PersonNo#','#url.line#','DocumentCandidateDeleteSubmit.cfm')">
				   			 
			    </cfif>
			
			<cfelseif Status eq "6" <!--- stalled ---> or Status eq "9" <!--- withdrawm --->>
				
				<cfif dialogAccess eq "EDIT">
				<a href="javascript:reinstate('#URL.ajaxid#','#PersonNo#')"><font color="0080C0">[reinstate]</font></a>
				</cfif>
					
			</cfif>
		</td>
		
		</tr>
		
		<cfquery name="Param" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Vacancy.dbo.Parameter
			WHERE Identifier = 'A'
		</cfquery>
		
		<cf_filelibraryCheck
					DocumentPath="VacCandidate"
					SubDirectory="#URL.ajaxid#" 
					Filter="#PersonNo#">	
					
		<cfif files gte "1">			
		
			<cfif DocParameter.showAttachment eq "1">
			
				<tr>
				<td></td>
				<td colspan="9">
				
				<cfquery name="VactrackParameter" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM Vacancy.dbo.Parameter
				</cfquery>
									
				<cfif status lte "2">
											
					<cf_filelibraryN
						DocumentPath="VacCandidate"
						SubDirectory="#URL.ajaxid#" 
						Filter="#PersonNo#"
						box="candidate#currentrow#"
						Loadscript="No"
						color="transparent"
						Insert="yes"
						Remove="yes"
						ShowSize="1">	
									
				<cfelse>
						
					<cf_filelibraryN
						DocumentPath="VacCandidate"
						SubDirectory="#URL.ajaxid#" 
						Filter="#PersonNo#"
						box="candidate#currentrow#"
						Loadscript="No"		
						color="transparent"
						Insert="no"
						Remove="no"
						ShowSize="1">	
									
				</cfif>	
					
				</td>
				<td></td>
				</tr>
			
			</cfif>
		
		</cfif>
							
		<cfif ReviewInitiated gte "1">
			<tr><td></td><td colspan="10">		   			
				<cf_DocumentCandidateReview 
						  Owner    = "#Owner#"	
				          Color    = "transparent" 
						  PersonNo = "#PersonNo#">		
						  						  	
			</td>
			</tr>
		</cfif>
				
		<cfinvoke component = "Service.Process.Applicant.Vacancy"  
		   method           = "Candidacy" 
		   Owner            = "#Mission.MissionOwner#"
		   DocumentNo       = "#URL.ajaxid#" 
		   PersonNo         = "#personno#"	
		   Status           = ""   
		   returnvariable   = "OtherCandidates">	
			
		<cfif OtherCandidates.recordcount gte 1>
						
		<tr bgcolor="transparent">
		<td></td>
		<td colspan="9">
				
		   <table border="0" style="border:1px dotted silver" cellpadding="0" cellspacing="0" width="99%" align="center">
			
			<cfloop query="OtherCandidates">		
			
				<cfif Validation.Recordcount eq "1">		
				   <cfset cel = "ffffcf">					   
				<cfelseif Status eq "Short-listed">				
				   <cfset cel = "ffffcf">				   
				<cfelse>							
				   <cfset cel = "FF0000">   				   
				</cfif>
	
				<tr bgcolor="#cel#">
					<td height="17" class="labelit" style="padding-left:5px">
						<a href="javascript:showdocument('#DocumentNo#')">
							
							<cfif cel eq "FF0000">
							   <font color="FFFFFF">
							</cfif>
	
							Candidate <b>#Status#</b> for
							<b>#OtherCandidates.Mission#&nbsp;#OtherCandidates.PostGrade# &nbsp;#OtherCandidates.FunctionalTitle#, track : #DocumentNo#</b>
							</font>
		
						</a>
				    </td>
				</tr>
							
			</cfloop>
			
			</table>
						
		</td>
		<td></td>
		</tr>	
		
		</cfif>	
							
		<cfif Remarks neq "">
			<tr>
			<td colspan="2"></td>
			<td colspan="9">#Remarks#</td>
			</tr>
		</cfif>		
			
		</cfoutput>
			
	</table>	
	
	</td></tr>
		
	</table>
	
	</cfif>
	
</cfif>

<cfset candidate = "1">

<cfset ajaxonload("doHighlight")>


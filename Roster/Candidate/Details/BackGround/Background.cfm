
<!--- Hanno : we need a provision for the online user to process it, even if allowedit = 0 --->

<cfparam name="URL.entryScope"      default="Backoffice"> 
<cfparam name="URL.source"          default="Manual">  
<cfparam name="URL.Topic"           default="Employment"> 
<cfparam name="url.section" 	    default="">
<cfparam name="url.applicantno"     default="">
<cfparam name="url.owner"           default="">
<cfparam name="client.ApplicantNo"  default="">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter
</cfquery>

<!--- here we check if the edit access to this template is
granted based on the navigation section/owner we are in --->

<cfquery name="getSource" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Source
	WHERE    Source = '#url.source#'
	
</cfquery>

<cfif url.entryScope eq "Backoffice">

	<cfinvoke component="Service.Access"  
 	method="roster" 
 	returnvariable="AccessRoster"
 	role="'AdminRoster','CandidateProfile'">
 	
<cfelse>

	<cfset AccessRoster = "ALL">

</cfif>

<cfquery name="qCheckOwnerSection" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ApplicantSectionOwner
	WHERE    Owner = '#URL.Owner#'
	AND      Code  = '#URL.Section#' 
</cfquery>

<cfif qCheckOwnerSection.recordcount eq 0>
	<cfset AccessLevelEdit = "2">
<cfelse>	
	<cfset AccessLevelEdit = qCheckOwnerSection.AccessLevelEdit>
</cfif>	

<!--- ---------------------------------- --->
<!--- determine if we can edit this form --->
<!--- ---------------------------------- --->

<cfset mode = "read">

<cfif getSource.operational eq "1" and getSource.allowedit eq "1">
			
 	<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">	
	
		<cfif AccessLevelEdit eq "2">	
			
			<cfset mode = "edit">
		
		</cfif>
		
	</cfif>	

</cfif>

<script language="JavaScript">
	
	function minimize(itm,icon) {		 
		 se   = document.getElementById(itm);
		 icM  = document.getElementById(itm+"Min");
	     icE  = document.getElementById(itm+"Exp");
		 se.className  = "hide";
		 icM.className = "hide";
		 icE.className = "regular";		 
	  }
	  
	function maximizeit(itm,icon){		 
		 se   = document.getElementById(itm);
		 icM  = document.getElementById(itm+"Min");
	     icE  = document.getElementById(itm+"Exp");
		 se.className  = "regular";
		 icM.className = "regular";
		 icE.className = "hide";		 
	  }  

 </script> 

<cfquery name="Candidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Applicant
	WHERE  PersonNo = '#URL.ID#'	
</cfquery>

<!--- -------------------------------------------------------- --->
<!--- show background from any submission with the same source --->
<!--- -------------------------------------------------------- --->

<cfparam name="URL.ApplicantNo" default="">

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*, 
	         S.Source, 
		     P.Parent as Parent, 
		     P.KeywordsMinimum, 
		     P.KeywordsMessage, 
			 R.Operational,
		     R.AllowEdit,
		     (SELECT count(*) FROM ApplicantReviewBackGround WHERE ExperienceId = A.ExperienceId) as Review
	FROM     ApplicantSubmission S, 
	         ApplicantBackground A,
		     Ref_ParameterSkillParent P,
		     Ref_Source R
	WHERE    S.PersonNo = '#URL.ID#'	
	<!--- only the source as it was selected --->	
	AND      S.Source   = '#url.source#'	   	
	AND      S.ApplicantNo = A.ApplicantNo
	<cfif url.applicantno neq "">
 	 AND      S.ApplicantNo = '#URL.ApplicantNo#' 
	</cfif>
	AND      R.Source      = S.Source
	AND      A.Status IN ('0','1')
	AND      A.ExperienceCategory IN ('#URL.ID2#')
	AND      A.ExperienceCategory = P.Code	
	ORDER BY ISNULL(ExperienceEnd, '9999-12-31') DESC,
	         A.ExperienceStart DESC, 
	         A.ExperienceId 			 	 
			
</cfquery>

<cfif mode eq "edit" or client.applicantno eq applicantno>
	
	<cfoutput>
	
	  <script language="JavaScript">
		  
		function bgadd(appno,cls) {		
		  ptoken.location("#SESSION.root#/Roster/Candidate/Details/Background/BackgroundEntry.cfm?owner=#url.owner#&applicantno="+appno+"&section=#url.section#&entryScope=#url.entryScope#&Source=#url.source#&Topic=#URL.Topic#&ID=&ID1=#URL.ID#&ID2="+cls)
		}  
		
		function bgedit(appno,expno,cls,src) {
		  ptoken.location("#SESSION.root#/Roster/Candidate/Details/Background/BackgroundEntry.cfm?owner=#url.owner#&applicantno="+appno+"&section=#url.section#&entryScope=#url.entryScope#&Source=#url.source#&Topic=#URL.Topic#&ID=" + expno + "&ID1=#URL.ID#&ID2="+cls+"&mode=1")
		}
		
		function bgedit2(appno,expno,cls,src) {
		  ptoken.location("#SESSION.root#/Roster/Candidate/Details/Background/BackgroundEntry.cfm?owner=#url.owner#&applicantno="+appno+"&section=#url.section#&entryScope=#url.entryScope#&Source=#url.source#&Topic=#URL.Topic#&ID=" + expno + "&ID1=#URL.ID#&ID2="+cls+"&mode=2")
		}
		
		function bgpurge(appno,expno,src) {
			<cf_tl id="Do you want to remove this record" var="1">
		  if (confirm("#lt_text# ?")) {
			  	ptoken.location("#SESSION.root#/Roster/Candidate/Details/Background/BackgroundPurge.cfm?owner=#url.owner#&applicantno="+appno+"&section=#url.section#&entryScope=#url.entryScope#&Source="+src+"&ID=#URL.ID#&ID2=#URL.ID2#&Topic=#URL.Topic#&ID0=" + expno)
			   	}	  
		}
	 
	 </script>
	 
	</cfoutput>

</cfif>

<cfset cnt = 0>

	<cfif URL.Topic neq "All">
		
		<cfoutput>
			
		<table width="97%" align="center">
		
		
		<cfif mode eq "edit">
		
		    <tr><td style="height:35;font-size:20px;padding-right:10px" class="labellarge line">
			
				</td>
			    <td align="right" style="height:25;padding-right:10px">
													
					   		<input class="button10g" 
							style   = "width:210px;height:25;border-radius:5px"
					   		type    = "button" 
					   		onclick = "javascript:bgadd('#url.applicantno#','#URL.Topic#')" 
					   		name    = "AddBackground" 
					   		value   = "Add #URL.Topic# record">
						
				
				</td>
			</tr>
			
		</cfif>
		
		</cfoutput>
		
	<cfelse>	
	
	    <table width="99%" align="center" class="formpadding">
								
			<tr><td align="right" colspan="2">
			
				<cfif mode eq "edit">
								
			       <cfoutput>
				   
				   <input class="button10g" 
					      type="button" 
					      onclick="javascript:bgadd('#url.applicantno#','#URL.ID2#')" 
					      name="AddBackground" 
					      style="width:240px;height:25px;border-radius:5px"
					      value="Add #URL.ID2# record">
						  
				   </cfoutput>
				   
				 </cfif> 
				  
			</td></tr>	
				
	</cfif>

<tr><td colspan="2">

<table width="100%" align="center" class="navigation_table">

<cfset yr = 0>
<cfset row = 0>

<cfif detail.recordcount eq "0">
	
	<tr>
		<td colspan="8" style="height:30" class="labelmedium" align="center"><cf_tl id="No records found"></td>
	</TR>

</cfif>

<cfset prioryear = ""> 
 
<cfoutput query="Detail" group="ExperienceId">
	
   <cfif ExperienceEnd neq "">
	  <cfset yr = year(ExperienceEnd)>
   <cfelse>
	  <cfset yr = year(now())>
   </cfif>	
	  
   <cfif yr neq prioryear>  	  
   
   	  <cfset prioryear = yr>
	 	 
	  <tr><td height="20" colspan="8" style="font-size:27px" class="labelmedium">#Yr#</td></tr>
	  
   </cfif>
		
	<cfif Status neq "9">
	    <tr bgcolor="ffffff" class="navigation_row">
	<cfelse>	
	    <tr bgcolor="red"    class="navigation_row">
	</cfif>
	
	<cfset row = row + 1>
	
	<td colspan="8" class="labelit" style="padding-left:5px">
	
	   <table>
	   
	   <tr><td class="labelit" valign="top" style="padding-top:4px">#Row#.</td>
	   
		   <td colspan="2">
		   
		   <table>
		   <tr>		
		   
	       <cfif mode eq "edit" or client.applicantno eq applicantno>  <!--- added by hanno to allow EAD portal access to edit --->
		   <td style="padding-left:3px;padding-top:2px">
		      <cf_img icon="edit" onclick="bgedit('#applicantno#','#ExperienceId#','#ExperienceCategory#','#Source#')">
		    </td>	 					 
		   </cfif>	  
		 
		   <cfif mode eq "edit">
		   <td style="padding-left:2px;padding-top:3px">		  
		      <cf_img icon="delete" onclick="bgpurge('#applicantno#','#ExperienceId#','#source#')">
		    </td>
		   </cfif>		   
		   
	        </tr>
     	   </table>
		   
	   </td>
			  	   
	   <td class="labelmedium" style="padding-left:10px;font-size:17px;font-weight:bold">
	   
		 #ExperienceDescription#
		 
		 <cfif ExperienceCategory eq "Employment">
			
					<cfquery name="moreDetails" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT R.*, D.TopicValue
						FROM   ApplicantBackgroundDetail D, Ref_Topic R
						WHERE  D.ApplicantNo  = '#ApplicantNo#'
						AND    D.ExperienceId = '#ExperienceId#'
						AND    R.Topic = D.Topic
						AND    R.Operational = 1
					</cfquery>	
					
					<cfif moredetails.recordcount gte "1">					
					<a href="javascript:maximizeit('#CurrentRow#','Exp')"><cf_tl id="responsibilities">...</a>					
					</cfif>
						      
			</cfif>
		 
	   </td>
	
		</tr>
		</table>
		 
	</td>
	
	<!---
	<td colspan="3" valign="bottom" align="right" class="labelmedium" style="height:21px;padding-right:15px;padding-bottom:2px">
	<cfif SalaryCurrency neq "">
	    <cf_tl id="Salary">: #SalaryCurrency# &nbsp;#NumberFormat(SalaryStart,'_,_')# - &nbsp;#NumberFormat(SalaryEnd,'_,_')#
	</cfif>
	</td>
	--->
	</tr>
	
	<tr class="navigation_row_child labelmedium" style="height:20px">
		<td width="5%" align="left"></td>	
		<td colspan="6">
			<table>
				<tr class="labelmedium">
				<td style="font-size:16px">
				#DateFormat(ExperienceStart,CLIENT.DateFormatShow)#
				- <cfif ExperienceEnd lt "01/01/40" or ExperienceEnd gt "01/01/2020" ><cf_tl id="Todate"><cfelse>#DateFormat(ExperienceEnd,CLIENT.DateFormatShow)#</cfif>		
				</td>
				</tr>
				<tr><td>#OrganizationName# - #OrganizationCity# (#OrganizationCountry#)</td></tr>		
			</table>
		</td>		
		<td width="20%" align="right" style="padding-right:10px">#Source# <cfif updated neq ""><font size="2">&nbsp;(#dateformat(updated,CLIENT.DateFormatShow)#)</cfif></td>
		
	</tr>
	
	<cfif Remarks neq "">
		<tr class="navigation_row_child" style="height:20px">
			<td></td>
			<td colspan="7" class="labelit">#Remarks#</td>
		</tr>
	</cfif>
	
	<cfif OrganizationAddress neq "">
		<tr class="navigation_row_child" style="height:20px">			
			<td></td>
			<td colspan="7" class="labelit">#OrganizationAddress#</td>
		</tr>
	</cfif>
			
	<tr class="navigation_row_child labelmedium" style="height:20px">		
		<td></td>
		<td colspan="4">
		<cf_tl id="Supervisor eMail">:<cfif OrganizationEMail neq "">
		<a href="javascript:email('#OrganizationEMail#','#Candidate.FirstName# #Candidate.LastName#','','','','')">#OrganizationEMail#</a>
		<cfif OrganizationTelephone neq "">&nbsp;<cf_tl id="Tel">:&nbsp;#OrganizationTelephone# </b></cfif>
		<cfelse> N/A</cfif></b></td>
		<td colspan="3" align="right" style="padding-right:10px;height:21px;"><cfif StaffSupervised neq "0"><font size="1"><cf_tl id="Supervised">:</font> <cfif StaffSupervised eq "">n/a<cfelse>#StaffSupervised#</cfif></cfif></td>
	</tr>
	
	<!--- ------------------------------------------------------- --->
	<!--- detected requests for validation of the work experience --->
	<!--- ------------------------------------------------------- --->
	
	<cfif url.entryscope eq "backoffice">
	
		<cfif review gte "1">
					
				<cfquery name="Checking" 
						datasource="appsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT  *
						FROM    ApplicantReview A, 
						        Ref_ReviewClass R
						WHERE   A.ReviewCode = R.Code
						AND     A.Reviewid IN (SELECT ReviewId 
						                       FROM ApplicantReviewBackGround 
											   WHERE ExperienceId = '#experienceid#')
	
						<cfif Parameter.ReviewOwnerAccess eq "0">
											   
						    <cfif SESSION.isAdministrator eq "No" and SESSION.isOwnerAdministrator eq "No">
							
								AND     A.Owner    IN (
						
											SELECT    DISTINCT ClassParameter
											FROM      Organization.dbo.OrganizationAuthorization
											WHERE     UserAccount = '#SESSION.acc#' 
											AND       Role IN ('AdminRoster', 'RosterClear')
											AND       ClassParameter IN (SELECT Owner FROM Applicant.dbo.Ref_ParameterOwner WHERE Operational = 1)
											
											)
						
													
							</cfif>						   
						
						</cfif>					   
											   
						AND     R.Operational = 1
						ORDER BY Status DESC	
				</cfquery>
							
				<cfif checking.recordcount gte "1">
					
					<tr class="navigation_row_child"><td colspan="8" align="center" style="padding-top:8px;padding-right:8px;padding-bottom:8px;padding-left:35px">
									
						<table width="90%" style="border:1px solid gray;border-radius:6px" align="center" class="formpadding" cellspacing="0" cellpadding="0" bgcolor="ffffcf">
							
							<tr class="line labelmedium" bgcolor="ffffef">
							    <td style="padding-left:4px"><cf_tl id="Review type"></td>
								<td><cf_tl id="Owner"></td>
								<td><cf_tl id="Priority"></td>
								<td><cf_tl id="Status"></td>
								<td><cf_tl id="Initiated"></td>
								<td><cf_tl id="Date"></td>
								<td></td>
							</tr>
													
							<cfloop query="checking">
							
								<tr class="labelmedium">
								<td style="padding-left:4px">#Description#</td>
								<td>#Owner#</td>
								<td>#PriorityCode#</td>
								<td>
										<cfswitch expression="#Status#">
												<cfcase value="0"> <font color="blue">Pending</font></cfcase>
												<cfcase value="9"><font color="FF0000">Denied</font></cfcase>
												<cfcase value="1">Cleared</cfcase>
										</cfswitch>
								</td>
								<td>#OfficerLastName#</td>
								<td>#DateFormat(Created,CLIENT.DateFormatShow)#</td>
								<td></td>
								</tr>	
																					
							</cfloop>
													
						</table>
							
						</td>
					</tr>
				
				</cfif>	
								
		</cfif>
	
	</cfif>
								
	<cfif ExperienceCategory eq "Employment" and moredetails.recordcount gte "1">
						  				
		<tr id="#currentrow#" class="hide">
							
		<td colspan="8" style="padding-top:2px;padding-left:37px;padding-right:10px">
		
		<table width="100%" align="center">
		
		    <tr>
				<td class="labelmedium" style="padding-left:14px">
				<a href="javascript:minimize('#CurrentRow#','Min')"><cf_tl id="Hide"></a>
				</td>
			</tr>
		
			<tr><td>
				
				<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
				<cfloop query="moreDetails">
				
				    <tr><td style="padding-left:38px; padding-top:4px" class="labellarge">#Description#</td></tr>
					<tr><td class="labelmedium" style="padding:20px">#TopicValue#</td></tr>
									
				</cfloop>
				
				</table>
				
			</td></tr>
			<tr><td height="4"></td></tr>
		</table>
		
		</td>
		</tr>
						
	</cfif>			
					
		<cfoutput group="Parent"> 
		
					<cfquery name="Key" 
				    datasource="AppsSelection" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
						SELECT  R.Description, P.Description as ExperienceClassDescription
						FROM    ApplicantBackgroundField A, 
						        Ref_Experience R, 
								Ref_ExperienceClass P
						WHERE   A.ApplicantNo  = '#ApplicantNo#'
						AND     A.ExperienceId = '#ExperienceId#'
						AND     A.ExperienceFieldId = R.ExperienceFieldId	
						AND     R.ExperienceClass = P.ExperienceClass
						AND     P.Parent = '#Parent#'	 
					</cfquery>	
													
					<cfif Key.recordcount gt "0">
					
						<cfset k = "">
					
						<cfif url.EntryScope eq "Backoffice">
							<cfloop query = "key">
								<tr class="line navigation_row_child">		
								    <td></td>
									<cfif k neq ExperienceClassDescription>
										<td class="labelit" style="height:20px;padding-left:20px" width="25%">&nbsp;<font color="gray">#ExperienceClassDescription#</td>
										<cfset k = "#ExperienceClassDescription#">
									<cfelse>
										<td width="40%"></td>
									</cfif>
									<td class="labelmedium" colspan="6" style="height:20px"><font color="800000">#Description#</td>
								</tr>										
							</cfloop>				
						</cfif>
									
				<cfelse>
				
				    <!--- no longer relevant as we have different ways to alet fooks 
				
						<cfif CLIENT.submission eq "Skill">
					 								
							<cfif Key.recordcount lt KeyWordsMinimum>
								<tr><td colspan="8" align="left">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
									<tr class="labelit">
									    <td width="40%" style="padding-left:45px" class="labelmedium">#Parent#</td>
									    <td width="60%" class="labelmedium">
									    <A href="javascript:bgedit('#ExperienceId#','#ExperienceCategory#','#Source#')">
									     <font color="red"><u><cf_tl id="PRESS HERE TO COMPLETE"></u></font>
									    </a>
									    </td>
									</tr>
									</table>
								</td></tr>
								
							</cfif>
					 
					   	</cfif>
					
					--->
					
				</cfif>				
														
			<cfquery name="Generic" 
		    datasource="AppsSelection" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT A.*, R.Description as TopicDescription 
			    FROM   ApplicantBackgroundClassTopic A, 
				       Ref_ExperienceParentTopic R, 
					   Ref_ExperienceClass C
			    WHERE A.ApplicantNo = '#ApplicantNo#'
				AND   A.ExperienceId = '#ExperienceId#'
				AND   R.FieldTopicId = A.FieldTopicId
				AND   C.ExperienceClass = A.ExperienceClass
				AND   C.Parent = '#Parent#'
			</cfquery>
			
			<cfif Generic.recordcount gt "0">
				<cfset k = "">
				<tr  class="navigation_row_child"><td colspan="8">
				
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
					
						<cfloop query = "generic">
						
							<tr class="labelit">	
								
								<cfif k neq "Generic">
										<td width="40%">&nbsp;&nbsp;&nbsp;<cf_tl id="Generic"></b></td>
										<cfset k = "Generic">
								<cfelse>
										<td width="40%"></td>
								</cfif>
								<td width="60%">#TopicDescription#</b></td>
							
							</tr>
						
						</cfloop>
								
					</table>
					
					</td>
				</tr>
			</cfif>				
						
		</cfoutput>
		
		
		<tr><td style="height:10px"></td></tr>
		<tr class="line navigation_row_child"><td colspan="7"></td></tr>
		<tr><td style="height:10px"></td></tr>
				
</cfoutput>

</table>

</td>
</tr>
</table>

<cfset ajaxonload("doHighlight")>



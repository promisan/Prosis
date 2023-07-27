
<cfoutput>

<cf_screentop height="100%" html="No" scroll="Yes" jquery="Yes">

<cfparam name="URL.Mode"       default="generic">
<cfparam name="URL.Owner"      default="">
<cfparam name="URL.IDTemplate" default="reload">
<cfparam name="URL.ID1"        default="">

<cftry>
	
	<cfquery name="insert" 
		datasource="AppsSelection">
			INSERT INTO ApplicantInquiryLog 
			(PersonNo, 
			 NodeIP, 
			 HostSessionNo, 
			 PHPSection, 
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
			VALUES 
			('#URL.ID#',					 
			 '#CGI.Remote_Addr#', 
			 '#CLIENT.sessionNo#', 
			 'Roster',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
	</cfquery>		

	<cfcatch></cfcatch>

</cftry>
	
<script language="JavaScript">
	
	function memo(topic,row) {
			icE  = document.getElementById(topic+row+"Min");
			icM  = document.getElementById(topic+row+"Exp");
			se   = document.getElementById(topic+row);
					
			if (se.className =="hide") {
			   	 icM.className = "regular";
			     icE.className = "hide";
				 se.className  = "regular";						 
	 		 } else {
			   	 icM.className = "hide";
			     icE.className = "regular";
			   	 se.className  = "hide";
			 }
		 }
	
	w = 0
	h = 0
	if (screen) {
		w = #CLIENT.width# - 60
		h = #CLIENT.height# - 110
	}
	
	function questions(id) {
		
		se = document.getElementById(id)
		se2 = document.getElementById(id+"_2")
		ex = document.getElementById(id+"Exp")
		co = document.getElementById(id+"Min")
		
		if (se.className == "regular")
			  {se.className = "hide";
			   ex.className = "regular";
			   co.className = "hide"; 
			   se2.className = "hide";}
		else {
		        se.className = "regular"; 
			    se2.className = "regular"
				ex.className = "hide";
			    co.className = "regular"; 
			}
	}   
	
	function showdocument(vacno) {
		ptoken.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	function ShowFunction(AppNo,FunId,mode) {		
		ptoken.open("#SESSION.root#/roster/RosterSpecial/RosterProcess/ApplicationFunctionView.cfm?Mode=#URL.Mode#&ID=" + AppNo + "&ID1=" + FunId + "&IDFunction=" + FunId + "&IDTemplate=#URL.IDTemplate#&page=1", AppNo);		
	}

</script>

</cfoutput>

<cfquery name="getEdition" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_SubmissionEdition S
	  WHERE  SubmissionEdition = '#URL.ID1#'				
</cfquery>

<cfif url.owner eq "">
	<cfset url.owner = getEdition.Owner>
</cfif>

<cfquery name="FunctionAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT F1.SubmissionEdition, 
	       F1.FunctionId, 
		   F.FunctionDescription, 
		   F1.Mission,
		   F1.AnnouncementTitle,		   
		   R.OrganizationCode, 
	       R.OrganizationDescription, 
		   R.HierarchyOrder, 
		   R1.ListingOrder, 
		   R1.Description as GradeDeployment,
		   R3.Owner,
		   R3.Operational,
	       A.Created, 
		   A.Status as StatusCode, 
		   A.StatusDate,
		   A.FunctionJustification, 
		   A.RosterGroupMemo,
		   S.PersonNo,
		   S.ApplicantNo, 
		   R2.EnableStatusDate,
		   R2.Meaning, 
		   S.Source, 
		   F1.ReferenceNo, 
		   F1.DocumentNo,	   
		   A.FunctionDate,
		   C.Description as ClassDescription,
		   
		   (SELECT count(*) 
			FROM   ApplicantMail E 
			WHERE  E.PersonNo    =  S.PersonNo 
			AND    E.FunctionId  =  A.FunctionId 
			AND    E.RosterActionNo is NULL
			AND    MailStatus != '9') as MailId
		   
	FROM   ApplicantSubmission S,
	       ApplicantFunction A, 
	       FunctionTitle F, 
		   FunctionOrganization F1, 
		   Ref_Organization R, 
		   Ref_GradeDeployment R1,
		   Ref_StatusCode R2,
		   Ref_SubmissionEdition R3 , 
		   Ref_ExerciseClass C 		  
	WHERE  S.PersonNo    = '#URL.ID#'
	 AND   S.ApplicantNo = A.ApplicantNo
	 
	 <cfif URL.ID1 neq "">
	 
	 	AND  F1.SubmissionEdition = '#URL.ID1#'
		<!---
		AND  F1.SubmissionEdition = S.SubmissionEdition
		--->
			 
	 </cfif>
	 
	 <cfif URL.Owner neq "">
	 	 
	   AND  R3.Owner = '#URL.Owner#' <!--- we show all of the selected owner --->
	   
	 <cfelseif SESSION.isAdministrator eq "No">
	 
	   <!--- we filter record for the owner that has access --->	
	 
	   AND  R3.Owner IN (SELECT  ClassParameter
	                     FROM    Organization.dbo.OrganizationAuthorization 
						 WHERE   UserAccount    = '#SESSION.acc#'
						 AND     Role           = 'AdminRoster'
						 AND     ClassParameter = R3.Owner )	     
	 
	 </cfif> 
	 
	 AND   A.FunctionId         = F1.FunctionId
	 AND   F1.FunctionNo        = F.FunctionNo
	 AND   R2.Status            = A.Status
	 AND   R2.Id                = 'Fun'
	 AND   R2.Owner             = R3.Owner
	 AND   R3.ExerciseClass     = C.ExcerciseClass
	 AND   R3.SubmissionEdition = F1.SubmissionEdition --->
	 AND   R.OrganizationCode   = F1.OrganizationCode
	 AND   R1.GradeDeployment   = F1.GradeDeployment
	 
	 <cfif CLIENT.Submission eq "Skill">
	 AND   A.Status != '9'
	 </cfif>
	 
	ORDER BY C.Description,
	         A.FunctionDate DESC, 
	         R.HierarchyOrder, 
			 R1.ListingOrder, 
			 F1.GradeDeployment, 
			 F.FunctionDescription
			 
			
</cfquery>

<cfset deny = "0">

<cf_DialogStaffing>

<cfif url.owner eq "">
	<cfset url.owner = functionall.owner>
</cfif>	

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterOwner
	WHERE  Owner = '#URL.Owner#' 
</cfquery>

<cfquery name="PreRosterStatus" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_StatusCode
	WHERE  Owner   = '#URL.Owner#'
	AND    Id      = 'Fun'
	AND    PrerosterStatus = 1
</cfquery>	

<cfform action="ApplicantFunctionSubmit.cfm?Owner=#URL.Owner#&ID=#URL.ID#&ID1=#URL.ID1#" method="post" style="height:98%">

<table width="100%" height="100%"  align="center">
	   
<tr><td colspan="2" align="center" width="96%" style="padding-left:10px">
	<cfinclude template="../Applicant/Applicant.cfm">
</td></tr>	   
 
<tr>
  <td height="100%" width="100%" colspan="2" valign="top" align="center" style="padding-left:5px">
  
	<table align="center" width="98%" style="padding-left:3px" class="navigation_table">
		   
	<tr>
	  <td colspan="5" style="height:50px;font-size:30px;padding-top:4px;padding-left:5px" class="labellarge"><cf_tl id="Roster Candidacy"></td>
	  
	  <td colspan="6"  align="right" style="padding-right:5px">
	  
	  <table><tr><td class="labelmedium2">
			  
		<cfif getEdition.EnableManualEntry eq "1" and getEdition.Operational eq "1">
		
		       <cfinvoke component="Service.Access"  
			   method="roster" 
			   returnvariable="Access"
			   owner="#getEdition.owner#"
			   role="'AdminRoster','CandidateProfile'">	
				 			  
			  	<cfif Access eq "EDIT" or Access eq "ALL">
			  
			      <cfoutput>
					  <a href="ApplicantFunctionEntry.cfm?id=#url.id#&id1=#url.id1#"><cf_tl id="Record Candidacy"></a>				  
				  </cfoutput>
				  
			    <cfelse>
				
					<cf_tl id="No access granted">
					<cfabort>
					
			 	 </cfif>	
				 
	  </cfif> 	
	  
	  </td>
	  
	  <td style="padding-left:4px">|</td>
	  <td style="padding-left:5px;padding-right:5px" class="labelmedium">
	  
	  <a href="javascript:window.print()"><cf_tl id="Print"></a>
	  
	  </td></tr></table>
	  
	  </td>
	</tr>
			
	<TR class="labelmedium line fixrow fixlengthlist" style="border-top:1px solid silver">
	    <TD height="20"></TD>
	    <TD style="width:20px"></TD>
		<TD><cf_tl id="Title"></TD>
	    <TD><cf_tl id="Level"></TD>
		<TD><cf_tl id="Entity"></TD>
		<TD><cf_tl id="VA"></TD>
		<TD><cf_tl id="Status"></TD>	
		<TD><cf_tl id="Applied"></TD>	
		<TD><cf_tl id="Status"></TD>
		<TD><cf_tl id="Edition"></TD>
		<TD><cf_tl id="Source"></TD>
		<TD align="center" width="20"></TD>
	</TR>
	
	<!--- only if operational edition and adding enabled --->
	
	<cfif getEdition.EnableManualEntry eq "1" and getEdition.Operational eq "1">
	
		<cfif FunctionAll.recordcount eq "0">		
		<tr class="line labelmedium fixlengthlist"><td colspan="11" style="height:30" align="center">
		<font color="FF0000">No candidacy records found for this edition. 
			  <cfif Access eq "EDIT" or Access eq "ALL">	
			  <cfoutput>
			  <a href="ApplicantFunctionEntry.cfm?id=#url.id#&id1=#url.id1#">Press here to record Candidacy</a>				 
			  </cfoutput>
			  </cfif>
		</font></td>
		</tr>		
		</cfif>
	
	</cfif>
	
	<cfoutput query="FunctionAll" group="ClassDescription">
		
	<tr class="labelmedium fixrow2"><td colspan="12" style="padding-left:10px;font-size:35px;height:67px">#ClassDescription#</td></tr>	
	
	<cfoutput>
	
	
	
	    <cfset show = "1">
	
	    <cfif statuscode eq "9">
		
		  <!--- hide denied candidates for roster clearer --->
	
		  <cfinvoke component = "Service.Access"  
		   method             = "roster" 
		   owner              = "#URL.Owner#" 
		   functionid         = "#FunctionId#"
		   role               = "'AdminRoster'"
		   returnvariable     = "Access">	
		   
		   <!--- added for mariel --->
		   
		   <cfinvoke component = "Service.Access"  
		   method             = "roster" 
		   owner              = "#URL.Owner#" 
		   functionid         = "#FunctionId#"
		   accesslevel        = "0"
		   role               = "'RosterClear'"
		   returnvariable     = "AccessRead">	
			
		   <cfif Access eq "NONE" and AccessRead neq "READ">
		   		<cfset show = "0">
		   </cfif>
		  
		 	   
		<cfelse>
				
			<cfinvoke component   = "Service.Access"  
			   method             = "roster" 
			   owner              = "#URL.Owner#" 
			   functionid         = "#FunctionId#"
			   role               = "'AdminRoster'"
			   returnvariable     = "Access">
			  
			   <cfinvoke component = "Service.Access"  
			   method             = "roster" 
			   owner              = "#URL.Owner#" 
			   functionid         = "#FunctionId#"
			   accesslevel        = "0"
			   role               = "'RosterClear'"
			   returnvariable     = "AccessRead">
		  		  
			<cfif Access eq "NONE" and AccessRead neq "READ">
			
				<cfquery name="RosterStatus" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_StatusCode
					WHERE    Owner  = '#Owner#'
					AND      Id     = 'FUN'
					AND      Status = '#StatusCode#' 
				</cfquery>
				
				<!---
												
				<cfif RosterStatus.ShowRosterSearch eq "0">				
					<cfset show = "0">
				</cfif>
				
				--->
				
				<cfif RosterStatus.RosterAction eq "0">				
					<cfset show = "0">
				</cfif>
			
			</cfif>    
				
		</cfif>  
		
			<cfif show eq "1">
			
			<TR class="labelmedium2 line navigation_row fixlengthlist">
			    <td height="20" align="right"></td>
				<td style="padding-left:9px;padding-right:4px">
				   
				    <cfif operational eq "1">
						<CFIF (Access eq "EDIT" or Access eq "ALL") and (statuscode lte "1" or statuscode eq "9")> 			   
						   <input type="checkbox" style="width:14px;height:14px" name="select" value="'#FunctionId#'">
						   <cfset deny = "1">
						</cfif>
					</cfif>
					
				</td>		
				
				<td>
				<a href="javascript:ShowFunction('#applicantNo#','#functionId#')">
				<cfif AnnouncementTitle neq "">#AnnouncementTitle#<cfelse>#FunctionDescription#</cfif>
				</a>
				<cfif OrganizationCode neq "[ALL]"><font color="gray">: #OrganizationDescription#</cfif>
				</TD>
			    <TD>#GradeDeployment#</TD>
				<td>#mission#</td>
				<TD>
				<cfif DocumentNo neq "">
				<a href="javascript: showdocument('#DocumentNo#')">#ReferenceNo#</a>
				<cfelse>
				<a href="javascript: va('#FunctionId#')">#ReferenceNo#</a>
				</cfif>
				</TD>
				
				<td id="#functionid#" class="labelit">				
				
				<cfif StatusCode eq "9"><font color="D90000"><b></cfif>			
				
				<cfif (statuscode eq "3" or statuscode eq PreRosterStatus.status or statuscode eq "1") 
				     and Parameter.RosterCandidateManual eq "1">
					 
					 <font color="0080FF">					 
													
					<cfif access eq "EDIT" or access eq "ALL">
					
						<cfif statuscode eq "3">
						
							<a href="javascript:ptoken.navigate('../Functions/ApplicantFunctionProcess.cfm?owner=#owner#&applicantno=#applicantNo#&functionid=#functionId#&status=#PreRosterStatus.status#','#functionid#')">#Meaning#</a>
							
							<img src="#SESSION.root#/Images/arrow-down.gif" 
								  align="absmiddle" 
								  style="cursor: pointer;"
								  onclick="ptoken.navigate('../Functions/ApplicantFunctionProcess.cfm?owner=#owner#&applicantno=#applicantNo#&functionid=#functionId#&status=#PreRosterStatus.status#','#functionid#')"
								  alt="Roster Candidate" 
								  border="0">
						  
						<cfelseif statuscode eq PreRosterStatus.status>
						
							<a href="javascript:ptoken.navigate('../Functions/ApplicantFunctionProcess.cfm?owner=#owner#&applicantno=#applicantNo#&functionid=#functionId#&status=3','#functionid#')">#Meaning#</a>
											
							<img src="#SESSION.root#/Images/favorite.gif" 
								  align="absmiddle" 
								  style="cursor: pointer;"
								  onclick="ptoken.navigate('../Functions/ApplicantFunctionProcess.cfm?owner=#owner#&applicantno=#applicantNo#&functionid=#functionId#&status=3','#functionid#')"
								  alt="Roster Candidate" 
								  border="0">
					
						</cfif>	 
						
					<cfelse>
					
						#Meaning#	 
					
					</cfif>
				
				<cfelse>
				
					#Meaning#
				
				</cfif>
				
				</td>
				<td><cfif Functiondate eq ''>---<cfelse>#DateFormat(FunctionDate, CLIENT.DateFormatShow)#</cfif></td>
				<td>
				<cfif enableStatusDate eq "1">
					<cfif StatusDate eq ''>---<cfelse>#DateFormat(StatusDate, CLIENT.DateFormatShow)#</cfif>
				</cfif>
				</td>	
				<cfif operational eq "0">
				<td bgcolor="e0e0e0">#SubmissionEdition#</td>
				<cfelse>
				<td>#SubmissionEdition#</td>
				</cfif>
				
				<td>#Source#</td>
				<td style="padding-right:3px">
				
				  <cfif Access eq "EDIT" or Access eq "ALL">
				
					  <cfquery name="FunctionTopic" 
						 datasource="AppsSelection" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     FunctionOrganizationTopic FO LEFT OUTER JOIN ApplicantFunctionTopic A
						     ON   FO.FunctionId = A.FunctionId  AND FO.TopicId = A.TopicId
					        AND   A.ApplicantNo = '#ApplicantNo#' 
						    AND   A.FunctionId  = '#FunctionId#' 
						 WHERE    FO.FunctionId = '#FunctionId#'
						 ORDER BY Parent, TopicOrder
						</cfquery>
						
						<cfif FunctionTopic.recordcount gte "1">
										
						<img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
							id="q#currentRow#Exp" border="0" class="show" 
							align="absmiddle" style="cursor: pointer;" 
							onClick="questions('q#currentRow#')">
						
						<img src="#SESSION.root#/Images/icon_collapse.gif" 
							id="q#currentRow#Min" alt="" border="0" 
							align="absmiddle" class="hide" style="cursor: pointer;" 
							onClick="questions('q#currentRow#')">
						
						</cfif>
					
					</cfif>
					
				</td>	
					
			</TR>			
									
			<cfif mailid gte "1">			
											
				<cfquery name="Mail" 
				datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT M.*
					    FROM   ApplicantMail M
						WHERE  M.PersonNo     = '#PersonNo#'
						AND    M.FunctionId   = '#FunctionId#'
						AND    RosterActionNo is NULL 	
						AND    MailStatus != '9'
					</cfquery>
					
				<tr>
					<td height="3" colspan="9" id="h#currentrow#" class="xxhide" style="padding:5px">
					
						<table width="100%"					     
						   class="formpadding"
					       align="center"
					       bordercolor="d0d0d0"
					       bgcolor="FFFFEF">
							<tr><td colspan="2" style="padding:5px" class="labelit">#Mail.MailBody#</td></tr>
						</table>
					</td>
				</tr>							
					
			</cfif>					
					
			<cfif RosterGroupMemo neq "">
				<TR class="labelit"><td></td><td></td>
					<td colspan="8" bgcolor="ffffcf" class="labelit" style="padding-left:10px">#RosterGroupMemo#</td>
				</TR>
			</cfif>					
			
		    <CFIF Access eq "EDIT" or Access eq "ALL"> 
		  		
				<cfif FunctionTopic.recordcount gte "1">
						
					<TR class="hide" id="q#currentRow#">
					
					<td></td><td></td>
					
					<TD colspan="8">
					  <table width="100%" align="center">
					   <tr bgcolor="ECF5FF" class="labelit line">
					    <td width="5%" align="center">No</td>
						<td width="50%"><cf_tl id="Topic/Question"></td>				
						<td width="45%"><cf_tl id="Answer"></td>	
					  </tr>
					  
					  <cfloop query="FunctionTopic">
						  <tr class="labelit line">
						 	<td valign="top"  align="center">#currentrow#</td>
							<td valign="top" style="font-size:15px;padding-right:10px">#TopicPhrase#</td>
							<td class="labelit"><b>
							<cfswitch expression="#TopicValue#">
								<cfcase value=""><font color="silver">N/A,</cfcase>
								<cfcase value="0"><font color="red"> <cf_tl id="No">,</cfcase>
								<cfcase value="1"><font color="0080C0"> <cf_tl id="Yes">,</cfcase>
							</cfswitch>
							</b> #TopicMemo#
							</td>
						  </tr>
					  </cfloop>	
					  </table>
					</TD>
					<td></td>
					</TR>
					<tr><td height="2" class="hide" id="q#currentRow#_2"></td></tr>
				
				</cfif>
			
			</cfif>
						
			<cfif URL.Owner neq "">
		
				<cfquery name="History" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT DISTINCT TOP 8 A.FunctionId, 
				       A.ApplicantNo, 
					   A.RosterActionNo, 
					   A.Status, 
					   A.StatusDate, 
					   A.FunctionJustification,
				       A.RosterGroup, 
					   R.ActionCode, 
					   R.ActionSubmitted, 
					   R.OfficerUserId, 
				       R.OfficerUserLastName, 
					   R.OfficerUserFirstName, 
					   R.ActionEffective, 
					   R1.EnableStatusDate,
				       R.ActionStatus, 
					   R.ActionRemarks, 
					   R.Created, 
					   R1.Meaning,
						  (SELECT count(*) 
						   FROM   ApplicantMail E 
						   WHERE  E.ApplicantNo = A.ApplicantNo 
						   AND    E.FunctionId =  A.FunctionId 
						   AND    E.RosterActionNo = A.RosterActionNo) as MailId,
						   
						  (SELECT count(*) 
						   FROM   ApplicantFunctionActionDecision D 
						   WHERE  D.ApplicantNo = A.ApplicantNo 
						   AND    D.FunctionId =  A.FunctionId 
						   AND    D.RosterActionNo = A.RosterActionNo) as DecisionId 
						   
				FROM   dbo.ApplicantFunctionAction A, 
				       dbo.RosterAction R, 
				       dbo.Ref_StatusCode R1,
					   dbo.Ref_SubmissionEdition
				WHERE  A.ApplicantNo    = '#ApplicantNo#'
			       AND A.FunctionId     = '#FunctionId#'
				   AND R.RosterActionNo = A.RosterActionNo
				   <!---
				   AND A.Status <> '0'
				   --->
				   AND R1.Owner        = '#URL.Owner#'
				   AND R1.Id           = R.ActionCode
				   AND R1.Status       = A.Status
				ORDER BY R.Created DESC
				</cfquery>
				
			   <tr><td colspan="2"></td><td colspan="9">
			   
			   <table width="100%">
			   
			   <cfloop query = "History">			   
			        					 
				     <tr class="labelmedium line">
					 
				     <td width="20%" style="padding-left:20px">#OfficerUserLastName#</td>
				     <td width="17%">#DateFormat(ActionSubmitted, CLIENT.DateFormatShow)# #TimeFormat(ActionSubmitted, "HH:MM:SS")#</TD>
				     <td width="17%" align="left"><cfif status eq "3"><font color="008080"></cfif>#Status# - #Meaning#</TD>
					 <td width="90" align="center">
					 
						 <cfif enableStatusDate eq "1">
						 	<cfif statusDate neq "">#dateformat(StatusDate,CLIENT.DateFormatShow)#<cfelse>--</cfif>
						 </cfif>
						 
					 </TD>
				     <td width="30%" align="left">#ActionRemarks#</TD>
					 <td width="5%">
					 
					     <cfif mailid gte "1">
						 
						  <img src="#SESSION.root#/Images/icon_expand.gif" 
							id="d#CurrentRow#Min" alt="" border="0" 
							align="absmiddle" class="regular" style="cursor: pointer;" 
							onClick="memo('d','#CurrentRow#')">
									
							<img src="#SESSION.root#/Images/icon_collapse.gif" 
							id="d#CurrentRow#Exp" alt="" border="0" 
							align="absmiddle" class="hide" style="cursor: pointer;" 
							onClick="memo('d','#CurrentRow#')">	 
							
						</cfif>
						
					 </td>
				     </tr>
									
					 <cfif FunctionJustification neq "">
						<TR><td></td>
							<td colspan="4" class="labelit" bgcolor="ffffcf">#ParagraphFormat(FunctionJustification)#</td>
						</TR>
					</cfif>
					 				 
					<cfif decisionid gte "1">
					 						
						<cfquery name="Decision" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  R.*
							FROM    ApplicantFunctionActionDecision A INNER JOIN
					                Ref_RosterDecision R ON A.DecisionCode = R.Code
							WHERE 	A.ApplicantNo    = '#ApplicantNo#'  
							   AND  A.FunctionId     = '#FunctionId#'	
							   AND  A.RosterActionNo = '#RosterActionNo#'
						</cfquery>
						
						<cfloop query="decision">
							<tr>
							<td></td>
							<td></td>
							<td bgcolor="f8f8f8" class="labelit" colspan="3">&nbsp;- &nbsp;&nbsp;#DescriptionMemo#</td>
							</tr>
						</cfloop>
					
					</cfif>					
																	
					<cfif mailid gte "1">
								
						<cfquery name="Mail" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT M.*
						    FROM   ApplicantMail M
							WHERE  M.ApplicantNo  = '#ApplicantNo#'
							AND    M.FunctionId   = '#FunctionId#'
							AND    RosterActionNo = '#RosterActionNo#' 	
						</cfquery>
						
						<tr><td height="3" colspan="5" id="d#currentrow#" class="hide" style="padding:3px">
												
							<table width="100%"
						       border="1"						      
							   class="formpadding"
						       align="center"
						       bordercolor="d0d0d0"
						       bgcolor="FFFFEF">
								<tr><td colspan="2" style="padding:5px" class="labelmedium">#Mail.MailSubject#</td></tr>
								<tr><td colspan="2"  class="labelit" style="padding:7px">#rtrim(Mail.MailBody)#</td></tr>
								</tr>
							</table>
							</td>
						</tr>							
					
					</cfif>			
								
				</cfloop>
				</table>
				</tr>	    
		   </cfif>
			  	   
		</cfif>
		
		</cfoutput>
		   
	</CFOUTPUT>
	
		<cfinvoke component="Service.Access"  
		   method="roster" 
		   owner="" 
		   role="'AdminRoster'"
		   returnvariable="Access">	
		   
		 <cfoutput> 
		   
		<script>
		 	   
			function st(status,row) {
			    ColdFusion.navigate('#SESSION.root#/Roster/RosterSpecial/RosterProcess/ApplicationFunctionEditReason.cfm?status='+status+'&owner=#url.Owner#','reason')			
			}
					
			function hr(itm,fld){		
			 
			     while (itm.tagName!="TR") {
				    itm=itm.parentElement;
				 }
			  			 	 		 	
				 if (fld != false){
					 itm.className = "highLight2";
				 }else{				
				     itm.className = "regular";		
				 }
			  }
	
		</script>   
		
		</cfoutput> 
	
		<cfif deny eq "1" and (Access eq "EDIT" or Access eq "ALL")>
		
			<tr><td height="8"></td></tr>
			<tr><td height="1" colspan="11">
				<table width="100%" align="center">
				<tr><td>
				 <cf_tl id="Roster decision" var="1">
				 <cf_DecisionBlock form="result" title="#lt_text#" 
				    OKscript = "st('1','1')" 
					OK       = "Initially clear" 
					CancelScript="st('9','1')"
					cancel="false"> 
				</td></tr> 
				</table> 
			</td></tr>
			
			<tr><td colspan="11">
			    <cf_securediv id="reason" bind="url:#SESSION.root#/Roster/RosterSpecial/RosterProcess/ApplicationFunctionEditReason.cfm?status=1&owner=#url.Owner#">			
			</td></tr>
		
		</cfif>
	
	</table>
		
</td>
</table>

<cfset ajaxonload("doHighlight")>

</cfform>


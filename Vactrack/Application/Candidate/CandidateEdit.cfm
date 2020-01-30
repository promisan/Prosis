
<!--- provision for UN only --->

<cfquery name="DocParameter" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Document
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<!--- coexist new and old track --->
<cfif Doc.EntityClass eq "">
   redirecting...
   <cflocation url="#SESSION.root#/Vacancy/Application/DocumentCandidateEdit.cfm?ID=#URL.ID#&ID1=#URL.ID1#" addtoken="No">
</cfif>

<!--- business rules 

1. Candidate with status NOT 2s, 3 or 9 will not be shown in this screen!
2. check for missing candidates
3.
--->

<cfquery name="Check1" 
 datasource="appsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT count(*) as Candidates
	 FROM   DocumentCandidate
	 WHERE  DocumentNo  = '#URL.ID#' 
	 AND    Status IN ('2s','3')
</cfquery>

<cfquery name="Check2" 
 datasource="appsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT COUNT(*) as Posts
 FROM DocumentPost
 WHERE  DocumentNo  = '#URL.ID#' 
</cfquery>

<cfif Check1.Candidates lt Check2.Posts>

	<cfquery name="LastStep" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT TOP 1 O.ObjectId, max(ActionFlowOrder) as ActionFlowOrder
	 FROM   Organization.dbo.OrganizationObject O, 
	        Organization.dbo.OrganizationObjectAction OA
	 WHERE  O.ObjectKeyValue1 = '#URL.ID#' 
	 AND    O.ObjectId = OA.ObjectId 
	 AND    O.Operational  = 1
	 AND    O.EntityCode = 'VacDocument' 
	 GROUP BY O.ObjectId
	</cfquery>
		
	<cfquery name="Update" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE Organization.dbo.OrganizationObjectAction
	 SET    ActionStatus = '0',
	        TriggerActionType = 'Detail'
	 WHERE  ObjectId        = '#LastStep.ObjectId#'
	 AND    ActionFlowOrder = '#LastStep.ActionFlowOrder#' 
	</cfquery>
			
	<cfoutput>
	<script language="JavaScript">
		 window.status = "Alert: This track requires #Check2.Posts-Check1.Candidates# more candidate(s) to be initiated."
	</script>
	</cfoutput>

</cfif>

<!--- 25/3/2009 do not allow accessing the screen if the candidate has a record but the parent track is still open --->

<cfif check2.Posts eq "1">

	<cfquery name="LastStep" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT TOP 1 *
	 FROM   Organization.dbo.OrganizationObject O, 
	        Organization.dbo.OrganizationObjectAction OA
	 WHERE  O.ObjectKeyValue1 = '#URL.ID#' 
	 AND    O.ObjectId = OA.ObjectId 
	 AND    O.Operational  = 1
	 AND    O.EntityCode = 'VacDocument' 
	 ORDER BY ActionFlowOrder DESC
	</cfquery>
	
	<cfif LastStep.actionStatus eq "0">
		<cf_message message="Problem, the track has to be forwarded before you can process the candidate" return="close">
		<cfabort>
	</cfif>

</cfif>

<cfquery name="GetCandidateStatus" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DC.*, b.IndexNo
    FROM DocumentCandidate DC left outer join Applicant.dbo.Applicant b
		on DC.PersonNo = b.PersonNo
	WHERE DC.PersonNo = '#URL.ID1#'
	AND DC.DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="GetTravel" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM stTravel
	WHERE PersonNo   = '#URL.ID1#'
	AND   DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="GetReassignment" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM stReassignment
	WHERE PersonNo   = '#URL.ID1#'
	AND   DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Document
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<!--- coexist new and old track --->
<cfif GetCandidateStatus.EntityClass eq "" and Doc.EntityClass eq "">
   
   No longer supported
   <cfabort>
   redirecting...
   <cflocation url="#SESSION.root#/Vacancy/Application/DocumentCandidateEdit.cfm?ID=#URL.ID#&ID1=#URL.ID1#" addtoken="No">
</cfif>

<cfquery name="Parameter" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
	WHERE Identifier = 'A'
</cfquery>

<cfquery name="Position" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Employee.dbo.Position
	WHERE PositionNo = '#Doc.PositionNo#'
</cfquery>

<cf_dialogStaffing>

<cfinclude template="../Document/Dialog.cfm">
<cfparam name="URL.IDArea" default="All">
	
<cfquery name="GetPost" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT D.PositionNo,
	       P.SourcePostNumber, 
		   P.PostType
    FROM   DocumentPost D, Employee.dbo.Position P
	WHERE  DocumentNo = '#URL.ID#'
	AND    D.PositionNo = P.PositionNo 
</cfquery>

<cfinvoke component="Service.Access"  
	method="VacancyTree"  
	mission="#Doc.Mission#" 
	PostType="#GetPost.PostType#"
	returnvariable="accessheader">

<cfquery name="GetCandidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Applicant
	WHERE PersonNo = '#URL.ID1#' 
</cfquery>

<cfquery name="GetClass" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_EntityClass
	WHERE EntityCode = 'VacCandidate'
	AND EntityClass = '#GetCandidateStatus.EntityClass#'
</cfquery>

<cfquery name="GetRelease" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM stReleaseRequest R, stParentOffice S
    WHERE DocumentNo = '#URL.ID#'
	AND  PersonNo    = '#URL.ID1#'
</cfquery>

<cf_screentop title = "#URL.ID#: #GetCandidate.FirstName# #GetCandidate.LastName#"
   label          = "#URL.ID#: <b>#GetCandidate.FirstName# #GetCandidate.LastName#</b>" 
   height        = "100%" 
   layout        = "webapp"
   banner        = "blue" 
   bannerforce   = "Yes"
   jquery         ="Yes"
   systemmodule  = "Vacancy"
   functionclass = "Window"
   functionName  = "Candidate track"    
   band          = "no"
   line          = "no"   
   flush         = "Yes" 
   scroll        = "no">
   
   <!--- icon          = "person2.png"  --->

<cfset submit = "0">

<cfajaximport tags="cfwindow">

<cfoutput>

<script>
	
	function closing() {
	
	    window.close();
	    opener.location.reload()
		
	}
	
	function ask() {
	
		if (confirm("Do you want to submit the updated information ?"))	{	
		return true 	
		}
		return false	
		
	}	
	
	function arrival() {		   
		try { ColdFusion.Window.destroy('myarrival',true) } catch(e) {}
		ColdFusion.Window.create('myarrival', 'On boarding', '',{x:100,y:100,height:document.body.clientHeight-40,width:document.body.clientWidth-40,modal:true,resizable:false,center:true})    					
		ColdFusion.navigate('#SESSION.root#/Staffing/Application/Position/Lookup/PositionTrack.cfm?Source=vac&mission=#Doc.Mission#&mandateno=0000&applicantno=#URL.ID1#&personno=&recordid=#URL.ID#&documentno=#URL.ID#','myarrival') 	
	}
	
	function arrivalrefresh() {	
	    ColdFusion.navigate('CandidateWorkflow.cfm?id=#url.id#&id1=#url.id1#&ajaxid=#getCandidateStatus.CandidateId#','#getCandidateStatus.CandidateId#');		
	}		
	
	function withdraw() {
	
		if (confirm("Do you want to withdraw this candidate ?")) {
			ptoken.location('CandidateWithdraw.cfm?ID=#URL.ID#&ID1=#URL.ID1#')
		}	
		return false	
	}	
	
	function revoke() {
	
		if (confirm("Do you want to revoke the current track and define this again ?")) {
			ptoken.location('CandidateRevokeTrack.cfm?ID=#URL.ID#&ID1=#URL.ID1#')
		}	
		return false	
	}	
	
	function note() {
	
	 	w = #CLIENT.width# - 100;
		h = #CLIENT.height# - 160;
		ptoken.open("#SESSION.root#/Vactrack/Application/Candidate/CandidateInterview.cfm?DocumentNo=#URL.ID#&PersonNo=#URL.ID1#&ActionCode=view", "_blank", "left=30, top=30, width=" +w+ ", height=" +h+ ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");	
		
	}

</script>

</cfoutput>

<cf_divscroll>

<cfform action="CandidateEditSubmit.cfm" 
   method="POST" 
   name="candidateedit">

<input type="hidden" name="AreaSelect" value="#URL.IDArea#">

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

  <tr class="hide"><td id="result"></td></tr>
  
  <cfoutput>
  
  <tr class="line">
    <td style="height:43px;font-size:27px;font-weight:200" align="left" class="labellarge">
	    <a href="javascript:showdocument('#URL.ID#','')"><font color="0080C0">#Doc.Mission#</font></a> / #Doc.PostGrade#</b>
	</td>
	<td align="right" class="labelmedium" style="height;30px;padding-top:3px">
	
		<cfif GetCandidateStatus.Status eq "2s">
		    <cfif AccessHeader eq "EDIT" or AccessHeader eq "ALL">
		      <input class="button10g" type="button" name="Revoke" value="Withdraw Candidate" id="Revoke" style="width:212;height:30;font-size:16px" onClick="withdraw()">
			</cfif>  
		</cfif>		
			
    </td>
			
  </tr> 
    
  </cfoutput>
  
  <tr>
    <td style="height:30;padding-left:2px;font-weight:200" 
	     colspan="1" align="left" class="labellarge">
		
	<cfif Doc.Status eq "9">
	
		<b><font color="FF0000"><cf_tl id="Document cancelled"></font></b>	
	
	<cfelse>
		   		
		<cfif GetCandidateStatus.Status eq "2s">			
	
		    <table cellspacing="0" cellpadding="0">
		   
		     <tr><td class="labellarge" style="font-weight:200">	
			
			<cfoutput>#GetClass.EntityClassName#</cfoutput>
			
			</td>
			
			<td style="padding-left:4px">
			
			<cfif AccessHeader eq "EDIT" or AccessHeader eq "ALL">
			
				<cfif GetCandidateStatus.Status eq "2s">
				  
		        	<button name="RevokeTrack"
				        id="RevokeTrack"
				        value="Reset Candidate track"
				        type="button"
						class="button10g"				       
				        onClick="revoke()">	
					
					<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/position_obsolete.gif" 
					 alt="Revoke track: <cfoutput>#GetClass.EntityClassName#</cfoutput>" 
					 width="16" height="16" align="absmiddle" border="0">
					 
					 </button>
					
				</cfif>	
			
			</cfif>
									
			</td></tr>
			</table>	
			
		<cfelseif GetCandidateStatus.Status eq "3">		
			<cf_tl id="Completed"> : <cfoutput><b>#GetClass.EntityClassName#</cfoutput>			
		<cfelseif GetCandidateStatus.Status eq "6">					
			<cf_tl id="On hold">			
		<cfelseif GetCandidateStatus.Status eq "9">					
			<b><font color="FF0000"><cf_tl id="Candidate withdrawn"></font></b>		   						
		<cfelse>		
			<cf_tl id="In process">			
		</cfif> 
					
	</cfif>	
		
	</td>
			
	<td align="right" style="padding-right:20px">
	
	<cfif GetCandidateStatus.TsInterviewStart neq "">
	
	<cfquery name="Check" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
	    FROM   DocumentCandidateInterview
		WHERE  DocumentNo = '#URL.ID#'
		AND    PersonNo = '#URL.ID1#'
		ORDER  By Created DESC
	</cfquery>
	
	     <cfoutput>
		
	     <img src="#SESSION.root#/Images/annotation.gif" alt="See interview notes" 
			name="note" border="0" class="regular" 
			onMouseOver="document.note.src='#SESSION.root#/Images/button.jpg'" 
			onMouseOut="document.note.src='#SESSION.root#/Images/annotation.gif'"
			align="absmiddle" style="cursor: pointer;">&nbsp;
			<a href="javascript:note()"><cf_tl id="Interview notes"></a>
			 
		 </cfoutput>				 
					
	<cfelse>
		
	</cfif>
					
	</td>

  </tr> 	 
   
  <tr><td colspan="2">
    
  <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
     
  <tr>
  
    <td width="100%" colspan="2">
		
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
	
	    <tr style="border-top:1px solid silver" class="line labelmedium">
	
		<cfoutput>					
			<input type="hidden" name="mission"    value="#Doc.Mission#">
			<input type="hidden" name="documentno" value="#Doc.DocumentNo#">
			<input type="hidden" name="postgrade"  value="#Doc.PostGrade#">		
     	</cfoutput>
		
        <!--- Field: Unit --->
			
		<td height="15" style="min-width:100;padding-left:4px;background-color:f1f1f1;color:gray;border-right:1px solid silver"><cf_tl id="Name">:</b></td>
		<td style="padding-left:4px;min-width:200px">
	    	<cfoutput>
	    	<A HREF ="javascript:ShowCandidate('#getCandidate.PersonNo#')">#getCandidate.FirstName# #getCandidate.LastName#</a>		
	    	    <input type="hidden" name="PersonNo" value="#getCandidate.PersonNo#" size="8" maxlength="8" readonly class="disabled">	
			 </cfoutput>
		</td>
		
	    <td height="15" style="min-width:100;color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Nationality">:</b></td>
		<td style="padding-left:3px">
		  	<cfoutput>
	    	  #getCandidate.Nationality#
			 </cfoutput>
		</td>
			
	    <td height="15" style="min-width:100;color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="DOB">:</b></td>
		<td style="padding-left:3px">
		      <cfoutput>#DateFormat(getCandidate.DOB,CLIENT.DateFormatShow)#</cfoutput>
		</td>
		
		<td height="15" style="min-width:100;color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Post">:</b></td>
		<td style="padding-left:3px">
			
		   	<cfif GetPost.recordcount eq "1">
			
			 <cfoutput>
				 <cfif GetPost.SourcePostNumber eq ""><cf_tl id="Internal"><cfelse>#GetPost.SourcePostNumber#</cfif>
				 <input type="hidden" name="postnumber" value="#GetPost.SourcePostNumber#">
	     	 </cfoutput>
			 	
			<cfelse>
					
		 	    <select name="PostNumber">				
				    <cfoutput query="GetPost">							
			    		<option value="#SourcePostNumber#" <cfif getCandidateStatus.PostNumber is SourcePostNumber>selected</cfif>>
			    		<cfif SourcePostNumber eq "">Internal<cfelse>#SourcePostNumber#</cfif>
						</option>					
					</cfoutput>
			    </select>			
			
			</cfif>
					
		</td>
		 				
		<td height="15" style="min-width:100;color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Travel Authorization">:</td>
	    <td style="padding-left:3px">
		
		    <cfif GetTravel.TANumber eq "">
			   Not determined
			<cfelse>
			  <cfoutput>#GetTravel.TANumber#</cfoutput>
			</cfif>
			
		</td>
	
	</tr>	 
	
	<cfquery name="GetEmployee" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
	maxrows=1 
    password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    Person
		WHERE   PersonNo = '#getCandidate.EmployeeNo#'
    </cfquery>
		
	<cfif GetEmployee.recordcount eq "0">
	
		<cfquery name="GetEmployee" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
		maxrows=1 
	    password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    Person
		WHERE   PersonNo = '#getCandidate.EmployeeNo#'
	    </cfquery>
	
	<cfelse>
	
		<cfquery name="qUpdate_Employee" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#"
	    password="#SESSION.dbpw#">
		    UPDATE Applicant
			SET    IndexNo = '#getEmployee.IndexNo#'
			WHERE  PersonNo = '#URL.ID1#'
	    </cfquery>
		
	</cfif>
	
	<!--- mapped record --->
		
	<cfif GetEmployee.recordcount eq "1" and GetEmployee.IndexNo neq "">
							
		<tr style="border-top:1px solid gray" class="line labelmedium">
					
	    <td style="width:10%;color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cfoutput>#client.IndexNoName#:</cfoutput></td>
		
		<td style="padding-left:3px">				
		    <cfoutput><a href="javascript:EditPerson('#GetEmployee.IndexNo#')"><u>#GetEmployee.IndexNo#</a></cfoutput>
		</td>
				
			<cfoutput>
				<input type="hidden"  name="indexno" value="#GetEmployee.IndexNo#" size="10" maxlength="20" readonly>
			</cfoutput>
		
			 <cfquery name="Level" 
	          datasource="AppsEmployee" 
	          maxrows=1 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
		          SELECT *
		      	  FROM  PersonContract
		   	      WHERE PersonNo = '#getEmployee.PersonNo#' 
				  ORDER BY DateEffective DESC
			  </cfquery>
		
		<td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Grade">:</b></td>
		<td style="padding-left:3px">
		      <cfoutput>#Level.ContractLevel#<cfif Level.ContractStep neq "">/#Level.ContractStep#</cfif></cfoutput>
		</td>
		
		<cfif getRelease.ParentOffice neq "">
		
	    <td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Parent Office">:</b></td>
	    <td style="padding-left:3px">
		      <cfoutput>#getRelease.ParentOffice# #getRelease.ParentLocation#</cfoutput>
	    </td>
	
	<cfelse>
	
	 <td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Status">:</td>
	 
		<cfquery name="Assess" 
			datasource="appsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM  ApplicantAssessment
			WHERE PersonNo = '#URL.ID1#' 
			AND   Owner = '#Doc.Owner#'
		</cfquery>
				  			   
	   <cfquery name="Status" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		    FROM Ref_PersonStatus
		    WHERE Code = '#Assess.PersonStatus#' 
		</cfquery>
		
	   <cfoutput>
	   <td  style="color:gray;padding-left:4px;padding-left:3px;border-right:1px solid silver" align="center" bgcolor="#Status.InterfaceColor#">
	   	<cfif Status.InterfaceColor neq "Transparent"><font color="FFFFFF"></cfif>#Status.Description#
	   </td>
	   </cfoutput>
	
	</cfif>
	
	<cfif GetReassignment.Mission neq "">
	
		<td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Reassigned">:</b></td>
		<td style="padding-left:3px">
		
		<cfif GetReassignment.Mission neq "">
		
			<cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">
				<cfoutput>#GetReassignment.Mission#</cfoutput>
			<cfelse>		    
			    <cfoutput>#GetReassignment.Mission#</cfoutput>					
			</cfif>	
			
		<cfelse>
		
			<cf_tl id="N/A">
			
		</cfif>	
		
		</td>
	  
		<td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Through">:</b></td>
		
    	<TD style="padding-left:3px">
		
			<cfif GetReassignment.RequestThrough neq "">		
				<cfoutput>#GetReassignment.RequestThrough#</cfoutput>		
			<cfelse>
				<cfoutput>#GetRelease.RequestThrough#</cfoutput>
			</cfif>
		
		</TD>
		
	<cfelse>
	
		<td colspan="4"></td>	
		
	</cfif>	
	</tr>
		
	<!--- ----------------- --->
	<!--- not mapped record --->
	<!--- ----------------- --->
	
	<cfelse>
									
		<tr class="line labelmedium">
		
		<td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cfoutput>#client.IndexNoName#:</cfoutput></b></td>
		<td colspan="5" style="padding-left:3px">
		
		<cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">
		   
			<cfoutput>#GetCandidateStatus.IndexNo#</cfoutput>
			
		<cfelse>
		
			<cfoutput>
		
			<script>	
				
				function LocatePerson(last,dob,nat,pers) {
							
					try { ColdFusion.Window.destroy('myperson',true) } catch(e) {}
					ColdFusion.Window.create('myperson', 'Staff', '',{x:100,y:100,height:800,width:800,modal:true,resizable:false,center:true})    
					ColdFusion.navigate('#session.root#/Vactrack/Application/Candidate/CandidateIndexNo.cfm?mission=#doc.mission#&personno='+pers+'&ID2=' + last + '&ID3=' + dob + '&ID4=' + nat,'myperson') 		
				 
				}
				
				function applyperson(ind,emp,pers) {
					document.getElementById("indexno").value = ind
					ColdFusion.navigate('CandidateEditEmployee.cfm?indexNo='+ind+'&employeeno='+emp+'&PersonNo='+pers,'result')		
					ColdFusion.Window.destroy('myperson',true) 		
				}
	
			</script>
			
			</cfoutput>	
						
			<!--- Query returning search results --->
			<cfquery name="Parameter" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
			    FROM Ref_ParameterMission
				WHERE Mission = '#doc.mission#'	
			</cfquery>
		
		 	<cfoutput> 
	        
				<table style="border:0px solid silver" cellspacing="0" cellpadding="0">
				<tr>
				<td>

					<input type="text" 
						id="indexno" 
						name="indexno" 
						style="border:0px;text-align:center" 
						class="labelmedium" 
						value="#GetCandidate.IndexNo#" 
						size="9" 
						class="regular3" 
						maxlength="10" readonly>
					
	      	    </td>				
				<cfset nme = replace(GetCandidate.LastName,"'","|")>
			    <td align="right" 
				  style="cursor:pointer;padding-right:3px" 
				  onClick="LocatePerson('#nme#','#Dateformat(GetCandidate.DOB, CLIENT.DateFormatShow)#','#GetCandidate.Nationality#','#GetCandidate.PersonNo#')">				  
					<img src="#SESSION.root#/Images/search.png" alt="Associate employee record" height="22" width="24" border="0">													
				</td>
				</tr>
				</table>
	      	
			</cfoutput>
	
		</cfif>		
	
	    </td>
	
		<td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Reassigned from">:</td>
		<td style="padding-left:3px">
		
		<cfoutput>
		
		<cfif GetReassignment.Mission neq "">
		
			<cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">
				#GetReassignment.Mission# 
			<cfelse>
			    #GetReassignment.Mission# 
				<!---
				<input type="text" name="ReassignmentFrom" value="#GetCandidateStatus.ReassignmentFrom#" size="15" maxlength="20" class="regular">
				--->
			</cfif>
		
		<cfelse>
		
			<cf_tl id="N/A">
			
		</cfif>
		
		</cfoutput>
			
		</td>
		
			<td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Through">:</b></td>
	    	<TD style="padding-left:3px">
			
			<cfif GetReassignment.RequestThrough neq "">
			
			<cfoutput>#GetReassignment.RequestThrough#</cfoutput>
			
			<cfelse>
			
			<cfoutput>#GetRelease.RequestThrough#</cfoutput>
					
			</cfif>			
			
			</TD>
			
		</tr>
	
		
	</cfif>
				
	<cfset PersonNo = URL.ID1>
	
	<tr class="labelmedium" style="border-bottom:1px solid silver">
	<td colspan="12">
	
	<cf_DocumentCandidateReview PersonNo="#URL.ID1#" Owner="#Doc.Owner#" DocumentNo="#Doc.DocumentNo#"></td></tr>
	
	<cfif GetTravel.ArrivalDateTime neq "">
	
	    <tr><td height="3" colspan="12"></td></tr>
	    <tr><td colspan="12" bgcolor="f1f1f1"></td></tr>	
		<tr><td height="2" colspan="12"></td></tr>
		<tr><td colspan="12">
			<cfinclude template="../Travel/DocumentView.cfm">
		</td></tr>	
		<tr><td height="3" colspan="12"></td></tr>
	    <tr><td colspan="12" bgcolor="f1f1f1"></td></tr>	
		<tr><td height="2" colspan="12"></td></tr>
			
	</cfif>
   	
	<tr>
	<td valign="top" class="labelit" style="padding-top:3px;padding-left:3px"><cf_tl id="Group">:</td>
	<td colspan="3" valign="top" class="labelmedium" style="padding-top:3px">
	
	<cfquery name="Group" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		SELECT F.*
		FROM   ApplicantGroup S, 
		       Ref_Group F
		WHERE  S.PersonNo  = '#URL.ID1#'
		 AND   S.GroupCode = F.GroupCode
		 AND   F.GroupDomain = 'Candidate'
	</cfquery>
	
	<cfif group.recordcount eq "0">
	
	n/a 
	
	<cfelse>
	
	<table>
	    <cfoutput query="Group"><tr><td>#Description#</td></tr></cfoutput>
	</table>
	
	</cfif>
		
	</td>
	<td height="15" valign="top" style="padding-top:4px;padding-right:4px" class="labelit"><cf_tl id="Memo">:</b></td>
    <TD colspan="7" style="padding-bottom:4px;padding-top:4px;padding-right:10px">
	
	<cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">
	
	    <cfoutput>
			#GetCandidateStatus.Remarks# 
			<input type="hidden" name="Remarks" value="#GetCandidateStatus.Remarks#">
		</cfoutput>
		
	<cfelse>		
		
		<cfif AccessHeader eq "EDIT" or AccessHeader eq "ALL">
			<textarea 			 
			 rows="2" 
			 name="Remarks" 
			 style="width:95%;padding:5px;background-color:ffffcf;font-size:13px;height:46px"
			 class="regular" 
			 onchange="ColdFusion.navigate('CandidateEditSubmit.cfm','result','','','POST','candidateedit')"><cfoutput>#GetCandidateStatus.Remarks#</cfoutput></textarea>
		<cfelse>
		
		    <cfoutput>
			#GetCandidateStatus.Remarks# 
			<input type="hidden" name="Remarks" value="#GetCandidateStatus.Remarks#">
			</cfoutput>
		</cfif>	
		
	</cfif>	
	</td>
	</tr>
									
	<tr style="border-top:0px solid silver">
		<td height="1" colspan="12"></td>
	</tr>
		
		<cf_actionListingScript>
		<cf_FileLibraryScript>
		
		<cfoutput>
		
			<input type="hidden" 
				   name="workflowlink_#getCandidateStatus.CandidateId#" 
				   id="workflowlink_#getCandidateStatus.CandidateId#" 			   
				   value="CandidateWorkflow.cfm">	
	
			<input type="hidden" 
				   name="workflowcondition_<cfoutput>mybox#getcandidate.Personno#</cfoutput>" 
				   value="?id=#url.id#&id1=#url.id1#&ajaxid=#getCandidateStatus.CandidateId#">						  
				   				  	   	
			<tr><td colspan="12" align="center" id="#getCandidateStatus.CandidateId#">
						
			    <cfset url.ajaxid = "#getCandidateStatus.CandidateId#">
				<cfinclude template="CandidateWorkflow.cfm">
						
			</td></tr>
		
		</cfoutput>		
	
	</table>

</td>
</tr>

</table>

</td>
</tr>

</table>

</CFFORM>

</cf_divscroll>


<cf_screenbottom layout="webapp">
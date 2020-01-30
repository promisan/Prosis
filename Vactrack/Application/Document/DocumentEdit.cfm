<!--- Create Criteria string for query from data entered thru search form --->
 
<!--- business rules enforced
1. Only vactrack with status 0 and no completed candidates (3) can be withdrawn
2. Show warning if No. candidates (2s and 3) exceeds the No. of Positions
3. Prevent that 0 positions are associated to a vactrack
4. Prevent selection of more candidates than the number of positions associated	
5. Check if DocumentPost has valid entries
--->

<cfset candidate = "0">

<cfparam name="URL.ID" default="0">

<cftry>
	
	<cfquery name="insert" 
		datasource="AppsVacancy">
			INSERT INTO DocumentInquiryLog  
				(DocumentNo, 
				 NodeIP, 
				 HostSessionNo, 
				 ActionTimeStamp,
				 FunctionName, 
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES 
			('#URL.ID#',					 
			 '#CGI.Remote_Addr#', 
			 '#CLIENT.sessionNo#', 
			 getDate(),
			 'Track',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
	</cfquery>		

	<cfcatch></cfcatch>

</cftry>

<cf_dialogStaffing>
<cf_dialogPosition>
<cf_calendarScript>

<cfquery name="DocParameter" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfquery name="Doc" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Document
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<!--- coexist new and old track for UN only  --->
<cfif Doc.EntityClass eq "" and Doc.recordcount eq "1">

<table width="94%" align="center" bgcolor="white">
	
	  <tr><td height="10"></td></tr>
	  
	  <tr><td style="font-size:20px"  class="labelmedium" align="center"><font color="FF0000"><cf_tl id="Old tracks are no longer supported"></td></tr>
	  
	</table>
	
  
   <cfabort>
   <!---
   redirecting...
   <cflocation url="#SESSION.root#/Vacancy/Application/DocumentEdit.cfm?ID=#URL.ID#" addtoken="No">
   --->
<cfelse> 
   <cfinclude template="DocumentVerify.cfm">  
</cfif>

<cfif Doc.recordcount eq "0">
	
	<cfquery name="Doc" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Document
		WHERE DocumentNo IN (SELECT DocumentNo 
		                     FROM   Applicant.dbo.FunctionOrganization 
							 WHERE  ReferenceNo = '#URL.ID#')
	</cfquery>

	<cfif Doc.recordcount eq "0">
	
	<cf_screentop title         = "Recruitment request No: #URL.ID#" 
              height        = "100%" 
			  layout        = "webapp"
			  banner        = "gray"	
			  bannerforce   = "Yes"		 
			  systemmodule  = "Vacancy"
			  functionclass = "Window"
			  functionName  = "Recruitment track"
			  band          = "no"
			  line          = "no"
			  busy          = "busy10.gif"
			  jquery        = "Yes"
			  label         = "Track: #url.id#"			 
			  scroll        = "Yes">
	
	<table width="94%" align="center" bgcolor="white" border="0" cellspacing="0" cellpadding="0">
	
	  <tr><td height="30"></td></tr>
	  
	  <tr><td style="font-size:30px" class="labelmedium" align="center"><font color="FF0000"><cf_tl id="Track is not on file"></td></tr>
	  
	</table>
	
	<cfabort>  
	
	</cfif>

</cfif>

<cfquery name="Position" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Position
	WHERE PositionNo = '#Doc.PositionNo#'
</cfquery>

<cfif Position.recordcount eq "0">

	<cfquery name="Check" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 PositionNo 
    	FROM     DocumentPost
		WHERE    PositionNo IN (SELECT PositionNo FROM Employee.dbo.Position)
		AND      DocumentNo = '#Doc.DocumentNo#'
	</cfquery>  
	
	<cfif check.recordcount eq "1">
	
			<cfquery name="Update" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Document    
				SET    PositionNo = '#check.PositionNo#'  
				WHERE  DocumentNo = '#Doc.DocumentNo#'
			</cfquery>
			
			<cfquery name="Position" 
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    	SELECT *
			    FROM   Position
				WHERE  PositionNo = '#Check.PositionNo#'
			</cfquery>	
	
	</cfif>

</cfif>

<cfquery name="Mission" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Mission
	WHERE Mission = '#Doc.Mission#'
</cfquery>

<!--- owner has access to change the track --->

<cfif getAdministrator(Doc.Mission) eq "1" or SESSION.acc eq Doc.OfficerUserid>
  <cfset accessheader = "ALL">
<cfelse>
  <cfset accessheader = "NONE">   
</cfif>

<cfif accessHeader eq "NONE">

	<cfinvoke component= "Service.Access"  
	method             = "VacancyTree"  
	mission            = "#Doc.Mission#" 
	returnvariable     = "accessheader">
	
	<cfif AccessHeader eq "EDIT" or AccessHeader eq "ALL">
	       <cfset accessheader = "ALL">
	</cfif>
	
</cfif>

<cfoutput>

<cfinclude template="Dialog.cfm">

<script>

w = 0
h = 0
if (screen) {
	w = #CLIENT.width# - 60
	h = #CLIENT.height# - 110
}

// TO BE determined if this is still being used 21/9/2015

function review(per,cls) {
		
	try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
	ColdFusion.Window.create('mydialog', 'Receipt', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    
	ColdFusion.navigate('#SESSION.root#/roster/candidate/details/review/TrackReview.cfm?documentno=#url.id#&personno='+per+'&reviewcode='+cls,'mydialog') 		
}

function reviewrefresh(id) {
    ColdFusion.navigate('DocumentCandidateSelect.cfm?id='+id,'selected')
} 

function rostersearch(action,actionid,ajaxid) {
    w = #CLIENT.width# - 90;
    h = #CLIENT.height# - 160;	
	ptoken.open("#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search1ShortList.cfm?mode=vacancy&wActionId="+actionid+"&docno=#URL.ID#&functionno=#Doc.FunctionNo#", "search"+ajaxid, "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes")	
}

function Selected(no,description) {			
    document.getElementById('functionno').value = no
	document.getElementById('functionaltitle').value = description
	ColdFusion.Window.hide('myfunction')
}

function more(bx,act) {

    icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx)
		
	if (act=="show") {
		se.className  = "regular";
		icM.className = "regular";
	    icE.className = "hide";
	} else {
		se.className  = "hide";
	    icM.className = "hide";
	    icE.className = "regular";
	}
}

function details(id) {
	   ptoken.open("#SESSION.root#/Roster/RosterSpecial/CandidateView/FunctionViewLoop.cfm?DocumentNo=#URL.ID#&IDFunction=" + id + "&status=1", id);
	}
	
function EditPost(posno) {
        if (posno != "") {
        w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 130;
		ptoken.open("#SESSION.root#/Staffing/Application/Position/Position/PositionView.cfm?ID=" + posno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
		}
}	
	
function revoke(st) {

	if (confirm("Do you want to withdraw this vacancy track ?")) {
		window.location = "DocumentCancel.cfm?ID=#URL.ID#&Status="+st;
	}
	
	return false
	
}		
	
<!--- here is customer workflow processing --->
	
function clearinit() {
	 ptoken.open("DocumentRoster.cfm?ID=#URL.ID#&status=1", "_blank", "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no");
	}
		
function cleartech() {
	 ptoken.open("DocumentRoster.cfm?ID=#URL.ID#&status=2", "_blank", "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no");
	}	
	
function mark(act) {
	 ptoken.open("../Candidate/CandidateReview.cfm?ID=#URL.ID#&ActionCode="+act+"&status=1", "_blank", "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no");
	}		
	
function interview(act) {
	 ptoken.open("../Candidate/CandidateReview.cfm?ID=#URL.ID#&ActionCode="+act+"&status=2", "_blank", "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no");
	}			
	
function recommend(act)	{
	 ptoken.open("../Candidate/CandidateReview.cfm?ID=#URL.ID#&ActionCode="+act+"&status=3", "_blank", "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no");
	}			

function asspost(vacno,mis,grd)	{
    	
	ColdFusion.Window.create('myassociate', 'Associate', '',{x:100,y:100,height:document.body.clientHeight-120,width:document.body.clientWidth-120,modal:true,center:true})    
	ColdFusion.Window.show('myassociate') 				
	ColdFusion.navigate('AssociateView.cfm?ID=' + vacno + '&ID1=' + mis + '&ID2=' + grd,'myassociate') 			
    }	
	
function reissue(vacno) {
	
	if (confirm("Do you want to reissue this vacancy (operation can not be reversed) ?")) {		
		ptoken.open("DocumentEntryReissue.cfm?ID=" + vacno, "IndexWindow", "width=600, height=400, toolbar=no, scrollbars=yes, resizable=no");		
		}		
		return false
	}

function va(fun) {
		ptoken.open(root + "/Vactrack/Application/Announcement/Announcement.cfm?ID="+fun, "_blank", "width=800, height=600, status=yes,toolbar=yes, scrollbars=yes, resizable=yes");
	}
	
function reinstate(vacno,persno) {

	if (confirm("Do you want to reinstate this person ?")) {
		window.location = "DocumentCandidateReinstateSubmit.cfm?ID=" + vacno + "&ID1=" + persno;
	}	
	return false
	
}	

function personnote(per,act) {  
	w = #CLIENT.width# - 100;
	h = #CLIENT.height# - 160;
	ptoken.open("#SESSION.root#/Vactrack/Application/Candidate/CandidateInterview.cfm?DocumentNo=#URL.ID#&PersonNo="+per+"&ActionCode="+act, "_blank", "left=30, top=30, width=" +w+ ", height=" +h+ ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");	
}

</script>

</cfoutput>

<cfquery name="CheckPost" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM DocumentPost
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="GetPost" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  DocumentPost D, 
	      Employee.dbo.Position P
	WHERE DocumentNo = '#URL.ID#'
	AND   D.PositionNo = P.PositionNo
</cfquery>

<cfquery name="GetCandidate" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM DocumentCandidate
	WHERE DocumentNo = '#URL.ID#'
	AND Status IN ('2s','3') 
	<!---
	AND EntityClass is not NULL
	--->
</cfquery>

<cfquery name="GetCompleted" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT TOP 1 *
    FROM DocumentCandidate
	WHERE DocumentNo = '#URL.ID#'
	AND Status = '3'
</cfquery>

<cfquery name="Grade" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_PostGrade R, Applicant.dbo.Ref_GradeDeployment D
	WHERE    R.PostGrade = D.GradeDeployment
	ORDER BY R.Postorder
</cfquery>

<cf_screentop title         = "Recruitment Track: #URL.ID#" 
              height        = "100%" 
			  layout        = "webapp"
			  banner        = "green"			 
			  systemmodule  = "Vacancy"
			  functionclass = "Window"
			  functionName  = "Recruitment track"
			  band          = "no"
			  line          = "no"
			  busy          = "busy10.gif"
			  jquery        = "Yes"
			  label         = "Recruitment Track: #Doc.DocumentNo#"
			  option        = "#Doc.Mission# / #Doc.PostGrade# </b>owner:<b> #Doc.Owner#</b>"
			  scroll        = "Yes">

<cf_divscroll>
 
<cfform action="DocumentEditSubmit.cfm" method="post" name="documentedit">
 
	<table width="94%" align="center" bgcolor="white" border="0" cellspacing="0" cellpadding="0">
	
	  <tr><td height="10"></td></tr>
	  
	  <cfif ((Doc.Status is "0" or Doc.Status is "9") and AccessHeader eq "ALL") or getAdministrator("*") eq "1">
	  
		  	 <tr><td style="height:48">
			 
				  <table width="100%" border="0" cellspacing="0" align="right" class="formpadding">
				    
				  <tr>
										  
				  <td style="font-size:29px;padding-left:6px;font-weight:200">
				  
				  <cfoutput>
				  
				  <cfif Doc.Status is "9"><font color="FF8080">Cancelled/Withdrawn </b></cfif></font>
				  <cfif Doc.Status is "1"><font color="green">Track Closed on <b>#dateformat(doc.StatusDate,client.dateformatshow)#</b> by <b>#doc.StatusOfficerLastName#</b></cfif></font>
				  <cfif Doc.Status is "0"><font color="gray">Track in Process</b></cfif></font>		
				  
				  </cfoutput>	 
				  
				  </td>			
				  
				  <td class="labellarge" style="font-weight:200">
				  
			        <cfoutput>	
				      <cfif getPost.recordcount lt getCandidate.recordcount><font color="FF0000">PROBLEM:&nbsp;<font></font></cfif>	
					  <cf_tl id="Positions">: <b>#getPost.recordcount#</b> | <cf_tl id="Selected candidates">: <b><cfif getCandidate.recordcount eq "0"><font color="FF0000"></cfif>#getCandidate.recordcount#</b>				 
					</cfoutput>
					
			      </td>
							  
				  <td id="result"></td>
				  	
				  <td align="right" colspan="2" style="border:0px solid silver">
				  
				         <table class="formspacing"><tr>
				  						  
				  		<cfif (Doc.Status is "0")>
					
						    <cfif Accessheader eq "ALL">
							
								<cfif GetCandidate.Recordcount eq "0">
							
								<td>
							    <INPUT type    = "button"
								       style   = "width:140;height:26" 								 
									   value   = "Revoke Track"			
									   class   = "button10g"					  
									   name    = "Status" 
									   onClick = "revoke('9')"> 
									   </td>
								
								</cfif>		 
							  
							</cfif>
						
						<cfelseif Doc.Status is "9">	
											
							<cfif GetCompleted.Recordcount eq "0" and Accessheader eq "ALL">
								<td>
							    <INPUT type="button" style="width:140;height:26" value="Reactivate Track" class="button10g"	name="Status" onClick="revoke('0')"> 
								</td>
								
							</cfif>
						  	   
					   	<cfelse>
						
						    <!--- check candidates with status = 3 --->
							<cfif getPost.recordcount eq GetCompleted.recordcount>						
							   <b><font size="2" color="808080">Closed</b>&nbsp;
							<cfelse>
							   <b><font color="green">Under recruitment</b>  
							</cfif>
					   	
					   </cfif>
					
					   <cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
					     <!--- no button --->
					   <cfelse>
					       <td>
						   <input type="button" style="width:140;height:26" name="Header" class="button10g"	onclick="ColdFusion.navigate('DocumentEditSubmit.cfm','result','','','POST','documentedit');" value="Update">
						   </td>
						</cfif>
									
					<cfoutput>
					
					<cfif (Doc.Status eq "0" and accessheader eq "ALL") or (getAdministrator(Doc.Mission) eq "1" and getPost.recordcount neq GetCompleted.recordcount)>
					
						<cf_tl id="Associate Position" var="ass">
						
						<td>
						
					   	<input style="width:150;height:26" 
							   type="button" 
							   class="button10g"	
							   value="#ass#" 
							   onClick="javascript:asspost('#Doc.documentNo#','#Doc.Mission#','#Doc.PostGrade#')">
							   
							   </td>
							   
				    </cfif>
					
				    </cfoutput>			
					
					</tr></table>
					
					</td>
							
				  </tr>
				   
				  </table>
			</td>
		 </tr>
		 
		 <tr><td class="line"></td></tr>
		 				
		</cfif>
	             
	  <tr>
	    <td width="100%">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		<tr><td colspan="3">
		
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			
				<cfoutput>
			       	<input type="hidden" name="postnumber" value="#Doc.PostNumber#", size="20" maxlength="20" class="disabled" readonly>
					<input type="hidden" name="mission"    value="#Doc.Mission#" size="30" maxlength="30" class="disabled" readonly>
					<input type="hidden" name="documentno" value="#Doc.DocumentNo#">
		    	</cfoutput>
			
			<!--- Field: Unit --->
		 
			<tr><td height="1" colspan="4"></td></tr>
			<tr class="labelmedium2">
		    <td>Unit:</td>
			<td>
			
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
				<cfoutput><b>#Doc.OrganizationUnit#
				<input type="hidden" name="organizationunit" value="#Doc.OrganizationUnit#">
				</cfoutput>
			<cfelse>
			   	<cfoutput>
		    	 <input type="text" name="organizationunit" value="#Doc.OrganizationUnit#" size="50" maxlength="80" class="regularxl">
			    </cfoutput>
			</cfif>	
			</td>
			
			<TD><cf_tl id="Due date">:</td>
		    <td>
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
				<cfoutput><b>#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#
				<input type="hidden" name="Duedate" value="#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#">
				</cfoutput>
			<cfelse>
				<cfset end = DateAdd("m",  2,  now())> 			
				<cf_intelliCalendarDate9
					FieldName="DueDate" 
					class="regularxl"
					DateValidEnd="#Dateformat(now()+100, 'YYYYMMDD')#"
					Default="#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#">	
			</cfif>	
					  	   
			</td>	
			</TR>			
						
			<TR class="labelmedium2">
		    <td><cf_tl id="Functional title">:</td>
		    <TD>
				<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
					<cfoutput><b>#Doc.FunctionalTitle#
					<input type="hidden" name="functionno"      value="#Doc.FunctionNo#">
					<input type="hidden" name="functionaltitle" value="#Doc.FunctionalTitle#">
					</cfoutput>
				<cfelse>
			       <cfoutput>
				   <table cellspacing="0" cellpadding="0">
				   <tr class="labelmedium2">
				   <td> 
				   <input type="text" name="functionaltitle" id="functionaltitle" value="#Doc.FunctionalTitle#" class="regularxl" size="50" maxlength="60" readonly> 
	               </td>
				   <td style="padding-left:2px">						   			      
				   
				    <button name="btnFunction"
				        type="button"			      
				        style="height:23;width:20"
				        onClick="selectfunction('webdialog','functionno','functionaltitle','#Mission.MissionOwner#','','','')"> 
															  
					</button>	
												    
				    <input type="hidden" name="functionno" id="functionno" value="#Doc.FunctionNo#">		
					
					</td></tr>
					</table>
				   </cfoutput>
				</cfif>   
		  	</TD>
		    <td><cf_tl id="Grade">:</td>
			<td>
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
				<cfoutput><b>#Doc.PostGrade# (#Doc.GradeDeployment#)
				<input type="hidden" name="postgrade" value="#Doc.PostGrade#">
				</cfoutput>
			<cfelse>
			   <select name="PostGrade" required="Yes" class="regularxl">
				    <cfoutput query="Grade">
						<option value="#PostGrade#" 
							<cfif Doc.PostGrade is PostGrade>selected</cfif>>#Description#
						</option>
					</cfoutput>
			    </select>			
			</cfif>	
			</td>
			</TR>	
							
			<TR class="labelmedium2">
			
		    <td valign="top" style="padding-top:5px"><cf_tl id="Remarks">:</td>
			<TD colspan="3">
			     <cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
						<cfoutput><b><cfif Doc.Remarks eq "">n/a<cfelse>#Doc.remarks#</cfif>
							<input type="hidden" name="remarks" value="#Doc.Remarks#">					
						</cfoutput>
				<cfelse>
					<textarea style="padding:4px;font-size:13px;width:100%;height:40" 				          
							  class="regular" 
							  maxlength="250"
							  onkeyup="return ismaxlength(this)"	
							  name="Remarks"><cfoutput>#Doc.Remarks#</cfoutput></textarea>
				</cfif>	
			</TD>
						
			<cfif Doc.FunctionId neq "">
							
				<cfquery name="JO" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   FunctionOrganization
					WHERE  FunctionId = '#Doc.FunctionId#' 
				</cfquery>
				
				<cfif JO.Recordcount eq "1">
				
						<!--- to be replace with new VA document --->
						<cfquery name="VAtext" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT TOP 1 *
						    FROM   stAnnouncement
							WHERE  VacancyNo = '#JO.ReferenceNo#'
						</cfquery>
						
					 <tr>	
				
					 <td class="labelmedium"><cf_tl id="Associated Bucket">:</td>
				     <TD> 
					 <table cellspacing="0" cellpadding="0"><tr><td width="200" align="center" style="border: 1px solid silver;" class="labelmedium">
					 				 
					  <cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
			
						<cfif VAtext.VacancyNo neq "">
							<cfoutput><b><A href="javascript:va('#JO.FunctionId#');">#JO.ReferenceNo#</font></a></cfoutput>
						</cfif>
						
					  <cfelse>
					  			   
							<cfoutput>
							
								<cfif JO.recordcount neq "0">
									<A href="javascript:va('#JO.FunctionId#');">#JO.ReferenceNo#</font></a>
								<cfelse>
								   Undefined
								</cfif>
								</td>
								<td style="padding-left:2px">
								
							 <button name="btnFunction"  type="button" style="width:30px;height:26" onClick="details('#JO.FunctionId#')"> 						
								
							  </td>
						    </cfoutput>
							 					 
							<!--- to be replace with new VA document --->
							<cfquery name="VAtext" 
							datasource="AppsVacancy" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT TOP 1 *
							    FROM stAnnouncement
								WHERE VacancyNo = '#JO.ReferenceNo#'
							</cfquery>
										     											
					   </cfif>	
					   
					   </td></tr>
					  </table>
				   	  </TD>
					  
				  </cfif>
				  	  
			</cfif> 
			</TR>
			
			<tr><td height="4"></td></tr>
			<tr><td colspan="4" class="line"></td></tr>
			<tr><td height="1"></td></tr>
			
			</table>
		
		</td>
		
		</tr>
					  	
		
	<tr><td colspan="3">
		<cfinclude template="DocumentEditPost.cfm">
	</td></tr>	
	
	<tr><td colspan="3" id="selectedme">
		<cfdiv bind="url:DocumentCandidateSelect.cfm?id=#url.id#">	
	</td></tr>	
	
	<cf_actionListingScript>
	<cf_FileLibraryScript>
	
	<cfoutput>
		
	<input type="hidden" 
		   name="workflowlink_#Doc.DocumentNo#" 
		   id="workflowlink_#Doc.DocumentNo#" 	   	  
		   value="DocumentWorkflow.cfm">	
		   
	<input id="workflowbutton_#Doc.DocumentNo#" type="hidden" onclick="javascript:ptoken.navigate('DocumentWorkflow.cfm?ajaxid=#Doc.DocumentNo#','#Doc.DocumentNo#')">	   
	
	<input type="hidden" 
		   id="workflowlinkprocess_#Doc.DocumentNo#" 
		   onclick="ptoken.navigate('DocumentCandidateSelect.cfm?id=#url.id#','selectedme')">		   
	   
	</cfoutput>	   
			  	   	
	<tr><td colspan="3" style="padding:8px">
		
		<cfdiv id="#doc.DocumentNo#" 
		    bind="url:DocumentWorkflow.cfm?ajaxid=#Doc.DocumentNo#"/>   
				
	</td></tr>
	
	</table>
	
	</td></tr>
	</table>

</CFFORM>

</cf_divscroll>

<cf_screenbottom layout="webapp">

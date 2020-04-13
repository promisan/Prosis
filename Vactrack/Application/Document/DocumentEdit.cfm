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
    	
	ProsisUI.createWindow('myassociate', 'Associate', '',{x:100,y:100,height:document.body.clientHeight-120,width:document.body.clientWidth-120,modal:true,center:true})    					
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
			  html          = "No"
			  banner        = "green"			 
			  systemmodule  = "Vacancy"
			  functionclass = "Window"
			  functionName  = "Recruitment track"			  
			  line          = "no"			  
			  jquery        = "Yes"
			  label         = "Recruitment Track: #Doc.DocumentNo#"
			  option        = "#Doc.Mission# / #Doc.PostGrade# </b>owner:<b> #Doc.Owner#</b>"
			  scroll        = "Yes">
			  

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    	SELECT *
	    FROM   OrganizationObject
		WHERE  ObjectKeyValue1 = '#URL.id#'
		AND    ObjectKeyValue2 is NULL		
		AND    Operational = 1
</cfquery>
	
<cf_layoutscript>
<cf_textareascript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"
		  size="50"
          name="controltop">	
		  
		<cf_ViewTopMenu label="Recruitment Track: #URL.ID#" menuaccess="context" background="blue">
				
	</cf_layoutarea>		 

	<cf_layoutarea  position="center" name="box">
		
	     <cf_divscroll style="height:98%">		 
			     <cfinclude template="DocumentEditForm.cfm">	
		 </cf_divscroll>

	</cf_layoutarea>	
	
	<cfif Object.recordcount eq "1">
	
		<cf_layoutarea 
		    position="right" name="commentbox" minsize="20%" maxsize="30%" size="380" overflow="yes" collapsible="true" splitter="true">
		
			<cf_divscroll style="height:100%">
				<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
			</cf_divscroll>
			
		</cf_layoutarea>	
	
	</cfif>	
		
</cf_layout>			  

<cf_screenbottom layout="webapp">

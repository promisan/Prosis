
<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Document
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="GetCandidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Applicant
	WHERE  PersonNo = '#URL.ID1#' 
</cfquery>

<cf_screentop title = "#URL.ID#: #GetCandidate.FirstName# #GetCandidate.LastName#"   
   height        = "100%" 
   layout        = "webapp"
   banner        = "blue" 
   bannerforce   = "Yes"
   jquery        = "Yes"
   html          = "No"  
   systemmodule  = "Vacancy"
   functionclass = "Window"
   functionName  = "Candidate track"    
   band          = "no"
   line          = "no" 
   scroll        = "no">

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
    FROM   stTravel
	WHERE  PersonNo   = '#URL.ID1#'
	AND    DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="GetReassignment" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   stReassignment
	WHERE  PersonNo   = '#URL.ID1#'
	AND    DocumentNo = '#URL.ID#'
</cfquery>   
 
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
 SELECT  COUNT(*) as Posts
 FROM    DocumentPost
 WHERE   DocumentNo  = '#URL.ID#' 
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
		 SELECT   TOP 1 *
		 FROM     Organization.dbo.OrganizationObject O
		          INNER JOIN Organization.dbo.OrganizationObjectAction OA ON O.ObjectId = OA.ObjectId 
		 WHERE    O.ObjectKeyValue1 = '#URL.ID#' 		 
		 AND      O.Operational  = 1
		 AND      O.EntityCode = 'VacDocument' 
		 AND      OA.ActionStatus  ='0'
		 ORDER BY ActionFlowOrder DESC
	</cfquery>
	
	<cfif LastStep.recordcount gte "2">
		<cf_message message="Problem, the track has to be forwarded before you can process the candidate" return="close">
		<cfabort>
	</cfif>

</cfif>

<cfquery name="Parameter" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
	WHERE Identifier = 'A'
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

<cfquery name="GetClass" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_EntityClass
	WHERE  EntityCode = 'VacCandidate'
	AND    EntityClass = '#GetCandidateStatus.EntityClass#'
</cfquery>

<cfquery name="GetRelease" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM   stReleaseRequest R
    WHERE  DocumentNo = '#URL.ID#'
	AND    PersonNo    = '#URL.ID1#'
</cfquery>

<cfset submit = "0">

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
		ProsisUI.createWindow('myarrival', 'On boarding', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    					
		ptoken.navigate('#SESSION.root#/Staffing/Application/Position/Lookup/PositionTrack.cfm?Source=vac&mission=#Doc.Mission#&mandateno=0000&applicantno=#URL.ID1#&personno=&recordid=#URL.ID#&documentno=#URL.ID#','myarrival') 	
	}
	
	function arrivalrefresh() {	
	    ptoken.navigate('CandidateWorkflow.cfm?id=#url.id#&id1=#url.id1#&ajaxid=#getCandidateStatus.CandidateId#','#getCandidateStatus.CandidateId#');		
	}		
	
	function withdraw() {
	
		if (confirm("Do you want to withdraw this candidate and revert the workflow back to support a new selection process ?")) {
			ptoken.location('setCandidateWithdraw.cfm?ID=#URL.ID#&ID1=#URL.ID1#')
		}	
		return false	
	}	
	
	function revoke() {
	
		if (confirm("Do you want to revoke the current track and revert to the last step of the recruitment flow ?")) {
			ptoken.location('setCandidateRevokeTrack.cfm?ID=#URL.ID#&ID1=#URL.ID1#')
		}	
		return false	
	}	
	
	function note() {	
		
		ProsisUI.createWindow('interviewbox','Interview record','',{x:100,y:100,width:document.body.offsetWidth-100,height:document.body.offsetHeight-90,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Interview/CandidateInterview.cfm?DocumentNo=#URL.ID#&PersonNo=#URL.ID1#&ActionCode=view','interviewbox')
			
	}

</script>

</cfoutput>

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    	SELECT *
	    FROM   OrganizationObject
		WHERE  ObjectKeyValue1 = '#URL.id#'
		AND    ObjectKeyValue2 = '#URL.id1#'
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
		  
		<cf_ViewTopMenu label="#URL.ID#: <b>#GetCandidate.FirstName# #GetCandidate.LastName#" menuaccess="context" background="blue">
				
	</cf_layoutarea>		 

	<cf_layoutarea  position="center" name="box">
		
	     <cf_divscroll style="height:98%;padding-left:10px;padding-right:10px">		 
			     <cfinclude template="CandidateEditForm.cfm">	
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
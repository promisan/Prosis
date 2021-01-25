
<cfset checkText = "Select">

<cfset flowaction = action.actionCode>

<!--- obtain relevant actioncode --->

<cfswitch expression="#url.wparam#">

<cfcase value="MARK">

	<cfquery name="getAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublish
		WHERE  ( ActionDialogParameter = 'MARK' )
			   AND ActionPublishNo = '#Object.ActionPublishNo#'
	</cfquery>
	
	<cfset flowaction = getaction.ActionCode>

</cfcase>

<cfcase value="TEST">

	<cfquery name="getAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublish
		WHERE  ( ActionDialogParameter = 'TEST' )
			   AND ActionPublishNo = '#Object.ActionPublishNo#'
	</cfquery>
	
	<cfset flowaction = getaction.ActionCode>

</cfcase>

<cfcase value="SCORE">

	<cfquery name="getAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublish
		WHERE  ( ActionDialogParameter = 'TEST' )
			   AND ActionPublishNo = '#Object.ActionPublishNo#'
	</cfquery>
	
	<cfset flowaction = getaction.ActionCode>

</cfcase>

<cfcase value="INTERVIEW">

	<cfquery name="getAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublish
		WHERE  ( ActionDialogParameter = 'INTERVIEW' )
			   AND ActionPublishNo = '#Object.ActionPublishNo#'
	</cfquery>
	
	<cf<cfset flowaction = getaction.ActionCode>

</cfcase>

<cfcase value="SELECT">

	<cfquery name="getAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublish
		WHERE  ( ActionDialogParameter = 'SELECT' )
			   AND ActionPublishNo = '#Object.ActionPublishNo#'
	</cfquery>
	
	<cfset flowaction = getaction.ActionCode>

</cfcase>

</cfswitch>

<!--- handling of the interface --->

<cfif url.wparam eq "MARK" or url.wparam eq "TEST" or url.wparam eq "SCORE">
	 
	<!--- we check if there is an SCORE step --->
	  
	<cfquery name="Score" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublish
		WHERE  ( ActionDialog = 'INT' OR ActionDialogParameter = 'SCORE' )
			   AND ActionPublishNo = '#Object.ActionPublishNo#'
	</cfquery>
	
	<cfquery name="Interview" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublish
		WHERE  ( ActionDialog = 'INT' OR ActionDialogParameter = 'INTERVIEW' )
			   AND ActionPublishNo = '#Object.ActionPublishNo#'
	</cfquery>	
			
	<cfif url.wparam eq "SCORE" or (url.wparam eq "TEST" and Score.recordcount eq "0")>	
	
		<cfset dialog = "Score">
		<cfset checkText = "Pass">
		
		<cfif Interview.RecordCount gte 1>
				
			<!--- If there is also interview/descision step, upon processing candidates should get status 1--->
			
			<input type="Hidden" id="ReviewReset"  name="ReviewReset"  value="0">
			<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="1">
			<cfset required = "'1','2','2s','9'">
			<!--- If there is a interview step, upon processing candidates should get status 1--->
			<cfset wfinal = "1">
	
		<cfelse>
	
			<!--- If there is no interview step, it means this is the decision step --->
			
			<input type="Hidden" id="ReviewReset"  name="ReviewReset"   value="0">
			<input type="Hidden" id="ReviewStatus" name="ReviewStatus"  value="2">
			<cfset required = "'1','2','2s','9'">
			<!--- If there is no interview step, upon processing candidates should get status 2--->
			<cfset wfinal = "2">
	
		</cfif>
		
	<cfelseif url.wparam eq "TEST">	
	
		<!--- the test interface by absence of the score allows ALSO scoring combined--->
	
		<cfset dialog = "Test">
		<cfset checkText = "View">
								
		<!--- If there is also interview/descision step, upon processing candidates should get status 1--->
		
		<input type="Hidden" id="ReviewReset"  name="ReviewReset"  value="0">
		<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="1">
		<cfset required = "'1','2','2s','9'">
		<!--- If there is a interview step, upon processing candidates should get status 1--->
		<cfset wfinal = "1">
			
	<cfelseif url.wparam eq "MARK">
		
		<cfset dialog = "Mark">
		<cfset checkText = "Pass">	
		
		<input type="Hidden" id="ReviewReset"  name="ReviewReset"  value="0">
		<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="1">
		<cfset required = "'0','1','2','2s','9'">
		<!--- If there is a interview step, upon processing candidates should get status 1--->
		<cfset wfinal = "1">
					
	</cfif>
		
<cfelseif url.wparam eq "INTERVIEW">

	   <cfset checkText = "Outcome">
	
	   <cfset dialog = "Interview">
		<input type="Hidden" id="ReviewReset"  name="ReviewReset"   value="1">
		<input type="Hidden" id="ReviewStatus" name="ReviewStatus"  value="2">
	   <cfset required = "'1','2','2s'">
	   <cfset wfinal = "2">
		
	   <cfquery name="check" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT   *		   
		     FROM    DocumentCandidate  				   	   
			 WHERE   DocumentNo = '#Object.ObjectKeyValue1#'		 
			 AND     Status IN (#preserveSingleQuotes(required)#) 		  		 			
			 AND     EntityClass is NULL			 
	   </cfquery>
		 
		<cfif check.recordcount eq "0">		 
		 	<cfset required = "'0','1','2','2s'">		 
		</cfif> 
	
<cfelseif url.wparam eq "SELECT">
	
	<cfset checkText = "Approve">
	
	<cfset dialog = "Selection">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="2">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="2s">
	<cfset required = "'2','2s','9'">
	<cfset wfinal = "2s">
	
<cfelseif url.wparam eq "INIT">

	<cfset checkText = "Track">

	<!--- initiate recruitment --->
	<cfset dialog = "Initiate">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="2s">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="Track">
	<cfset required = "'2s'">
	<cfset wfinal = "Track">	

<cfelse>

	<!--- close track, thank you interface --->

	<cfset checkText = "Log">

	<cfset dialog = "Close">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset"   value="1">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus"  value="2">
	<cfset required = "'1','2'">
	
	<cfset wfinal = "Close">	
	
</cfif>

<!--- processors --->

<cfquery name="Access" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT U.Account
		FROM   OrganizationObjectActionAccess OOA INNER JOIN System.dbo.UserNames U ON OOA.UserAccount = U.Account
		WHERE  ObjectId   = '#Object.ObjectId#'
		AND    ActionCode = '#flowAction#'	
		UNION 
		SELECT DISTINCT U.Account 
		FROM   Vacancy.dbo.DocumentCandidateAssessment OOA INNER JOIN System.dbo.UserNames U ON OOA.OfficerUserId = U.Account
		WHERE  DocumentNo  = '#Object.ObjectKeyValue1#'
		AND    ActionCode  = '#flowAction#'	
	</cfquery>
	
<cfif access.recordcount eq "0">

	<cfset processors = "0">
	
<cfelse>

	<cfset processors = "1">

</cfif>	


<cf_dialogStaffing>
<cf_calendarscript>
<cfinclude template="../Document/Dialog.cfm">

<cfquery name="Owner" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM   Ref_ParameterOwner
	</cfquery>

	<cfif Owner.PathHistoryProfile eq "">
		<cfset path = "Roster/PHP/PDF/PHP_Combined_List.cfm">
	<cfelse>
	    <cfset path = "Custom/#Owner.PathHistoryProfile#">
	</cfif>

<cfoutput>

<script language="JavaScript">

	function printingPHP(roster,format,script) {
		 ptoken.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/php_"+script+".pdf?ts="+new Date().getTime(),"php_"+script, "location=no, toolbar=no, scrollbars=yes, resizable=yes")
	}
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hl(itm,fld){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
	 	 		 	
		 if (fld != false){
			
		 itm.className = "highLight2";
		 }else{			
	     itm.className = "";		
		 }
	  }
	
	function assessment(bx,doc,per,act) {
	
		se  = document.getElementById(bx)
		if (se.className == "regular"){
			se.className = "hide";
		}else{
			se.className = "regular";
			ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Assessment/CandidateAssessment.cfm?modality=#url.wparam#&objectid=#object.objectid#&documentno='+doc+'&personno='+per+'&actioncode='+act,'box'+bx)		
		}
	
	}
	
	function phrases(id) {		
		ProsisUI.createWindow('phrases', 'Maintain questions','',{x:100,y:100,width:document.body.offsetWidth-130,height:document.body.offsetHeight-130,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Roster/RosterSpecial/Bucket/BucketQuestion/RecordListing.cfm?idfunction='+id,'phrases')
	}
	
	function testview(act) {		
		ProsisUI.createWindow('testview', 'Submission status','',{x:100,y:100,width:document.body.offsetWidth-120,height:400,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Interaction/TestCandidateView.cfm?actionid='+act,'testview')		
							
	}
	
	function testevaluation(doc,per,act,mde,cls) {		
		ProsisUI.createWindow('test', 'Evaluation','',{x:100,y:100,width:document.body.offsetWidth-70,height:document.body.offsetHeight-70,modal:true,center:true})
		if (mde == 'edit') {
			ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Assessment/AssessmentView.cfm?documentno='+doc+'&actioncode='+act+'&personno='+per+'&mode='+mde+'&modality='+cls,'test')
		} else {
		   	ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Assessment/AssessmentView.cfm?documentno='+doc+'&actioncode='+act+'&personno='+per+'&mode='+mde+'&modality='+cls,'test')		
		}					
	}
	
	function quesave(id,topic) {	
	   document.mytopic.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ptoken.navigate('#SESSION.root#/Roster/RosterSpecial/Bucket/BucketQuestion/RecordListingSubmit.cfm?idfunction='+id+'&topicid='+topic,'listing','','','POST','mytopic')
		 }   
	 }
	
	function editactivity(id,doc,per,act,actid) {		
		ProsisUI.createWindow('activitybox', 'Activity','',{x:100,y:100,width:document.body.offsetWidth-130,height:document.body.offsetHeight-130,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Action/ActionEdit.cfm?id='+id+'&DocumentNo='+doc+'&PersonNo='+per+'&ActionCode='+act+'&ActionId='+actid,'activitybox')
	}
	
	function deleteactivity(id,doc,per,act,actid) {		
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Action/ActionDelete.cfm?actionid='+id+'&DocumentNo='+doc+'&PersonNo='+per+'&ActionCode='+act+'&ObjectActionId='+actid,'boxaction'+per)
	}
		
	function decision(box,doc,per,act,sta,fnl) {		
		ProsisUI.createWindow('decisionbox', 'Overall assessment and decision','',{x:100,y:100,width:document.body.offsetWidth-130,height:document.body.offsetHeight-130,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Recommendation/CandidateRecommendation.cfm?wparam=#url.wparam#&DocumentNo='+doc+'&PersonNo='+per+'&ActionCode='+act+'&wfinal='+fnl+'&status='+sta,'decisionbox');
	}
	
	function interview(per,act) {		
		ProsisUI.createWindow('interviewbox', 'Minutes of the Interview','',{x:100,y:100,width:document.body.offsetWidth-100,height:document.body.offsetHeight-90,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Interview/CandidateInterview.cfm?DocumentNo=#Object.ObjectKeyValue1#&PersonNo='+per+'&ActionCode='+act,'interviewbox');
	}
	
	function personprofile(doc,per) {
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateProfile.cfm?documentno=#Object.ObjectKeyValue1#&PersonNo='+per,'detailbox')
		expandArea('mybox','detailbox')
	}	
	
	function savecandidateeval(obj,per,usr,act,com,val,fld,mdl) {		   	     
		_cf_loadingtexthtml='';			
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Assessment/setAssessment.cfm?objectid='+obj+'&useraccount='+usr+'&personno='+per+'&actioncode='+act+'&competenceid='+com+'&formfield='+val+'&field='+fld+'&modality='+mdl,'process','','','POST','formembed')				
	}	
	
	function showquestion(doc,per,act,mde,cls) {
	    ptoken.open('#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewContent.cfm?documentno='+doc+'&personno='+per+'&actioncode='+act+'&mode='+mde+'&modality='+cls,'qa'+doc)
	}

</script>

<input name="Key1"       type="hidden"  value="#Object.ObjectKeyValue1#">
<input name="ActionCode" type="hidden"  value="#flowaction#">
<input name="Dialog"     type="hidden"  value="#Dialog#">
<input name="savecustom" type="hidden"  value="Vactrack/Application/Candidate/CandidateReviewSubmit.cfm">

</cfoutput>

<cfquery name="Doc" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Document
		WHERE DocumentNo = '#Object.ObjectKeyValue1#' 
</cfquery>

<!--- ---------------------------------------------------------------- --->
<!--- determine if the document is enabled for overwrite of candidates --->
<!--- ---------------------------------------------------------------- --->

<cfquery name="Validation" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  DocumentValidation
		WHERE DocumentNo = '#Object.ObjectKeyValue1#'
		AND   ValidationCode = 'OverwriteSelection'
</cfquery>		

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT PostType
    FROM   Position P
	WHERE  PositionNo IN (SELECT PositionNo 
	                      FROM   Vacancy.dbo.DocumentPost 
						  WHERE  DocumentNo = '#Doc.DocumentNo#')
</cfquery>

<!--- get workflow classes that match the owner and the mission --->

<cfquery name="Class"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT R.*
	FROM  Ref_EntityClass R, 
	      Ref_EntityClassPublish P
	WHERE R.Operational  = '1'
	AND   R.EntityCode   = P.EntityCode 
	AND   R.EntityClass  = P.EntityClass
	AND   R.EntityCode   = 'VacCandidate'	
	AND   R.EmbeddedFlow = 0
	AND     	     
			 
	         ( EXISTS (SELECT  'X'
	                   FROM    Ref_EntityClassOwner 
					   WHERE   EntityCode       = 'VacCandidate'
					   AND     EntityClass      = R.EntityClass
					   AND     EntityClassOwner = '#Doc.owner#')
							   
				AND 
			
			   EXISTS (SELECT 'X' 
	                   FROM    Ref_EntityClassMission 
					   WHERE   EntityCode       = 'VacCandidate'
					   AND     EntityClass      = R.EntityClass
					   AND     Mission          = '#Doc.Mission#')		
							   
			 )				   
			
	AND   (R.EntityParameter is NULL or R.EntityParameter = '' or R.EntityParameter = '#Position.PostType#')	  
</cfquery>

<cfif class.recordcount eq "0">

	<!--- wider selection to select owners and not assigned ones --->
		
	<cfquery name="Class"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT R.*
		FROM  Ref_EntityClass R, 
		      Ref_EntityClassPublish P
		WHERE R.Operational  = '1'
		AND   R.EntityCode   = P.EntityCode 
		AND   R.EntityClass  = P.EntityClass
		AND   R.EntityCode   = 'VacCandidate'	
		AND   R.EmbeddedFlow = 0
		AND     
		         (
				 
		          R.EntityClass IN (SELECT EntityClass 
		                           FROM   Ref_EntityClassOwner 
								   WHERE  EntityCode       = 'VacCandidate'
								   AND    EntityClass      = R.EntityClass
								   AND    EntityClassOwner = '#Doc.owner#')						   
								   
				 OR
				
				 R.EntityClass NOT IN (SELECT EntityClass 
		                               FROM   Ref_EntityClassOwner 
								       WHERE  EntityCode  = 'VacCandidate'
								       AND    EntityClass = R.EntityClass)
								   
				 )			
		
		AND   (R.EntityParameter is NULL or R.EntityParameter = '' or R.EntityParameter = '#Position.PostType#')	  
	</cfquery>
</cfif>

<cfquery name="Searchresult" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	      SELECT   A.IndexNo AS IndexNoA, 
		           A.PersonNo, 
				   DC.Status, 
				   DC.EntityClass as CandidateClass, 
				   S.Description  as DescriptionStatus, 				   
				   DC.Remarks, 
				   DC.TsInterviewStart,
				   DC.TsInterviewEnd,
				   DC.OfficerLastName, 
				   DC.OfficerFirstName, 				   
				   DC.Created, 
				   A.LastName, 
				   A.FirstName, 
	               A.Nationality, 
				   (SELECT Name FROM System.dbo.Ref_Nation WHERE Code = A.Nationality) as NationalityName,
				   A.Gender, 
				   A.DOB, 
				   R.ReviewMemo,
				   R.ReviewScore,	
				   R.ReviewId			   
		   FROM    DocumentCandidate DC 
		           INNER JOIN      Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo 
				   INNER JOIN      Ref_Status S ON DC.Status = S.Status 
				   LEFT OUTER JOIN DocumentCandidateReview R ON DC.DocumentNo = R.DocumentNo AND DC.PersonNo = R.PersonNo AND R.ActionCode = '#flowaction#'		   				   	   
		  WHERE    DC.DocumentNo = '#Object.ObjectKeyValue1#'		 
		  AND      DC.Status IN (#preserveSingleQuotes(required)#) 		  		 
		  AND      S.Class       = 'Candidate' 
		  <cfif url.wparam neq "Init">
		  AND      DC.EntityClass is NULL
		  </cfif>
		 
</cfquery>

<cfset col = "130">

<table style="height:100%;min-width:1000px" width="98%" align="center">

<cfoutput>
 
 <tr class="labelmedium line">
 	<td><cf_tl id="Unit">:</td>
	<td bgcolor="white">#Doc.OrganizationUnit#</td>
	<TD><cf_tl id="Due date"></td>
    <td bgcolor="white">#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#</td>
</TR>	
	
<TR>
    <TD><cf_tl id="Functional title">:</TD>
    <TD>#Doc.FunctionalTitle#</TD>
	<td><cf_tl id="Grade">:</td>
	<td>#Doc.PostGrade#</td>
</TR>	
		
<TR class="labelmedium line">
	
	<cfif doc.remarks neq "">
	    <td><cf_tl id="Remarks">:</td>
		<td>#Doc.Remarks#</td>
	</cfif>
	
	<cfif Doc.FunctionId neq "">

		<cfquery name="Bucket" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT *
		    FROM  FunctionOrganization
			WHERE FunctionId = '#Doc.FunctionId#'
		</cfquery>
	
		<td><cf_tl id="VA No">:</td>
	    <td> 
		   <cfif Bucket.ReferenceNo neq "">
		   <A href="javascript:va('#Bucket.FunctionId#');">#Bucket.ReferenceNo#</a>
		   <cfelse>
		   n/a
		   </cfif>
		</td>
		
	</cfif>
	
</TR>
			
<cfif url.wparam eq "MARK" or url.wparam eq "TEST">
	
		<tr class="line labelmedium2">
		<td style="font-size:18px;height:30px" colspan="4">
			<table align="center">
				<tr>
				<td style="font-size:18px;height:30px">
				<a href="javascript:phrases('#bucket.functionid#')"><cf_tl id="Maintain TEST questions"></a>
				</td>
				<cfif url.wparam eq "TEST">
					<td style="padding-left:6px;padding-right:6px">|</td>
					<td style="font-size:18px;height:30px">
					<a href="javascript:testview('#url.id#')"><cf_tl id="Online Submission"></a>
					</td>
				</cfif>
				</tr>
			</table>
		</td>	
		</tr>
	
</cfif>
				
</cfoutput>
			
<tr><td colspan="8" class="labelmedium" style="height:100%" valign="top">

<cfif SearchResult.recordCount eq "0">

	<b><font color="FF0000"><cf_tl id="Problem">:</font></b>
	&nbsp;<cf_tl id="No candidates have reached this status." class="Message"> <cf_tl id="Please send back to prior action!" class="Message">

<cfelse>

	<cf_divscroll>
	
	<table width="99%" class="navigation_table">
	
	    <TR class="labelmedium2 line fixrow" style="height:25px;">
		  <td style="width:10px"></td>	
		  <cfif url.wParam neq "Score">	     	   	  	 
	      <TD style="min-width:200px"><cf_tl id="Candidate"></TD>      
		  <TD style="min-width:100px"><cf_tl id="IndexNo"></TD>	
		  <TD style="min-width:100px"><cf_tl id="Nationality"></TD>
		  <TD style="min-width:100px"><cf_tl id="DOB"></TD>
	      <TD style="min-width:100px"><cf_tl id="Gender"></TD>
		  <TD style="max-width:10px;border-right:1px solid silver"></td>		  
	   	  <TD style="background-color:ffffaf;padding-left:4px;min-width:100px;border-right:1px solid silver"><cf_tl id="Recruit status"></TD>	 
		  <cfelse>
		  <TD colspan="7" style="min-width:200px"><cf_tl id="Candidate"></TD>      		
		  </cfif>		  
		  	   
		  <cfif dialog eq "Score"> 
		  	<td style="width:60px;background-color:ffffaf"><cf_tl id="Score"></td>
		  <cfelseif dialog eq "Interview">	
		    <td align="center" style="width:30px;background-color:ffffaf;"><cf_tl id="I"></td>
		  <cfelse>			 
		  	<td style="width:1px;background-color:ffffaf"></td>
		  </cfif>	  	
		 <td style="min-width:10%;background-color:ffffaf"><cfoutput>#checkText#</cfoutput></td>
		  
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
		
		<!--- entry in the review table --->
			 
		 <cfquery name="Check" 
		 datasource="appsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM  DocumentCandidateReview
			WHERE DocumentNo = '#Object.ObjectKeyValue1#'
			AND   PersonNo   = '#PersonNo#'	 
			AND   ActionCode = '#FlowAction#'  
		 </cfquery>	
		 
		 <cfif Check.recordcount eq 0>		
			 <cf_assignid>			 
		 <cfelse>		 
			 <cfset rowguid = Check.ReviewId>			
		 </cfif>
		 
		 <cfif Check.Recordcount eq "0">
		 		 
			 <cfquery name="Insert" 
				datasource="appsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO DocumentCandidateReview
					 (DocumentNo,
					  PersonNo,		  
					  ActionCode,
					  ReviewId,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
				  VALUES ('#Object.ObjectKeyValue1#', 
						  '#PersonNo#',		  
						  '#FlowAction#',
						  '#rowguid#',
						  '#SESSION.acc#',
						  '#SESSION.last#',		  
						  '#SESSION.first#')
				</cfquery>			
			
				<!--- framework function added by hanno --->
				<cfset showProcess = "0">	
		
		</cfif>
					
		<!--- check processed --->
		
		<cfquery name="Selected" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
			FROM   DocumentCandidate
			 WHERE DocumentNo = '#Object.ObjectKeyValue1#'
			 AND   PersonNo   = '#PersonNo#'
			 AND   EntityClass is NOT NULL
		</cfquery>	
		
		<!--- ------------- --->
		<!--- selectability --->
		<!--- ------------- --->
		
		<cfquery name="DocParameter" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Parameter
		</cfquery> 
		
		<!--- prevent selection of shortlisted candidates 
		     shortlistconflict = 1 : Prevent, so we take both selected and shortlisted candidates 
			 shortlistconflict = 0 : No not prevent so we take only selected candidate  --->
			 
	     <cfif DocParameter.ShortlistConflict eq "0">
		    <!--- only ONLY selected candidates --->
		    <cfset selectonly = "Selected">
		 <cfelse>
		    <cfset selectonly = "">   		 
		 </cfif>
		
		 <!--- check if there is a candidacy which should prevent the selection of this candidate --->
			
		 <cfinvoke component = "Service.Process.Applicant.Vacancy"  
		   method           = "Candidacy" 
		   DocumentNo       = "#Object.ObjectKeyValue1#" 
		   PersonNo         = "#personno#"	
		   Status           = "#status#"   
		   returnvariable   = "PreventSelection">		
				
		<cfif Status lt wfinal>
	        <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffff'))#" class="line navigation_row labelmedium2" 
			  style="font-size:18px;height:26px">		
	    <cfelse> 	
		    <TR class="line navigation_row labelmedium2" style="font-size:18px;height:26px;border-top:1px solid silver">		
	    </cfif> 
				
		<cfset cla = "hide">
		<cfset clb = "hide">		
		
		<cfset stop = "0">
				
		<td style="width:38px;padding-left:4px;height:28px">
		
			<table>
			
			<tr>
					
			<cfif dialog eq "Interview">					
		    <td style="padding-top:8px">	
			    <cfif processors eq "1">					
				<cf_img icon="expand" toggle="yes" onclick="assessment('assessment#CurrentRow#','#Object.ObjectKeyValue1#','#personno#','#flowaction#')">				
				</cfif>
			</td>
				
			<cfelseif dialog eq "SCORE">	
						
				<!--- this will allow us to score as well if no scoring interface is set in this flow --->
			
				<td style="padding-top:7px">
					<cfif processors eq "1">	
				  	<cf_img icon="expand" toggle="yes" onclick="assessment('assessment#CurrentRow#','#Object.ObjectKeyValue1#','#personno#','#flowaction#')">							 
					</cfif>
				</td>				
											
				<!--- record content for scoring --->
				
				<cfif url.wParam eq "TEST">
				
					<td style="padding-right:4px">		
					<table>
						<tr>
							<td>		
							<cfif reviewid neq "">
								<cf_securediv id="session_#reviewid#"  bind="url:#session.root#/tools/entityaction/session/setsession.cfm?actionid=#url.id#&entityreference=#reviewid#">							
							</cfif>	
							</td>
													
						</tr>
					</table>	
					</td>
				
				</cfif>
				
			<cfelseif dialog eq "TEST">	
											
				<!--- get test content for scoring --->
				
				<td style="padding-right:4px">
				<table>
					<tr>
					<td>						
					<cfif reviewid neq "">
							<cf_securediv id="session_#reviewid#"  bind="url:#session.root#/tools/entityaction/session/setsession.cfm?actionid=#url.id#&entityreference=#reviewid#">							
					</cfif>					
					</td>				
					</tr>
					</table>
				</td>	
				
			</cfif>
			
			</tr>
			</table>
			
		</td>	
		
	    <input type="hidden" name="PersonNo_#CurrentRow#" value="#PersonNo#">
		
		<cfif url.wParam neq "Score">
				
		<td style="font-size:17px;font-weight:bold"><a href ="javascript:ShowCandidate('#PersonNo#')">#LastName#, #FirstName#</a></td>	
		<td><cfif IndexNoA neq ""><a href ="javascript:EditPerson('#IndexNoA#','','contract')">#IndexNoA#</a><cfelse>[<cf_tl id="undefined">]</cfif></td>		
		<td>#NationalityName#</td>
		<td>#dateformat(DOB,client.dateformatshow)#</td>
		<td><cfif Gender eq "F"><cf_tl id="Female"><cfelse><cf_tl id="Male"></cfif></td>		
		<td style="padding-top:2px;padding-left:3px;border-right:1px solid silver">
			<!--- track for candidate already exists --->
			<cfif (Status eq "2s" and CandidateClass neq "" and wfinal neq "Track")>				
					<img src="#SESSION.root#/Images/contract.gif" onClick="showdocumentcandidate('#Object.ObjectKeyValue1#','#PersonNo#')" alt="Open candidate track" width="13" height="14">				
			<cfelse>
			 <cf_img icon="open" onclick="personprofile('#doc.documentno#','#PersonNo#')">	
			</cfif>		
		</td>
		<td id="status#PersonNo#" style="padding-left:3px;border-right:1px solid silver" class="<cfif Status gte wfinal>highlight</cfif>">#DescriptionStatus#</td>	
				
		<cfelse>
		
		<td colspan="7" style="height:35px;font-size:20px"><cf_tl id="Candidate"> #currentrow#</td>	
		
		</cfif>			
		
		<td align="left" style="padding-left:4px">	
				
			<cfif dialog eq "Score">
					
				<input type="text" 
					name="ReviewScore_#currentrow#" 
					id="Score#personno#" 
					value="#ReviewScore#" 
					maxlength="3" 
					size="3" 
					class="regularxl"
					style="height:100%;font-size:15px;background-color:ffffcf;text-align:right;border:0px;border-left:1px solid silver;border-right:1px solid silver;">
					
			<cfelseif dialog eq "Interview">	
			
				<cfif processors eq "1">						
			 
			    <img src="#SESSION.root#/Images/Logos/System/Microphone.png?0" title="Interview minutes" 
					name="a#CurrentRow#" border="0" class="regular" 
					onMouseOver="document.a#currentrow#.src='#SESSION.root#/Images/Logos/System/Microphone.png'" 
					onMouseOut="document.a#currentrow#.src='#SESSION.root#/Images/Logos/System/Microphone.png'"
					style="width:20px;height:16px"
					align="ansmiddle" style="cursor: pointer;" 
					onClick="interview('#PersonNo#','#FlowAction#')">
					
				</cfif>	
			   			   					
			</cfif>
			
		</td>
		
		<cfset tdSize = "60px">
		<cfif wFinal eq "Track">
		    <!--- onboarding track --->
			<cfset tdSize = "100px">
		</cfif>
		
		<td style="min-width:#tdsize#" align="left">
	
			<cfset cls = CandidateClass>
			
			 <cfif dialog eq "Close">
				
				<table width="100%">
				<tr>
				
					<cfquery name="Check" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  TOP 1 *
						    FROM    DocumentCandidateReviewAction
							WHERE   DocumentNo = '#doc.DocumentNo#'
							AND     PersonNo   = '#PersonNo#'								
						</cfquery>
				
					<cfif check.recordcount gte "1">
					
					<td>
					
					  <img src="#SESSION.root#/Images/Logos/System/mailout.png" alt="Recruitment review, testing and interview log activities" 
							name="b#CurrentRow#" border="0" class="regular" 
							onMouseOver="document.b#currentrow#.src='#SESSION.root#/Images/Logos/System/mailout.png'" 
							onMouseOut="document.b#currentrow#.src='#SESSION.root#/Images/Logos/System/mailout.png'"
							style="width:22px;height:21px"
							align="ansmiddle" style="cursor: pointer;" 
							onClick="personaction('#PersonNo#','view')">		
					
					</td>
					
					<td style="padding-left:4px;padding-top:1px">
					
					 <img src="#SESSION.root#/Images/Logos/System/test1.png" alt="Test and test results" 
							name="b#CurrentRow#" border="0" class="regular" 					
							style="width:27px;height:15px"
							align="ansmiddle" style="cursor: pointer;" 
							onClick="persontest('#PersonNo#','view')">		
					</td>		
							
					</cfif>
					
					<td align="right" style="padding-left:4px;padding-right:7px;padding-top:1px">
															
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
							
						 <cfif check.recordcount eq "1">	
					
					     <img src="#SESSION.root#/Images/Logos/System/Microphone.png?0" alt="Interview record" 
							name="a#CurrentRow#" border="0" class="regular" 							
							style="width:20px;height:16px"
							align="ansmiddle" style="cursor: pointer;" 
							onClick="personnote('#PersonNo#','view')">
							
						  </cfif>	
											
					</cfif>
					
					</td>				
				</tr>				
				</table>
					
			 <cfelseif dialog eq "Initiate">
				
				<select class="regularxl" name="EntityClass_#CurrentRow#" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
				
					<cfif Class.recordcount gt 1>
					    <option value="">-- <cf_tl id="to be set"> --</option>
					</cfif>
					
					<cfloop query = "Class">
					   <option value="#EntityClass#" 
						  <cfif EntityClass eq "#cls#">selected</cfif>>#EntityClassName#
					  </option>
					</cfloop>
				
				</select>
				
			<cfelseif dialog eq "Test">	
			
				<cfquery name="getContent" 
				datasource="appsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
						
					SELECT       COUNT(*) AS Received
					FROM         DocumentCandidateReviewCompetence
					WHERE        DocumentNo      = '#Object.ObjectKeyValue1#' 
					AND          PersonNo        = '#personno#' 
					AND          ActionCode      = '#flowaction#' 
					AND          CompetenceContent IS NOT NULL				
				</cfquery>	
				
				    <cfif reviewid neq "">
						<table style="width:100%">
						<tr>				
						<td id="box#ReviewId#">			
					     <a href="javascript:showquestion('#Object.ObjectKeyValue1#','#personno#','#flowaction#','edit')">#getContent.Received# <cf_tl id="answers"></a>					 
						</td>					 
						<td style="padding-left:6px;padding-right:5px" align="right">	
						   <img src="#session.root#/images/logos/system/importword.png" style="height:20px;width:22px" alt="Import word" 
						       border="0" onclick="testevaluation('#Object.ObjectKeyValue1#','#PersonNo#','#flowaction#','edit')">
						</td>					
						</tr>
						</table>	
					</cfif>				 
				
					<input type="hidden" name="ReviewStatus_#CurrentRow#" id="ReviewStatus_#CurrentRow#" value="1">					
				
			
				<!--- NADA --->
				
			<cfelseif wFinal eq "2s" or wFinal eq "1">	
									
				 <cfif (PreventSelection.recordcount eq "0" or Validation.recordcount eq "1") and 
				  (Selected.recordcount eq "0" or Status eq "9" or Selected.Status gte "2" or Selected.Status lte "2s")>
			
																								
					<input onClick="hl(this,this.checked)" class="radiol" style="height:16px;width:16px" 
					type="checkbox" name="ReviewStatus_#CurrentRow#" id="ReviewStatus_#personno#" value="#wFinal#" <cfif Status gte wFinal>checked</cfif> style="cursor:pointer;">					
										
				<cfelse>			
					
					 <!--- can't select a candidate that has been selected ---> 
					 <cfset stop = "1">
				     <font color="FF0000"><cf_tl id="See below"></font>						 	
					 
				</cfif>			
				
			<cfelse>
	
			    <cfif (PreventSelection.recordcount eq "0" or Validation.recordcount eq "1") and 
				  (Selected.recordcount eq "0" or Status eq "9" or Selected.Status gte "2" or Selected.Status lte "2s")>
				 
				    <table>
					<tr class="labelmedium2">									
						<td style="padding-left:4px">												
							<a href="javascript:decision('ReviewStatus_#CurrentRow#','#object.ObjectKeyValue1#','#personno#','#flowaction#','#status#','#wfinal#')">
							<cf_tl id="Record decision">
							</a>
						</td>																	
					</tr>
					</table>		
					
				<cfelse>			
					
					 <!--- can't select a candidate that has been selected ---> 
					 <cfset stop = "1">
				     <font color="FF0000"><cf_tl id="See below"></font>						 	
					 
				</cfif>
				
			</cfif>
			
		</td>			
		
		</tr>
		
		<!--- next line --->
		
		<cfif dialog neq "score">
					
			<cfif Remarks neq "">
			
				<tr class="navigation_row_child labelmedium">
					<td colspan="2"></td>
					<td colspan="8">#Remarks#</td>
				</tr>
				
			</cfif>
		
			 <!--- check if there is are any other candidacy for this person --->
			 
			<cfinvoke component  = "Service.Process.Applicant.Vacancy"  
			   method            = "Candidacy" 
		   	   Owner             = "#Mission.MissionOwner#"
			   DocumentNo        = "#Object.ObjectKeyValue1#" 
			   PersonNo          = "#personno#"	
			   Status            = ""   
			   returnvariable    = "OtherCandidates">	    
				
			<cfif OtherCandidates.recordcount gte 0>
			
				<tr class="navigation_row_child">				
					<td colspan="10">				
				    <table width="100%">
						<cfloop query="OtherCandidates">
						<tr><td class="labelmedium" style="padding-left:10px">				    
						<font color="FF0000"><cf_tl id="Attention">:</font>
						 <a href="javascript:showdocument('#OtherCandidates.DocumentNo#')">
						 #Status#<cf_tl id="for">: #OtherCandidates.Mission#&nbsp;#OtherCandidates.PostGrade# #OtherCandidates.FunctionalTitle#</b></a>
					     </td>
						</tr>
						</cfloop>
					</table>				
					</td>
				</tr>
					
			</cfif>
			
			<cfif stop eq "1">
			
				<tr class="navigation_row_child">				
					<td colspan="10">
				    <table width="100%">
						<tr><td class="labelmedium" style="padding-left:10px">;
							<a href="javascript:showdocumentcandidate('#Object.ObjectKeyValue1#','#PersonNo#')">
							<font color="FF0000"><cf_tl id="Attention">:</font> <cf_tl id="This candidate has already a recruitment track." class="Message"></a>
					    	</td>
						</tr>
					</table>
					</td>
				</tr>
					
			</cfif>
			
			<cfquery name="getActivity" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM   Ref_EntityActionDocument
					WHERE  ActionCode = '#flowaction#'
					AND    DocumentId IN (SELECT DocumentId FROM Ref_EntityDocument WHERE DocumentType = 'activity' AND DocumentMode <> 'Notify')
			</cfquery>	
			
			<cfif dialog eq "Interview">			
							
				<cfif getActivity.recordcount gte "1">				
			
					<tr id="action#currentrow#" class="xxhide">		
					<td></td>			
					<td colspan="9">
						<cf_securediv id="boxaction#PersonNo#" 
						 bind="url:#session.root#/Vactrack/Application/Candidate/Action/ActionListing.cfm?documentNo=#Object.ObjectKeyValue1#&PersonNo=#PersonNo#&actioncode=#flowaction#&objectactionid=#url.id#">				
					</td>
					</tr>	
				
				</cfif>
																				
				<tr id="assessment#currentrow#" class="hide">		
				<td></td>	
				<td colspan="9" id="boxassessment#currentrow#" style="padding:5px;overflow-x: scroll;"></td>
				</tr>		
				
			<cfelseif dialog eq "Mark">
						
				<cfif getActivity.recordcount gte "1">				
			
					<tr id="action#currentrow#" class="xxhide">					
					<td></td>
					<td colspan="9" style="padding-left:10px">
						<cf_securediv id="boxaction#PersonNo#" 
						 bind="url:#session.root#/Vactrack/Application/Candidate/Action/ActionListing.cfm?documentNo=#Object.ObjectKeyValue1#&PersonNo=#PersonNo#&actioncode=#flowaction#&objectactionid=#url.id#">				
					</td>
					</tr>	
				
				</cfif>
						
				<tr id="assessment#currentrow#" class="hide">		
					<td></td>	 
				    <td colspan="9" style="padding:5px" id="boxassessment#currentrow#"></td>
				</tr>		
			
			<cfelse>
			
				<!--- MARK and CLOSE show subactions to be visible here which are tracked partially in the workflow object --->
							
								
				<cfif getActivity.recordcount gte "1">	
					
					<tr id="action#currentrow#" class="xxhide">
					<td></td>
					<td colspan="9" style="padding-left:10px">
						<cf_securediv id="boxaction#PersonNo#" 
						 bind="url:#session.root#/Vactrack/Application/Candidate/Action/ActionListing.cfm?documentNo=#Object.ObjectKeyValue1#&PersonNo=#PersonNo#&actioncode=#flowaction#&objectactionid=#url.id#">				
					</td>
					</tr>	
				
				</cfif>
				
				<tr id="assessment#currentrow#" class="hide">			 
				  <td colspan="10" style="padding:5px" id="boxassessment#currentrow#"></td>
				</tr>	
									
			</cfif>
			
		<cfelse>
		
			<tr id="assessment#currentrow#" class="hide">			 
				  <td colspan="10" style="padding:5px" id="boxassessment#currentrow#"></td>
				</tr>		
			
		</cfif>	
			
		</cfoutput>	
		
		<input type="hidden" name="Row" value="<cfoutput>#searchResult.recordcount#</cfoutput>">
		
	</table>	
	
</cfif>

</td></tr>

<tr><td style="height:15px"></td></tr>

</table>     

<cfif SearchResult.recordCount gte "1">
	<cfset ajaxonload("doHighlight")>    	
</cfif>


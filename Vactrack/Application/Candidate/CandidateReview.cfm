
<cfset checkText = "Select">

<cfif url.wparam eq "MARK" or url.wparam eq "TEST">
	 
	<!--- we check if there is an interview step otherwise it goes to 2 = recommended --->
	  
	<cfquery name="Interview" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublish
		WHERE  ( ActionDialog = 'INT' OR ActionDialogParameter = 'INTERVIEW' )
			   AND ActionPublishNo = '#Object.ActionPublishNo#'
	</cfquery>
	
	<cfif url.wparam eq "MARK">
	
		<cfset dialog = "Mark">
		<cfset checkText = "Pass">
		
	<cfelse>
	
		<cfset dialog = "Test">
		<cfset checkText = "Pass">
		
	</cfif>
	
	<cfif Interview.RecordCount gte 1>
	
		<!--- If there is also interview/descision step, upon processing candidates should get status 1--->
		
		<input type="Hidden" id="ReviewReset"  name="ReviewReset"  value="0">
		<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="1">
		<cfset required = "'0','1','2','2s','9'">
		<!--- If there is a interview step, upon processing candidates should get status 1--->
		<cfset wfinal = "1">
	
	<cfelse>
	
		<!--- If there is no interview step, it means this is the decision step --->
		
		<input type="Hidden" id="ReviewReset"  name="ReviewReset"   value="0">
		<input type="Hidden" id="ReviewStatus" name="ReviewStatus"  value="2">
		<cfset required = "'0','1','2','2s','9'">
		<!--- If there is no interview step, upon processing candidates should get status 2--->
		<cfset wfinal = "2">
	
	</cfif>
	
<cfelseif url.wparam eq "INTERVIEW">

	<cfset checkText = "Recommendation">

	<cfset dialog = "Interview">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset"   value="1">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus"  value="2">
	<cfset required = "'1','2'">
	<cfset wfinal = "2">

<cfelseif url.wparam eq "SELECT">
	
	<cfset checkText = "Select">
	
	<cfset dialog = "Selection">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="2">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="2s">
	<cfset required = "'2','2s','9'">
	<cfset wfinal = "2s">

<cfelse>

	<cfset checkText = "Track">

	<!--- initiate recruitment --->
	<cfset dialog = "Initiate">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="2s">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="Track">
	<cfset required = "'2s'">
	<cfset wfinal = "Track">
	
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
			ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateAssessment.cfm?objectid=#object.objectid#&documentno='+doc+'&personno='+per+'&actioncode='+act,'box'+bx)		
		}
	
	}
	
	function editactivity(id,doc,per,act) {		
		ProsisUI.createWindow('activitybox', 'Activity','',{x:100,y:100,width:document.body.offsetWidth-130,height:document.body.offsetHeight-130,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Action/ActionEdit.cfm?id='+id+'&DocumentNo='+doc+'&PersonNo='+per+'&ActionCode='+act,'activitybox')
	}
	
	function deleteactivity(id,doc,per,act) {		
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Action/ActionDelete.cfm?actionid='+id+'&DocumentNo='+doc+'&PersonNo='+per+'&ActionCode='+act,'boxaction'+per)
	}
		
	function decision(box,doc,per,act,sta,fnl) {		
		ProsisUI.createWindow('decisionbox', 'Overall assessment and decision','',{x:100,y:100,width:document.body.offsetWidth-130,height:document.body.offsetHeight-130,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Recommendation/CandidateRecommendation.cfm?wparam=#url.wparam#&DocumentNo='+doc+'&PersonNo='+per+'&ActionCode='+act+'&wfinal='+fnl+'&status='+sta,'decisionbox');
	}
	
	function interview(per,act) {		
		ProsisUI.createWindow('interviewbox', 'Interview record','',{x:100,y:100,width:document.body.offsetWidth-100,height:document.body.offsetHeight-90,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateInterview.cfm?DocumentNo=#Object.ObjectKeyValue1#&PersonNo='+per+'&ActionCode='+act,'interviewbox');
	}
	
	function personprofile(doc,per) {
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateProfile.cfm?documentno=#Object.ObjectKeyValue1#&PersonNo='+per,'detailbox')
		expandArea('mybox','detailbox')
	}	
	
	function savecandidateeval(obj,per,usr,act,com,val,fld) {		   	     
		 _cf_loadingtexthtml='';	
		 ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateAssessmentSubmit.cfm?objectid='+obj+'&useraccount='+usr+'&personno='+per+'&actioncode='+act+'&competenceid='+com+'&formfield='+val+'&field='+fld,'process','','','POST','formembed')	
	}	

</script>

	<input name="Key1"       type="hidden"  value="#Object.ObjectKeyValue1#">
	<input name="ActionCode" type="hidden"  value="#Action.ActionCode#">
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

<cfset col = "130">

<table style="height:100%;min-width:1000px" border="0" width="98%" align="center">


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
		<TD>#Doc.Remarks#</TD>
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
	    <TD> 
		   <cfif Bucket.ReferenceNo neq "">
		   <A href="javascript:va('#Bucket.FunctionId#');">#Bucket.ReferenceNo#</a>
		   <cfelse>
		   n/a
		   </cfif>
		</TD>
		
	</cfif>
	
	</TR>
	
	</cfoutput>
	
	<cfquery name="Searchresult" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	      SELECT   A.IndexNo AS IndexNoA, 
		           A.PersonNo, 
				   DC.Status, 
				   DC.EntityClass as CandidateClass, 
				   S.Description as DescriptionStatus, 				   
				   DC.Remarks, 
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
				   R.ReviewScore
				   
		   FROM    DocumentCandidate DC INNER JOIN
                   Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo INNER JOIN
                   Ref_Status S ON DC.Status = S.Status LEFT OUTER JOIN
                   DocumentCandidateReview R ON DC.DocumentNo = R.DocumentNo AND DC.PersonNo = R.PersonNo AND R.ActionCode = '#Action.ActionCode#'		   				   	   
		  WHERE    DC.DocumentNo = '#Object.ObjectKeyValue1#'		 
		  AND      DC.Status IN (#preserveSingleQuotes(required)#) 		  		 
		  AND      S.Class = 'Candidate' 
	</cfquery>
	
	<cfset act = Action.ActionCode>

<tr><td colspan="8" class="labelmedium" style="padding-left:5px;height:100%" valign="top">

<cfif SearchResult.recordCount eq "0">

	<b><font color="FF0000"><cf_tl id="Problem">:</font></b>
	&nbsp;<cf_tl id="No candidates have reached this status." class="Message"> <cf_tl id="Please send back to prior action!" class="Message">

<cfelse>

	<cf_divscroll>
	
	<table width="99%" class="navigation_table">
	
	    <TR class="labelmedium line fixrow" style="height:25px;">
		  <td style="width:10px"></td>	  
		  <td style="width:10px"></td>
		  <cfif dialog eq "Test"> 
		  	<td style="width:60px"><cf_tl id="Score"></td>
		  <cfelseif dialog eq "Interview">	
		    <td style="width:60px"><cf_tl id="Interview"></td>
		  <cfelse>			 
		  	<td style="width:1px"></td>
		  </cfif>
	   	  <TD style="min-width:100px"><cf_tl id="IndexNo"></TD>
	      <TD style="min-width:200px"><cf_tl id="Name"></TD>      
		  <TD style="min-width:100px"><cf_tl id="Nationality"></TD>
		  <TD style="min-width:100px"><cf_tl id="DOB"></TD>
	      <TD style="min-width:100px"><cf_tl id="Gender"></TD>
		  <td style="min-width:20%"><cfoutput>#checkText#</cfoutput></td>
	   	  <TD style="min-width:100px"><cf_tl id="Status"></TD>	 
		  
		  <!--- 
	  	  <TD style="font-size:17px" align="center"><cf_tl id="Memo"></td>
		  --->
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
			AND   ActionCode = '#Act#'  
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
						  '#Act#',
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
	        <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffff'))#" class="line navigation_row labelmedium" style="font-size:18px;height:26px">		
	    <cfelse> 	
		    <TR class="line navigation_row labelmedium" style="font-size:18px;height:26px;border-top:1px solid silver">		
	    </cfif> 
				
		<cfset cla = "hide">
		<cfset clb = "regular">					 
		
		<cfset stop = "0">
				
		<td style="padding-left:4px;padding-top:5px">
		
			<cfif url.wparam eq "INTERVIEW">					
				<cf_img icon="expand" toggle="yes" onclick="assessment('assessment#CurrentRow#','#Object.ObjectKeyValue1#','#personno#','#action.actioncode#')">				
			</cfif>
			
		</td>	
		
	    <input type="hidden" name="PersonNo_#CurrentRow#" value="#PersonNo#">
		
		<td style="padding-left:3px">
			<!--- track for candidate already exists --->
			<cfif (Status eq "2s" and CandidateClass neq "" and wfinal neq "Track")>
				<button class="button3" onClick="showdocumentcandidate('#Object.ObjectKeyValue1#','#PersonNo#')">
					<img src="#SESSION.root#/Images/contract.gif" alt="Open candidate track" width="13" height="14">
				</button>
			<cfelse>
			 <cf_img icon="open" onclick="personprofile('#doc.documentno#','#PersonNo#')">	
			</cfif>		
		</td>
		
		<td align="left">	
		
			<cfif dialog eq "Test">
			
				<input  type="text" 
					name="ReviewScore_#currentrow#" 
					id="ReviewScore_#currentrow#" 
					value="#ReviewScore#" 
					maxlength="3" 
					size="3" 
					class="regularxl"
					style="background-color:ffffcf;text-align:right;border:0px;border-left:1px solid silver;border-right:1px solid silver;">
					
			<cfelseif dialog eq "Interview">		
			
			   <a href="javascript:interview('#PersonNo#','#Act#')" title="Record interview results"><cf_tl id="Interview"></a>
					
			</cfif>
			
		</td>
		<td><cfif IndexNoA neq "">#IndexNoA#<cfelse>[<cf_tl id="undefined">]</cfif></td>
	    <td><a href ="javascript:ShowCandidate('#PersonNo#')">#LastName#, #FirstName#</a></td>			
		<td>#NationalityName#</td>
		<td>#dateformat(DOB,client.dateformatshow)#</td>
		<td><cfif Gender eq "F"><cf_tl id="Female"><cfelse><cf_tl id="Male"></cfif></td>		
		
		<cfset tdSize = "60px">
		<cfif wFinal eq "Track">
		    <!--- onboarding track --->
			<cfset tdSize = "100px">
		</cfif>
		
		<td style="min-width:#tdsize#" align="left">
	
			<cfset cls = CandidateClass>
					
			 <cfif wFinal eq "Track">
				
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
				
			<cfelseif wFinal eq "2s" or wFinal eq "1">	
			
				 <cfif (PreventSelection.recordcount eq "0" or Validation.recordcount eq "1") and 
				  (Selected.recordcount eq "0" or Status eq "9" or Selected.Status gte "2" or Selected.Status lte "2s")>
			
					<table>
					<tr>
					<td id="ReviewStatus_#CurrentRow#">
														
					<input onClick="hl(this,this.checked)" class="Radiol" style="height:18px;width:18px" 
					type="checkbox" name="ReviewStatus_#CurrentRow#" id="ReviewStatus_#CurrentRow#" value="#wFinal#" <cfif Status gte wFinal>checked</cfif> style="cursor:pointer;">					
														
					</td>														
					</tr>
					</table>	
					
				<cfelse>			
					
					 <!--- can't select a candidate that has been selected ---> 
					 <cfset stop = "1">
				     <font color="FF0000"><cf_tl id="See below"></font>						 	
					 
				</cfif>			
				
			<cfelse>
	
			    <cfif (PreventSelection.recordcount eq "0" or Validation.recordcount eq "1") and 
				  (Selected.recordcount eq "0" or Status eq "9" or Selected.Status gte "2" or Selected.Status lte "2s")>
				 
				    <table>
					<tr>									
						<td style="padding-left:1px">												
							<a href="javascript:decision('ReviewStatus_#CurrentRow#','#object.ObjectKeyValue1#','#personno#','#action.actioncode#','#status#','#wfinal#')">
							<cf_tl id="Add recommendation">
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
		
		<td id="status#PersonNo#" style="padding-left:3px" class="<cfif Status gte wfinal>highlight</cfif>">#DescriptionStatus#</td>
		
		<!--- has to be handled differently now as we have more text boxes 
		<td style="font-size:17px" align="center">
		
			<cfset row = CurrentRow>
			
			<cfquery name="Memo" 
				 datasource="AppsVacancy" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			      SELECT  *
			      FROM     DocumentCandidateReview 
				  WHERE    DocumentNo = '#Object.ObjectKeyValue1#'
				  AND      PersonNo   = '#PersonNo#'
				  AND      ActionCode != '#Act#'
				  AND      ActionStatus = '1'
				  AND      ReviewMemo IS NOT NULL			  
				  ORDER BY Created DESC
		    </cfquery>
								
			<cfloop query="Memo">
			
				<cfif Memo.ReviewMemo neq "">			
					<cf_img icon="expand" toggle="yes" onclick="more('detail#CurrentRow#')">				
				</cfif>			
					
			</cfloop>	
			
		</td>
		--->
		</tr>
		
		<!---
		<cfloop query="Memo">
				
			<cfif Memo.ReviewMemo neq "">
				<tr bgcolor="E0F0F3" class="hide" id="doc#Row#_#CurrentRow#">
				<td colspan="2"></td>
				<td colspan="2" class="labelmedium" style="padding-left:10px">#Memo.OfficerFirstName# #Memo.OfficerLastName#</td>
				<td colspan="7" class="labelmedium" style="padding-left:10px">#Memo.ReviewMemo#</td>
				</tr>
			</cfif>
		
		</cfloop>
		--->
		
		<cfif Remarks neq "">
		
			<tr class="navigation_row_child labelmedium">
				<td colspan="2"></td>
				<td colspan="8">#Remarks#</td>
			</tr>
			
		</cfif>
		
		 <!--- check if there is are any other candidacy for this person --->
		 
		<cfinvoke component = "Service.Process.Applicant.Vacancy"  
		   method           = "Candidacy" 
	   	   Owner            = "#Mission.MissionOwner#"
		   DocumentNo       = "#Object.ObjectKeyValue1#" 
		   PersonNo         = "#personno#"	
		   Status           = ""   
		   returnvariable   = "OtherCandidates">	    
				
		<cfif OtherCandidates.recordcount gte 0>
		
			<tr class="navigation_row_child">
				<td colspan="2"></td>
				<td colspan="8">
				
			    <table border="0" cellpadding="0" cellspacing="0" width="100%">
					<cfloop query="OtherCandidates">
					<tr><td class="labelmedium" style="padding-left:10px">				    
						<a href="javascript:showdocument('#OtherCandidates.DocumentNo#')">
						#Status#<cf_tl id="for">: #OtherCandidates.Mission#&nbsp;#OtherCandidates.PostGrade# #OtherCandidates.FunctionalTitle#</b></a>
				    	</td>
					</tr>
					</cfloop>
				</table>
			</tr>
				
		</cfif>
			
		<cfif stop eq "1">
		
			<tr class="navigation_row_child">
				<td colspan="2"></td>
				<td colspan="8">
			    <table width="100%">
					<tr><td class="labelmedium" style="padding-left:10px">;
						<a href="javascript:showdocumentcandidate('#Object.ObjectKeyValue1#','#PersonNo#')">
						<b><font color="FF0000"><cf_tl id="Attention">:</font></b> <cf_tl id="This candidate has already a recruitment track." class="Message"></a>
				    	</td>
					</tr>
				</table>
			</tr>
				
		</cfif>
			
		<cfif dialog eq "Interview">
		
			<!---
			
			<!--- Are there competencies defined for the bucket linked to this document --->
			<cfquery name="BucketCompetencies" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	
				SELECT FC.CompetenceId
				FROM   Document D 
					   INNER JOIN Applicant.dbo.FunctionOrganization FO
							 ON D.FunctionId = FO.FunctionId
					   INNER JOIN Applicant.dbo.FunctionOrganizationCompetence FC
					   		 ON FO.FunctionId = FC.FunctionId
				WHERE  D.DocumentNo = '#Object.ObjectKeyValue1#'
			
			</cfquery>
	
			<cfquery name="Competencies" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT C.CompetenceId, C.Description, I.InterviewNotes
				FROM   Applicant.dbo.Ref_Competence C
					   LEFT OUTER JOIN DocumentCandidateInterview I 
					   		ON C.CompetenceId = I.CompetenceId AND I.PersonNo = '#PersonNo#' 
							   AND I.DocumentNo = '#Object.ObjectKeyValue1#'
				WHERE  C.Operational = 1
				<!--- Means that competencies applicable for this track have been defined at the bucket level --->
				<cfif BucketCompetencies.recordcount gt 0>
				AND    C.CompetenceId IN (#QuotedValueList(BucketCompetencies.CompetenceId)#)
				</cfif>
			 	ORDER BY C.ListingOrder
				
			</cfquery>
			
			<tr id="interview#currentrow#" class="xhide" valign="tops">
			
			<td align="right" width="40"></td>
			
			<td colspan="9" align="left"> 
			
			<table width="90%" align="left">
				
				<tr>
					<td colspan="3" class="labelmedium" style="padding-left:10px"><cf_tl id="Interview details"></td>
				</tr>
				
				<cfif ReviewMemo neq "">
					<tr class="line">
						<td height="19" width="20" align="center"></td>
						<td class="labelmedium" width="20%" style="color:blue"><cf_tl id="Assessment"></td>
						<td>#ReviewMemo#</td>
					</tr>
				</cfif>
				
				<cfloop query="Competencies">
				
				<tr class="line">
				    <td height="19" width="20" align="center"></td>
					<td class="labelmedium" width="20%"><font color="004000">#Description#</font></td>
				    <td style="pading-left:15px;" class="labelmedium"><cfif InterviewNotes eq ""><font color="FF8080">[no comments]</font>
	                       <cfelse>#ParagraphFormat(InterviewNotes)#
						   </cfif>
				    </td>
				</tr>
							
				</cfloop>
				
			</table>
					
			</td></tr>
			
			--->
												
			<tr id="assessment#currentrow#" class="hide">
			<td colspan="2"></td>
			<td colspan="8" id="boxassessment#currentrow#" style="padding:5px"></td>
			</tr>		
			
		<cfelseif dialog eq "Mark">
		
			<tr id="action#currentrow#" class="hide">
				<td colspan="2"></td>
				<td colspan="8" id="boxaction#currentrow#" style="padding:5px"></td>
			</tr>	
		
			<tr  id="assessment#currentrow#" class="hide">
			  <td colspan="2"></td>
			  <td colspan="10" style="padding:5px" id="boxassessment#currentrow#"></td>
			</tr>		
		
		<cfelse>
		
			<!--- show subactions to be visible here which are tracked partially in the workflow object --->
				
			<tr id="action#currentrow#" class="xxhide">
			<td colspan="2"></td>
			<td colspan="8">
				<cfdiv id="boxaction#PersonNo#" 
				 bind="url:#session.root#/Vactrack/Application/Candidate/Action/ActionListing.cfm?documentNo=#Object.ObjectKeyValue1#&PersonNo=#PersonNo#&actioncode=#action.actioncode#">				
			</td>
			</tr>	
			
			<tr id="detail#currentrow#" class="#clb#">
				<td colspan="2"></td>			
				<td colspan="8" style="padding-top:1px;padding-bottom:4px">
					<table width="99%" class="formpadding">
						<tr>
							
							<td colspan="11" align="center" style="padding-right:10px">
							<textarea name="ReviewMemo_#currentrow#" class="regular" style="height:40px;border:1px solid silver;width: 100%; font-size:14px;padding: 4px;background-color: f8f8f8;">#ReviewMemo#</textarea>
							</td>		
							</tr>
							
							<tr>						
							<td colspan="11">
							 
						 	 <input type="Hidden" id="ReviewId_#currentrow#" name="ReviewId_#currentrow#" value="#rowguid#">
					
								 <cf_filelibraryN
									DocumentPath  = "VacDocument"
									SubDirectory  = "#rowguid#" 			
									Insert        = "yes"
									Filter        = ""	
									LoadScript    = "No"
									Box           = "vacdocument_#currentrow#"
									Remove        = "yes"
									ShowSize      = "yes">	
					
							</td>		
						</tr>
					</table>
				</td>
				
			</tr>
		
		</cfif>
			
		</cfoutput>	
		
		<input type="hidden" name="Row" value="<cfoutput>#searchResult.recordcount#</cfoutput>">
		
	</table>	
	
	</cf_divscroll>

</cfif>

</td></tr>

<tr><td style="height:15px"></td></tr>

</table>     

<cfif SearchResult.recordCount gte "1">
	<cfset ajaxonload("doHighlight")>    	
</cfif>
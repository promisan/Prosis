
<HTML><HEAD>
    <TITLE>Document:<cfoutput>#URL.ID#</cfoutput></TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD>

<cf_systemscript>

<cfset checkText = "Select">

<cfif url.wparam eq "MARK" or url.wparam eq "TEST">
	  
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
		<cfset checkText = "Select">
		
	<cfelse>
	
		<cfset dialog = "Test">
		<cfset checkText = "Passed">
		
	</cfif>
	
	<cfif Interview.RecordCount gte 1>
	
		<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="0">
		<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="1">
		<cfset required = "'0','1','2','2s','9'">
		<!--- If there is a interview step, upon processing candidates should get status 1--->
		<cfset final = "1">
	
	<cfelse>
	
		<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="0">
		<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="2">
		<cfset required = "'0','1','2','2s','9'">
		<!--- If there is no interview step, upon processing candidates should get status 2--->
		<cfset final = "2">
	
	</cfif>
	
<cfelseif url.wparam eq "INTERVIEW">

	<cfset checkText = "Recommended">

	<cfset dialog = "Interview">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="1">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="2">
	<cfset required = "'1','2'">
	<cfset final = "2">

<cfelseif url.wparam eq "SELECT">
	
	<cfset checkText = "Selected">
	
	<cfset dialog = "Selection">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="2">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="2s">
	<cfset required = "'2','2s','9'">
	<cfset final = "2s">

<cfelse>

	<cfset checkText = "Track">

	<!--- initiate recruitment --->
	<cfset dialog = "Initiate">
	<input type="Hidden" id="ReviewReset"  name="ReviewReset" value="2s">
	<input type="Hidden" id="ReviewStatus" name="ReviewStatus" value="Track">
	<cfset required = "'2s'">
	<cfset final = "Track">
	
</cfif>

<cf_dialogStaffing>

<cfinclude template="../Document/Dialog.cfm">

<cfoutput>

<script language="JavaScript">

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

function more(bx) {

	se   = document.getElementById(bx)

	if (se.className == "regular"){
		se.className = "hide";
	}else{
		se.className = "regular";
	}

}

function interview(per,act) {
	w = #CLIENT.width# - 100;
	h = #CLIENT.height# - 160;
	window.open("#SESSION.root#/Vactrack/Application/Candidate/CandidateInterview.cfm?DocumentNo=#Object.ObjectKeyValue1#&PersonNo="+per+"&ActionCode="+act, "_blank", "left=30, top=30, width=" +w+ ", height=" +h+ ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");
}

</script>

</cfoutput>

<body>

<cfoutput>

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
<!--- determine of the document is enabled for overwrite of candidates --->
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

<!---
Rem'd out becuase attending the interview does not mean that the candidate is selected
<cfif Final eq "2">

	<cfquery name="Update"
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE DocumentCandidate
		SET    Status                 = '2', 
		       StatusDate             = getDate(), 
			   StatusOfficerUserId    = '#SESSION.acc#',
			   StatusOfficerLastName  = '#SESSION.last#',
			   StatusOfficerFirstName = '#SESSION.first#'
		WHERE  DocumentNo             = '#Object.ObjectKeyValue1#'
		AND    TsInterviewStart is not NULL
	</cfquery>
  
</cfif>
--->
<cfset col = "130">

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
 
 	<tr><td class="linedotted" height="10" colspan="4"></td></tr>
	  <!--- Field: Unit --->
    <TR>
	
    <td class="labelmedium"><cf_tl id="Unit">:</td>
	<td class="labelmedium" bgcolor="white">
		<cfoutput><b>#Doc.OrganizationUnit#</cfoutput>
	</td>
	<TD class="labelmedium"><cf_tl id="Due date"></td>
    <td class="labelmedium" bgcolor="white">
		<cfoutput><b>#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#</cfoutput>
	</td>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Functional title">:</TD>
    <TD class="labelmedium">
		<cfoutput><b>#Doc.FunctionalTitle#</cfoutput>
	</TD>
	<td class="labelmedium"><cf_tl id="Grade">:&nbsp;</td>
	<td class="labelmedium">
		<cfoutput><b>#Doc.PostGrade#</cfoutput>
	</td>
	</TR>	
		
 	<TR>
	
    <td class="labelmedium"><cf_tl id="Remarks">:</td>
	<TD class="labelmedium">
		<cfoutput><b>#Doc.Remarks#</cfoutput> 
	</TD>
	
	<cfif Doc.FunctionId neq "">

	<cfquery name="Bucket" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM  FunctionOrganization
		WHERE FunctionId = '#Doc.FunctionId#'
	</cfquery>

	<td class="labelmedium"><cf_tl id="VA No">:&nbsp;</td>
    <TD class="labelmedium"> 
	   <cfif Bucket.ReferenceNo neq "">
	   <cfoutput><b><A href="javascript:va('#Bucket.FunctionId#');"><font color="0080FF">#Bucket.ReferenceNo#</a></cfoutput>
	   <cfelse>
	   n/a
	   </cfif>
	</TD>
	</cfif>
	
	</TR>
	
	<tr><td height="1" colspan="4" class="line"></td></tr>	
		
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

<tr><td colspan="4" class="labelmedium" style="padding-left:5px">

<cfif SearchResult.recordCount eq "0">

<b><font color="FF0000"><cf_tl id="Problem">:</font></b> &nbsp;<cf_tl id="No candidates have reached this status." class="Message"> <cf_tl id="Please send back to prior action!" class="Message">

<cfelse>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

    <TR class="labelmedium">
	  <td width="20" height="16"></td>
	  <td width="50"><cfoutput>#checkText#</cfoutput></td>
	  <td width="20"></td>
	  <cfif dialog eq "Test"> 
	  	<td width="70">
	 	 	<cf_tl id="Score"> 
	  	</td>
	  <cfelse>	
	  	<td width="10"></td>
	  </cfif>
   	  <TD><cf_tl id="IndexNo"></TD>
      <TD><cf_tl id="LastName"></TD>
      <TD><cf_tl id="FirstName"></TD>
	  <TD><cf_tl id="Nat."></TD>
      <TD align="center"><cf_tl id="Gender"></TD>
   	  <TD align="center">
	  	<cfif dialog eq "Selection">
			<cf_tl id="Interview">
		<cfelse>
			<cf_tl id="Status">
		</cfif>
		
	  </TD>
	  <!---
	  <TD><cf_tl id="Entered"></TD>
	  --->
  	  <td align="center"><cf_tl id="Memo"></td>
    </TR>	
			
	<tr><td></td><td colspan="10" class="linedotted"></td></tr>
			
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
			
	<cfif Status lt final>
        <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffff'))#" class="navigation_row labelmedium" style="height:35">
    <cfelse> 
	    <TR class="highlight2 navigation_row labelmedium">
    </cfif> 
					
	<cfif ReviewMemo eq "" and final neq "2">
		 <cfset cla = "regular">
		 <cfset clb = "hide">
		
	<cfelse> 
		 <cfset cla = "hide">
		 <cfset clb = "regular">
	</cfif>
	
	<cfset stop = "0">
			
	<td align="center" style="height:22" width="5%">
	
		<cfset state="">
		
		<cfif clb eq "regular">
			<cfset state = "open">
		</cfif>
	
		<cf_img icon="expand" toggle="yes" onclick="more('detail#CurrentRow#')">	
	</td>
	
	<cfset tdSize = "60">
	<cfif Final eq "Track">
		<cfset tdSize = 100>
	</cfif>
	
	<td width="#tdSize#" align="left" >

		<cfset cls = CandidateClass>
				
		 <cfif Final eq "Track">
			
			<select class="regularxl" name="EntityClass_#CurrentRow#">
			
				<cfif Class.recordcount gt 1>
				    <option value="">-- <cf_tl id="to be defined"> --</option>
				</cfif>
				
				<cfloop query = "Class">
				   <option value="#EntityClass#" 
					  <cfif EntityClass eq "#cls#">selected</cfif>>#EntityClassName#
				  </option>
				</cfloop>
			
			</select>
			
		<cfelse>

		    <cfif (PreventSelection.recordcount eq "0" or Validation.recordcount eq "1") and 
			  (Selected.recordcount eq "0" or Status eq "9" or Selected.Status gte "2" or Selected.Status lte "2s")>

				<input onClick="hl(this,this.checked)" class="Radiol" type="checkbox" name="ReviewStatus_#CurrentRow#" id="ReviewStatus_#CurrentRow#" value="#Final#" <cfif Status eq Final>checked</cfif> style="cursor:pointer;">
				
				<cfif dialog eq "Interview">
				
					<img src="#SESSION.root#/Images/pointer2.gif" alt="Interview" 
					onClick     = "interview('#PersonNo#','#Act#')" align="top"
					style="padding-left:15px; cursor:pointer">

				</cfif>
				
			<cfelse>
			
				
				 <!--- can't select a candidate that has been selected ---> 
				 <cfset stop = "1">
			     <font face="verdana" color="FF0000"><cf_tl id="See below"></font>						 	
				 
			</cfif>
		</cfif>
	</td>
	
    <input type="hidden" name="PersonNo_#CurrentRow#" value="#PersonNo#">
	<td width="30" style="padding-left:10px">
		<!--- track for candidate already exists --->
		<cfif (Status eq "2s" and CandidateClass neq "" and final neq "Track")>
			<button class="button3" onClick="javascript:showdocumentcandidate('#Object.ObjectKeyValue1#','#PersonNo#')">
				<img src="#SESSION.root#/Images/contract.gif" alt="Open candidate track" width="13" height="14">
			</button>
		</cfif>
	
	</td>
	<td align="left" >
		<cfif dialog eq "Test">
			<input type="text" 
				name="ReviewScore_#currentrow#" 
				id="ReviewScore_#currentrow#" 
				value="#ReviewScore#" 
				maxlength="3" 
				size="3" 
				class="regularxl"
				style="text-align:right">
		</cfif>
	</td>
	<td><a href ="javascript:ShowCandidate('#PersonNo#')">
		<cfif IndexNoA neq "">#IndexNoA#<cfelse>[<cf_tl id="undefined">]</cfif>
		</a>
	</td>
    <td><a href ="javascript:ShowCandidate('#PersonNo#')"><font color="0080C0">#LastName#</a></td>
	<td>#FirstName#</td>
	<td>#Nationality#</td>
	<td class="labelmedium" align="center"><cfif Gender eq "F"><cf_tl id="Female"><cfelse><cf_tl id="Male"></cfif></td>
	<td class="labelmedium" align="center">
	
	     <cfif Final gt "2">
		 
			<img src="#SESSION.root#/Images/pointer2.gif" 
			    alt="See interview notes" 
				name="a#CurrentRow#" 
				border="0" 
				class="regular" 
				align="middle" 
				style="cursor: pointer;" 
				onClick="interview('#PersonNo#','#Act#')">
			
		  <cfelse>
		  
		    #DescriptionStatus#
			
		  </cfif>
    </td>
	<!---
	<td class="labelmedium">#Dateformat(Created, CLIENT.DateFormatShow)#</td>
	--->
	<td align="center">
	
		<cfset row = CurrentRow>
		
		<cfquery name="Memo" 
			 datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		      SELECT  *
		      FROM     DocumentCandidateReview 
			  WHERE    DocumentNo = '#Object.ObjectKeyValue1#'
			  AND      PersonNo = '#PersonNo#'
			  AND      ActionStatus = '1'
			  AND      ReviewMemo IS NOT NULL
			  AND      ActionCode != '#Act#'
			  ORDER BY Created DESC
	    </cfquery>
							
		<cfloop query="Memo">
		
			<cfif Memo.ReviewMemo neq "">			
				<cf_img icon="expand" toggle="yes" onclick="more('detail#CurrentRow#')">				
			</cfif>			
				
		</cfloop>	
		
	</td>
	
	</tr>
	
	<cfloop query="Memo">
			
		<cfif Memo.ReviewMemo neq "">
			<tr bgcolor="E0F0F3" class="hide" id="doc#Row#_#CurrentRow#">
			<td colspan="2"></td>
			<td colspan="2" class="labelmedium" style="padding-left:10px">#Memo.OfficerFirstName# #Memo.OfficerLastName#</td>
			<td colspan="7" class="labelmedium" style="padding-left:10px">#Memo.ReviewMemo#</td>
			</tr>
		</cfif>
	
	</cfloop>
	
	<cfif Remarks neq "">
		<tr class="navigation_row_child">
			<td colspan="2"></td>
			<td colspan="9" class="labelmedium">#Remarks#</td>
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
			<td colspan="9">
			
		    <table border="0" cellpadding="0" cellspacing="0" width="100%">
				<cfloop query="OtherCandidates">
				<tr><td class="labelmedium" style="padding-left:10px">
				    
					<a href="javascript:showdocument('#OtherCandidates.DocumentNo#')">
					<b><font color="0080C0">#Status#</font></b> <cf_tl id="for">: <font color="800000">#OtherCandidates.Mission#&nbsp;#OtherCandidates.PostGrade# #OtherCandidates.FunctionalTitle#</b></font></a>
			    	</td>
				</tr>
				</cfloop>
			</table>
		</tr>
			
	</cfif>
		
	<cfif stop eq "1">
	
		<tr class="navigation_row_child">
			<td colspan="2"></td>
			<td colspan="9">
		    <table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr><td class="labelmedium" style="padding-left:10px">;
					<a href="javascript:showdocumentcandidate('#Object.ObjectKeyValue1#','#PersonNo#')">
					<b><font color="FF0000"><cf_tl id="Attention">:</font></b> <cf_tl id="This candidate has already a recruitment track." class="Message"></font></a>
			    	</td>
				</tr>
			</table>
		</tr>
			
	</cfif>
	
	<!--- determine the default source for the owner and if not we take the detault of the parameter --->
	
	<tr id="text#currentrow#" class="#clb# navigation_row_child">
		<td></td>
		<td colspan="10" align="center">			
			<!--- PHP we take the default PHP for this owner, if not we take the overall default --->
			<cf_ComparisonView personNo="#PersonNo#" hideperson="Yes" owner="#doc.owner#">					
		</td>		
	</tr>
	
	<cfif dialog eq "Interview">
	
	
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
				AND C.CompetenceId IN (
					#QuotedValueList(BucketCompetencies.CompetenceId)#
				)
			</cfif>
		 	ORDER BY C.ListingOrder
			
		</cfquery>
		
		<tr id="detail#currentrow#" class="hide" valign="tops">
		
		<td align="right" width="40"><img src="#Session.root#/images/join.gif"></td>
		
		<td colspan="10" align="left"> 
		
		<table width="90%" cellspacing="0" cellpadding="0" align="left" style="border:1px solid gray; border-radius:5px;">
			
			<tr>
				<td colspan="3" class="labelmedium" style="padding-left:10px"><b>Interview details</b></td>
			</tr>
			
			<cfif ReviewMemo neq "">
				<tr class="linedotted">
					<td height="19" width="20" align="center"></td>
					<td class="labelmedium" width="20%" style="color:blue">Assessment</td>
					<td>#ReviewMemo#</td>
				</tr>
			</cfif>
			
			<cfloop query="Competencies">
			
			<tr class="linedotted">
			    <td height="19" width="20" align="center"></td>
				<td class="labelmedium" width="20%">
				    <font color="004000">#Description#</font>
				</td>
			    <td style="pading-left:15px;" class="labelmedium"><cfif InterviewNotes eq ""><font color="FF8080">[no comments]</font>
				                       <cfelse>#ParagraphFormat(InterviewNotes)#
									   </cfif></td>
			</tr>
						
			</cfloop>
			
		</table>
		
		</td></tr>
	
	<cfelse>
		
		<tr id="detail#currentrow#" class="#clb#">
			
			<td></td>
			<td colspan="11" style="padding-top:1px">
				<table width="90%" align="center" class="formpadding">
					<tr>
						<td></td>
						<td colspan="10" align="center" style="padding-right:10px">
						<textarea cols="#col#" rows="5" name="ReviewMemo_#currentrow#" class="regular" style="border:1px solid silver;width: 100%; font-size:13px;padding: 3px; border-radius:4px;background-color: f8f8f8;">#ReviewMemo#</textarea>
						</td>		
						</tr>
						
						<tr>
						<td></td>
						<td colspan="10" align="center">
						 
					 	 <input type="Hidden" id="ReviewId_#currentrow#" name="ReviewId_#currentrow#" value="#rowguid#">
				
						 <cf_filelibraryN
							DocumentPath="VacDocument"
							SubDirectory="#rowguid#" 			
							Insert="yes"
							Filter=""	
							LoadScript="No"
							Box="vacdocument_#currentrow#"
							Remove="yes"
							ShowSize="yes">	
				
						</td>		
					</tr>
				</table>
			</td>
			
		</tr>
	
	</cfif>
	
	<tr> <td></td><td colspan="10" class="linedotted" ></td></tr>
		
	</cfoutput>	
	
	<input type="hidden" name="Row" value="<cfoutput>#searchResult.recordcount#</cfoutput>">
	
</table>	

</cfif>

</td></tr>

</table>     

<cfif SearchResult.recordCount gte "1">
	<cfset ajaxonload("doHighlight")>    
</cfif>
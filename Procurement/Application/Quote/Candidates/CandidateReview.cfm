<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfif url.wparam eq "MARK">
 
    <input type="hidden" name="ReviewReset" id="ReviewReset"  value="0">	
	<cfset filter = "'0','1','2','2s'">
	<cfset wfinal = "1">
	
<cfelseif url.wparam eq "INTERVIEW">
		
	<input type="hidden" name="ReviewReset" id="ReviewReset"  value="1">	
	<cfset filter = "'1','2','2s'">
	<cfset wfinal = "2">

<cfelse>
	
	<input type="hidden" name="ReviewReset" id="ReviewReset" value="2">	
	<cfset filter = "'2','2s'">
	<cfset wfinal = "2s">

</cfif>

<cf_dialogStaffing>

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
		
	 itm.className = "highLight3";
	 }else{
		
     itm.className = "";		
	 }
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

function interview(row) {
	se   = document.getElementById("interview"+row)
	if (se.className == "regular") {
	    se.className = "hide"
	} else {
	    se.className = "regular"
	}
}

</script>

</cfoutput>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">

<cfoutput>

<input name="Key1" id="Key1"                 type="hidden"  value="#Object.ObjectKeyValue1#">
<input name="ActionCode" id="ActionCode"     type="hidden"  value="#Action.ActionCode#">
<input name="Dialog" id="Dialog"             type="hidden"  value="#url.wparam#">
<input name="ReviewStatus" id="ReviewStatus" type="Hidden"  value="#wfinal#">
<input name="savecustom" id="savecustom"     type="hidden"  value="Procurement/Application/Quote/Candidates/CandidateReviewSubmit.cfm">

</cfoutput>

<cfquery name="Job" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Job
	WHERE JobNo = '#Object.ObjectKeyValue1#' 
</cfquery>


<cfquery name="Class"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT R.*
	FROM  Ref_EntityClass R, 
	      Ref_EntityClassPublish P
	WHERE R.Operational = '1'
	AND   R.EntityCode   = P.EntityCode 
	AND   R.EntityClass  = P.EntityClass
	AND   R.EntityCode = 'ProcJob'
	
	
	AND     
	         (
			 
	         R.EntityClass IN (SELECT EntityClass 
	                           FROM   Ref_EntityClassOwner 
							   WHERE  EntityCode = 'VacCandidate'
							   AND    EntityClass = R.EntityClass
							   AND    EntityClassOwner IN (SELECT MissionOwner 
		                         						   FROM Ref_Mission 
														   WHERE Mission = '#Job.Mission#')
							   )
							   
			 OR
			
			  R.EntityClass NOT IN (SELECT EntityClass 
	                           FROM   Ref_EntityClassOwner 
							   WHERE  EntityCode = 'VacCandidate'
							   AND    EntityClass = R.EntityClass)							   
			 )			
	
</cfquery>

<cfif url.wparam eq "Interview">

	<!--- reset --->

	<cfquery name="Update"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE JobPerson
		SET    Status                 = '2', 
		       StatusDate             = getDate(), 
			   StatusOfficerUserId    = '#SESSION.acc#',
			   StatusOfficerLastName  = '#SESSION.last#',
			   StatusOfficerFirstName = '#SESSION.first#'
		WHERE  JobNo = '#Object.ObjectKeyValue1#'	
		AND    Status = '1'			
	</cfquery>
  
</cfif>


<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" id="header" class="formpadding">
 
	<tr class="labelmedium">
    <td class="labelit"><cf_tl id="Job">:</td>
	<td class="labelit">
		<cfoutput><b>#Job.JobNo#</cfoutput>
	</td>
	
	<TD class="labelit"><cf_tl id="Due date"></td>
    <td class="labelit">
		<cfoutput><b>#Dateformat(Job.Deadline, CLIENT.DateFormatShow)#</cfoutput>
	</td>
	
	</TR>
			
 	<TR class="labelmedium">	    
	<td class="labelit"><cf_tl id="Remarks">:</td>
	<TD class="labelit"><cfoutput><b>#Job.Casereference#</cfoutput></TD>		
	</TR>
	
			
<cfquery name="Searchresult" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT A.IndexNo, 
		       A.PersonNo, 
			   J.Status, 		       
		   	   A.LastName, 
			   A.FirstName, 
			   A.Nationality, 
			   A.Gender, 
			   A.DOB, 
			   J.PersonClass,
			   J.OfficerLastName, 
			   J.OfficerFirstName,
			   J.Created 
			 			  
	    FROM   JobPerson J,		    
			   Applicant.dbo.Applicant A
		WHERE  JobNo = '#Object.ObjectKeyValue1#'		 
		AND    J.Status IN (#preserveSingleQuotes(filter)#) 	
		AND    J.PersonClass = 'Applicant'
		AND    J.PersonNo = A.PersonNo
		
		UNION 
		
		 SELECT A.IndexNo, 
		       A.PersonNo, 
			   J.Status, 		       
		   	   A.LastName, 
			   A.FirstName, 
			   A.Nationality, 
			   A.Gender, 
			   A.BirthDate as DOB, 
			    J.PersonClass,
			   J.OfficerLastName, 
			   J.OfficerFirstName,
			   J.Created 
			 			  
	    FROM   JobPerson J,		    
			   Employee.dbo.Person A
		WHERE  JobNo = '#Object.ObjectKeyValue1#'		 
		AND    J.Status IN (#preserveSingleQuotes(filter)#) 	
		AND    J.PersonClass = 'Employee'
		AND    J.PersonNo = A.PersonNo	
		
	</cfquery>
		
	<cfset act = Action.ActionCode>

<tr><td colspan="4" class="labelit">

<cfif SearchResult.recordCount eq "0">

&nbsp;<b>
<font color="FF0000"><cf_tl id="Problem">:</font></b> &nbsp;<cf_tl id="No candidates have reached this status." class="Message"> <cf_tl id="Please send back to prior action!" class="Message">

<cfelse>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="white">

	 <TR>
	  <td></td>
   	  <TD></TD>
   	  <TD class="labelit"><cf_tl id="IndexNo"></TD>
      <TD class="labelit"><cf_tl id="LastName"></TD>
      <TD class="labelit"><cf_tl id="FirstName"></TD>
	  <TD class="labelit"><cf_tl id="Nat."></TD>
      <TD class="labelit"><cf_tl id="Gender"></TD>
	  <TD class="labelit"><cf_tl id="Birthdate"></TD>
   	  <TD class="labelit"><cf_tl id="Status"></TD>	 
	  <TD class="labelit"><cf_tl id="Entered"></TD>  	 
    </TR>			
			
	<cfquery name="Mission" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_Mission
		WHERE Mission = '#Job.Mission#'
	</cfquery>
		 	
	<cfoutput query="SearchResult">
	
	<!--- entry in the review table --->
		 
	 <cfquery name="Check" 
	 datasource="appsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM  JobPersonReview
		WHERE JobNo       = '#Object.ObjectKeyValue1#'
		AND   PersonClass = '#PersonClass#'
		AND   PersonNo    = '#PersonNo#'	 
		AND   ActionCode  = '#Act#'  
	 </cfquery>	
	 
	 <cfif Check.Recordcount eq "0">
	 		 
		 <cfquery name="Insert" 
			datasource="appsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO JobPersonReview
				 (JobNo,
				  PersonClass,
				  PersonNo,		  
				  ActionCode,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
			  VALUES ('#Object.ObjectKeyValue1#', 
			          '#PersonClass#',
					  '#PersonNo#',		  
					  '#Act#',
					  '#SESSION.acc#',
					  '#SESSION.last#',		  
					  '#SESSION.first#')
			</cfquery>			
		
			<!--- framework function added by hanno --->
			<cfset showProcess = "0">	
	
	</cfif>
			
	<tr><td height="1" colspan="10" class="linedotted"></td></tr>
	
	<tr><td colspan="10" height="1" bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f5f5f5'))#"></td></tr>
		
	<cfif Status lt wfinal>
         <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f5f5f5'))#">
    <cfelse> 
	      <TR class="highlight3">
    </cfif> 
	   
	<cfif Check.ReviewMemo eq "">
		 <cfset cla = "regular">
		 <cfset clb = "hide">		
	<cfelse> 
		 <cfset cla = "hide">
		 <cfset clb = "regular">
	</cfif>
				
	<cfif url.wparam eq "Interview">	
	    	
			<td align="center" height="25" width="5%">	
		
			<img src="#SESSION.root#/Images/profile.gif" alt="Interview" 
			name="a#CurrentRow#" border="0" class="regular" 
			onMouseOver="document.a#currentrow#.src='#SESSION.root#/Images/document2.gif'" 
			onMouseOut="document.a#currentrow#.src='#SESSION.root#/Images/profile.gif'"
			align="middle" style="cursor: pointer;" 
			onClick="interview('#PersonNo#','#Act#')">
			
			</td>
			
			<td></td>
							        	
	<cfelse>
	
			<td align="center" height="25" width="5%">	
		
				<img src="#SESSION.root#/Images/arrowright.gif" alt="Enter memo" 
				id="text#CurrentRow#Exp" border="0" class="#cla#" 
				align="middle" style="cursor: pointer;" 
				onClick="more('text#CurrentRow#','show')">
				
				<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="text#CurrentRow#Min" alt="Enter memo" border="0" 
				align="middle" class="#clb#" style="cursor: pointer;" 
				onClick="more('text#CurrentRow#','hide')">
			
			</td>
			
			<td width="20">
			
				<cfif url.wparam neq "Select">	
				
				<input onClick="hl(this,this.checked)" 
				   type="checkbox" 
				   name="ReviewStatus_#currentrow#" id="ReviewStatus_#currentrow#" value="#wFinal#" <cfif Status eq wFinal>checked</cfif>>
				   
				 								 
				<cfelse>
				
					<input onClick="hl(this,this.checked)" 
					   type="radio" 
					   name="Selected" id="Selected" value="#currentrow#" <cfif Status eq wFinal>checked</cfif>>					   
					 				 
				</cfif>
								
			</td>
	</cfif>		
	
	<input type="hidden" name="PersonNo_#CurrentRow#" id="PersonNo_#CurrentRow#"    value="#PersonNo#">     
	<input type="hidden" name="PersonClass_#CurrentRow#" id="PersonClass_#CurrentRow#" value="#PersonClass#">
		
	<td class="labelit"><A HREF ="javascript:ShowCandidate('#PersonNo#')">
		<cfif IndexNo neq "">#IndexNo#<cfelse>[<cf_tl id="undefined">]</cfif></a>
	</td>
    <td class="labelit"><A HREF ="javascript:ShowCandidate('#PersonNo#')">#LastName#</a></td>
	<td class="labelit"><A HREF ="javascript:ShowCandidate('#PersonNo#')">#FirstName#</a></td>
	<td class="labelit">#Nationality#</td>
	<td class="labelit" align="center"><cfif Gender eq "F"><cf_tl id="Female"><cfelse><cf_tl id="Male"></cfif></td>
	<td class="labelit" align="center">
	
	      <cfif wFinal gt "2">
		  
			<img src="#SESSION.root#/Images/profile.gif" alt="See interview notes" 
			name="a#CurrentRow#" border="0" class="regular" 
			onMouseOver="document.a#currentrow#.src='#SESSION.root#/Images/document2.gif'" 
			onMouseOut="document.a#currentrow#.src='#SESSION.root#/Images/profile.gif'"
			align="middle" style="cursor: pointer;" 
			onClick="interview('#currentrow#')">
			
		  </cfif>
		  
	</td>	
	<td class="labelit">#Dateformat(Created, CLIENT.DateFormatShow)#</td>	
	<td align="center"></td>
	
	</tr>
	
	<tr><td height="1" colspan="10" class="linedotted"></td></tr>
				
	<cfif url.wparam eq "Interview">
		
		<tr>
		
		   <td colspan="10">
		   		
		   <cf_ApplicantTextArea
			Table           = "Purchase.dbo.JobPersonInterview" 
			Domain          = "JobProfile"
			FieldOutput     = "ProfileNotes"
			Mode            = "Edit"
			Format          = "text"
			height          = "80"
			Key01           = "JobNo"
			Key01Value      = "#Object.ObjectKeyValue1#"
			Key02           = "PersonClass"
			Key02Value      = "#PersonClass#"
			Key03           = "PersonNo"
			Key03Value      = "#PersonNo#">
			   
		   </td>
		</tr>
		
<cfelse>
		
	<tr id="text#currentrow#" class="#clb#">
		<td colspan="10" align="center">
		<textarea style="width:90%" rows="4" class="regular" name="ReviewMemo_#currentrow#">#check.ReviewMemo#</textarea>
		</td>
	</tr>
	
</cfif>

<cfif wFinal gt "2">
	
	<tr id="interview#currentrow#" class="hide">
	<td colspan="10">
	
	   <cf_ApplicantTextArea
				Table           = "Purchase.dbo.JobPersonInterview" 
				Domain          = "JobProfile"
				FieldOutput     = "ProfileNotes"
				Mode            = "View"
				Format          = "text"
				Key01           = "JobNo"
				Key01Value      = "#Object.ObjectKeyValue1#"
				Key02           = "PersonClass"
				Key02Value      = "#PersonClass#"
				Key03           = "PersonNo"
				Key03Value      = "#PersonNo#">
	</td>
	</tr>

</cfif>
			
</cfoutput>
			
<input type="hidden" name="row" id="row" value="<cfoutput>#searchResult.recordcount#</cfoutput>">
	
</table>	

</cfif>

</td></tr>

<tr><td height="6"></td></tr>

</table>





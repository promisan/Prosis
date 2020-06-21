			   
<cfquery name="Doc" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM  Document
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="getWorkOrder" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    OO.ObjectId
	FROM      OrganizationObject AS OO INNER JOIN
              OrganizationObjectAction AS OOA ON OO.ObjectId = OOA.ObjectId
	WHERE     OO.EntityCode = 'VacDocument' 
	AND       OO.Operational = '1' 
	AND       OOA.ActionStatus = '0' 
	AND       OO.ObjectKeyValue1 = '#url.id#'
	ORDER BY OO.Created DESC
</cfquery>	

<cfquery name="DocParameter" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfquery name="Searchresult" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT A.IndexNo as IndexNoA, A.PersonNo, DC.Status, Description, DC.Remarks, 
           DC.OfficerLastName, DC.OfficerFirstName, DC.Created,
		   A.LastName, A.FirstName, A.Nationality, A.Gender, A.DOB, R.Color, 
		   DC.EntityClass as CandidateClass
    FROM   DocumentCandidate DC INNER JOIN Ref_Status R ON DC.Status = R.Status INNER JOIN Applicant.dbo.Applicant A ON A.PersonNo = DC.PersonNo
	WHERE  DocumentNo   = '#URL.ID#' 
	AND    R.Class      = 'Candidate' 
	AND    DC.Status IN ('2s','3')	

</cfquery>

<cfquery name="Mission" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Mission
	WHERE Mission IN (SELECT Mission FROM Vacancy.dbo.Document WHERE DocumentNo = '#URL.ID#')
</cfquery>

<cfif SearchResult.recordCount neq "0" and getWorkOrder.recordcount eq "0">

<table width="99%" align="center" border="0" bgcolor="white" cellspacing="0" cellpadding="0" align="center" id="selected">

<tr class="line"><td style="height:27px;padding-left:8px;font-size:17px;font-weight:bold" class="labelmedium"><cf_tl id="Selected"></td></tr>

<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

    <TR class="labelmedium line">
   	  <TD width="20"></TD>
   	  <TD><cf_tl id="PersonNo"></TD>
      <TD><cf_tl id="LastName"></TD>
      <TD><cf_tl id="FirstName"></TD>
	  <TD><cf_tl id="Nat"></TD>
      <TD><cf_tl id="Gender"></TD>
	  <td><cf_tl id="DOB"></td>
   	  <TD><cf_tl id="Status"></TD>
	  <TD><cf_tl id="Entered"></TD>  	  
    </TR>	
		 	
	<cfoutput query="SearchResult">
	
	<TR bgcolor="white" class="navigation_row labelmedium line">
	
	<td height="21" width="35" align="center" valign="middle">
	
		<cfquery name="Check" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT TOP 1 *
		    FROM   OrganizationObject
			WHERE  ObjectKeyValue1 = '#URL.ID#'
			AND    ObjectKeyValue2 = '#PersonNo#'
			AND    Operational  = 1
			
		</cfquery>
	
	    <cfif Check.recordcount eq "1">
		
			  <button class="button3"  type="button" onClick="showdocumentcandidate('#URL.ID#','#PersonNo#')">
				   <img src="#SESSION.root#/Images/subflow_select.png" name="img5_#currentrow#"
				   width="16" height="14" onMouseOver="document.img5_#currentrow#.src='#SESSION.root#/Images/subflow.png'" 
				   onMouseOut="document.img5_#currentrow#.src='#SESSION.root#/Images/subflow_select.png'"
				   alt="Go to candidate track" border="0" align="absmiddle" 
				   style="border-color: Silver; cursor: pointer">
			   </button>
			   
		</cfif>	   
		   
	</td>
	
	<cfif dob neq "">
		
		<cfset age = #year(now())#-#year(DOB)#>
		<cfif #dayofyear(now())# lt #dayofyear(DOB)#>
		  <cfset age = age -1>
		</cfif>
	
	<cfelse>
	
		<cfset age = "undefined">
		
	</cfif>
	
	<td><A title="Candidate Profile" HREF ="javascript:ShowCandidate('#PersonNo#')">
	<cfif IndexNoA neq "">#IndexNoA#<cfelse>#PersonNo#</cfif></a></td>
    <td><A title="Candidate Profile" HREF ="javascript:ShowCandidate('#PersonNo#')">#LastName#</a></td>
	<td><A title="Candidate Profile" HREF ="javascript:ShowCandidate('#PersonNo#')">#FirstName#</a></td>
	<td>#Nationality#</td>
	<td><cfif Gender eq "F">Female<cfelse>Male</cfif></td>
	<td>#dateFormat(DOB,CLIENT.DateFormatShow)# <cfif DocParameter.MaximumAge lt Age><font color="FF0000">alert&nbsp;</cfif>age:<b>#age#</b></font></td>
	<td>#Description# (#status#) <cfif Status eq "2s" and CandidateClass eq ""><b>:Flow</b></cfif></td>
	<td>#Dateformat(Created, CLIENT.DateFormatShow)#</td>
	<td></td>
	</tr>
				
	<cfif Remarks neq "">
		<tr>
		<td colspan="1"></td>
		<td colspan="8">
		<table><tr><td></td><td><b><font color="gray">#Remarks#</td></tr></table>
		</td>
		</tr>
	</cfif>
		
	<td colspan="9"> 
		
		<cf_DocumentCandidateReview 
			   DocumentNo="#Doc.DocumentNo#" 
			   PersonNo="#PersonNo#" 
			   Owner="#Doc.Owner#"
			   Trigger="Review">		
			   
	</td></tr>
		
	<cfinvoke component = "Service.Process.Applicant.Vacancy"  
	   method           = "Candidacy" 
	   Owner            = "#Mission.MissionOwner#"
	   DocumentNo       = "#URL.ID#" 
	   PersonNo         = "#PersonNo#"	
	   Status           = ""   
	   returnvariable   = "OtherCandidates">	 
	
	<cfif OtherCandidates.recordcount gte 1>
	
	<tr>
	<td stle="height:40px"></td>
	<td colspan="8">
			
	    <table border="0" cellpadding="0" cellspacing="0" width="99%" align="center">
		
		<cfloop query="OtherCandidates">
		<tr>
	
		<cfswitch expression = Status>
		  <cfcase value = "Short-listed" >
			   <cfset cl = "ffffcf">
		  </cfcase>
		  <cfcase value = "Return" >
			   <cfset cl = "009966">
		  </cfcase>
		  <cfcase value = "Selected" >
			   <cfset cl = "FF0000">
		  </cfcase>
		  <cfdefaultcase>
			   <cfset cl = "FF0000">
	  	</cfdefaultcase>
		</cfswitch> 		
				
		<td bgcolor="black" class="labelmedium" style="height:20px;padding:5px">
		<a href="javascript:showdocument('#DocumentNo#','ZoomIn')">
		
		<cfif Status eq "Return" >
		&nbsp;<font color="FF0000">Attention:</font> <font color="FFFFFF">Candidate was <b>#Status#ed</b> from assignment on #DateFormat(Othercandidates.ActionDate,CLIENT.DateFormatShow)#
		<cfelse>		
		&nbsp;<font color="FF0000">Attention:</font> <font color="FFFFFF">Candidate was <b>#Status#</b> for
		<b>#OtherCandidates.Mission#&nbsp;#OtherCandidates.PostGrade# &nbsp;#OtherCandidates.FunctionalTitle#
		</b>
		</cfif>	
		
		</font>
		</a>
	    </td>
		</tr>
		</cfloop>
		</table>
		
	</td></tr>
					
	</cfif>
							
	</cfoutput>
		
</table>	

</td></tr>

<tr class="line"><td height="3"></td></tr>

</table>

</cfif>

<cfset ajaxonload("doHighlight")>

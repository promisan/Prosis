
<cfinclude template="../../../../Vactrack/Application/Document/Dialog.cfm">

<script>

	function jotoggle(jo) {
		
		se = document.getElementById("box_"+jo)		
		co = document.getElementById("content_"+jo)		
		ex = document.getElementById(jo+"Exp")
		co = document.getElementById(jo+"Min")
		
		if (se.className == "regular")
			  {se.className = "hide";
			   ex.className = "regular";
			   co.className = "hide"; }
		else {
		        se.className = "regular"; 			    
				ex.className = "hide";
			    co.className = "regular"; 
			}
	}   
	
</script>	

<!--- Hanno 10/3/2016 
 ideally we do move this to FunctionOrganization / FunctionOrganizationNotes 
 and in ApplicantFunction but with a status to we hide them in Function --->

<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT   A.PersonNo, 
	         A.ApplicantNo, 
			 Ap.FirstName,
			 Ap.LastName,
			 A.JobOpeningID, 
			 
			 (SELECT TOP 1 DocumentNo 
			  FROM   FunctionOrganization 
			  WHERE  ReferenceNo = JobOpeningID) as DocumentNo,
			 
			 A.AppliedDate, 
			 A.Disposition, 
			 V.UN_Department, 
			 V.JOB_CODE AS JobCode, 
			 V.Job_Title as FunctionalTitle, 
			 V.Grade as PostGrade, 
			 V.CategoryName, 
	         V.Posting_Date AS JobOpeningPosted, 
			 V.End_Date AS JobOpeningExpiry, 
			 VT.SpecialNotice, 
			 VT.OrgSetting, 
			 VT.Responsibilities, 
			 VT.Competencies, 
			 VT.Education, 
	         VT.Experience, 
			 VT.Language, 
			 VT.Assessment
	FROM     MergeData.dbo.IMP_ISPVacancyCandidate AS A 
			 INNER JOIN MergeData.dbo.IMP_ISPVacancy AS V 
				ON A.JobOpeningID = V.Job_Opening_ID 
			 INNER JOIN Applicant Ap
				ON A.PersonNo = Ap.PersonNo
			 LEFT OUTER JOIN MergeData.dbo.IMP_ISPVacancyAnnouncement AS VT 
				ON A.JobOpeningID = VT.Job_Opening_ID
	WHERE    A.PersonNo = '#URL.ID#'
	ORDER BY Posting_Date

</cfquery>

<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
 
<tr>
<td width="100%" colspan="1" align="center">
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding navigation_table">

<TR class="line labelit">
	<TD><cf_space spaces="10"><cf_tl id="JO"></TD>
	<td><cf_space spaces="4"></td>
	<TD><cf_tl id="Entity"></TD>	
	<TD><cf_tl id="Posted"></TD>
	<TD><cf_tl id="Expiry"></TD>
	<TD><cf_tl id="Track"></TD>    
    <TD><cf_tl id="Functional title"></TD>	
	<TD><cf_tl id="Applied"></TD>
	<TD><cf_tl id="Disposition"></TD>
	
</TR>

<cfif searchresult.recordcount eq "0">

	<tr>
	<td colspan="10" align="center" class="labelmedium"><cf_tl id="No records found"></td>
	</TR>

</cfif>

<cfoutput query="SearchResult">
	
	<tr class="linedotted labelit navigation_row">
		<td style="padding-left:3px">#JobOpeningID#</td>	
		<td style="padding-left:4px"><cf_space spaces="6">
		
			<cfif Responsibilities neq "" or Education neq "">
			   <img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
					id="#JobOpeningID#Exp" border="0" class="show" 
					align="absmiddle" style="cursor: pointer;" 
					onClick="jotoggle('#JobOpeningID#')">
						
				<img src="#SESSION.root#/Images/icon_collapse.gif" 
					id="#JobOpeningID#Min" alt="" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="jotoggle('#JobOpeningID#')">
			</cfif>		
		</td>
		<TD>#UN_Department#</TD>
		<td>#dateformat(JobOpeningPosted,client.dateformatshow)#</td>
		<td>#dateformat(JobOpeningExpiry,client.dateformatshow)#</td>
		<TD>
			<cfif DocumentNo neq "">
			<!--- check if we have a track enabled for this JO --->
			<a href="javascript:showdocument('#DocumentNo#')" class="navigation_action">
			<font color="0080C0">#DocumentNo#</font>
			</a>	
			</cfif>
		</TD>
		
		<TD style="width:45%">#PostGrade# #FunctionalTitle#</TD>	
		<td>#dateformat(AppliedDate,client.dateformatshow)#</td>
		<TD>#Disposition#</TD>
		
	</TR>
	
	<tr class="hide" id="box_#JobOpeningID#">
	  
	   <td colspan="9" id="content_#JobOpeningId#" class="clsPrintContent_#JobOpeningID#">
	   
	   <table class="formpadding">
	   
	    <tr><td colspan="2">
		
		   <table width="100%">
		   <tr class="line">
		   <td class="labellarge" style="padding-right:10px"><cf_tl id="Job opening"></td>
		   <td style="width:20px;padding-right:10px" align="right">
			<span id="printTitle" style="display:none;">[#ApplicantNo#] #FirstName# #LastName# - [#JobOpeningID#] #PostGrade# #FunctionalTitle#</span>
			
			<cf_tl id="Print" var="1">
						
			<cf_button2 
				mode		= "icon"
				type		= "Print"
				title       = "#lt_text#" 
				id          = "Print"					
				image       = "print.png"
				imageheight	= "16"
				imagewidth	= "16"
				printTitle	= "##printTitle"
				printContent = ".clsPrintContent_#JobOpeningID#">
				
			</td>
			
			</tr>
			</table>	
		
		</td></tr>
	    <tr class="labelit line"><td valign="top">Notice:</td>
		    <td style="font-size:16px">#SpecialNotice#</td></tr>
		  <tr class="labelit line"><td valign="top">Organizational Setting:</td>
		    <td style="font-size:16px">#OrgSetting#</td></tr>	
	   	<tr class="labelit line"><td valign="top" style="padding-right:4px">Responsibilities:</td>
		    <td style="font-size:16px">#Responsibilities#</td></tr>
		<tr class="labelit line"><td valign="top">Competencies:</td>
		    <td style="font-size:16px">#Competencies#</td></tr>
		<tr class="labelit line"><td valign="top">Education:</td>
		    <td style="font-size:16px">#Education#</td></tr>
		<tr class="labelit line"><td valign="top">Experience:</td>
		    <td style="font-size:16px">#Experience#</td></tr>
		<tr class="labelit line"><td valign="top">Language:</td>
		    <td style="font-size:16px">#Language#</td></tr>
	   </table>   
	   
	   </td>
	</tr>

</CFOUTPUT>

</TABLE>

</td>
</tr>

</table>

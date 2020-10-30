
<cfif url.applicantNo neq "">

	<cfquery name="Submission" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM  ApplicantSubmission
		    WHERE ApplicantNo = '#url.applicantno#'
	</cfquery>	
	
	<cfset url.personno = submission.personNo>

</cfif>

<cfparam name="URL.PersonNo" 	default="#CLIENT.PersonNo#">
<cfparam name="URL.ApplicantNo" default="#CLIENT.ApplicantNo#">
<cfparam name="URL.NameStyle" 	default="font-size:18px">

<cfoutput>
	
	<cfquery name="Applicant" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM  Applicant
		    WHERE PersonNo = '#url.personno#'
	</cfquery>	
	
	
	<cfquery name="Nation" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM  Ref_Nation
		    WHERE Code = '#Applicant.Nationality#'
	</cfquery>	
		
	<table width="100%" align="center" bgcolor="f1f1f1">
		
		<tr class="line">
		   <td style="padding-top:1px;height:32px;min-width:900px">
		   		   
		   <table width="100%">
			   <tr class="labelmedium">
			  		
				   <cftry>				   	   
				   <td style="padding-left:20px;color:gray">#ucase(Submission.Source)#</td>					   
				   <td style="font-weight:200;padding-left:10px; #URL.NameStyle#">#Applicant.FirstName#<cfif Applicant.Middlename neq ""> #Applicant.MiddleName#</cfif> #Applicant.LastName# #Applicant.LastName2#</td>
				 
				   <cfcatch>
				   <td style="padding-left:20px; #URL.NameStyle#">#Applicant.FirstName#<cfif Applicant.Middlename neq ""> #Applicant.MiddleName#</cfif> #Applicant.LastName# #Applicant.LastName2#</td>
				 
				   </cfcatch>
				   </cftry>			   
				  
				   <td style="padding-left:30px;color:gray"><cf_tl id="Index No"></td>
				   <td style="padding-left:5px"><cfif Applicant.IndexNo eq "">n/a<cfelse>#Applicant.IndexNo#</cfif></td>
				   <td style="padding-left:20px;color:gray"><cf_tl id="DOB"></td>
				   <td style="padding-left:5px">#dateformat(Applicant.DOB,CLIENT.DateFormatShow)# <cfif Applicant.RecordCount gt 0>(#INT(dateDiff('m', Applicant.DOB, now())/12.0)#)</cfif></td>
				   <td style="padding-left:20px;color:gray"><cf_tl id="Nationality"></td>
				   <td style="padding-left:5px">#Nation.Name#</td>		
				   <!---		  				 	   
				   <td style="padding-left:20px;color:gray"><cf_tl id="eMail"></td>
				   <td style="padding-left:5px" width="20%">#Applicant.eMailAddress#</td>				  
				   --->

			   </tr>
		   </table>
		   </td>
		</tr>
		
	</table>
	
</cfoutput>	
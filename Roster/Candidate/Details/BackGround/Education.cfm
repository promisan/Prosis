
<!--- -------------------------------------- --->
<!--- ------ 20/4/2020 used for portal ----- --->
<!--- -------------------------------------- --->

<cfparam name="URL.entryScope"   default="Backoffice">
<cfparam name="url.section" 	 default="">
<cfparam name="URL.source"       default="Manual">  
<cfparam name="URL.Topic"        default="Employment"> 
<cfparam name="url.applicantno"  default="">
<cfparam name="url.owner"         default="">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Parameter
</cfquery>

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT      A.*, 
	            F.ExperienceFieldId,
			    (SELECT Name FROM System.dbo.Ref_Nation WHERE Code = A.OrganizationCountry) as CountryName,
			     <!---
			     F.ReviewLastName, 
			     F.ReviewFirstName,
			     F.ReviewDate,
			     --->
		         F.Status as StatusDomain,
	             R.Description,
		         R.Status as TopicStatus,
		         R.ExperienceClass,
		         S.Source
			  
	FROM         ApplicantSubmission S INNER JOIN
	             ApplicantBackground A ON S.ApplicantNo = A.ApplicantNo LEFT OUTER JOIN
	             Ref_Experience R INNER JOIN
	             ApplicantBackgroundField F ON R.ExperienceFieldId = F.ExperienceFieldId ON A.ExperienceId = F.ExperienceId AND 
	             A.ApplicantNo = F.ApplicantNo
			  
    WHERE        S.PersonNo = '#URL.ID#'
	AND          S.Source   = '#url.source#'
	<cfif url.applicantno neq "">
		AND      S.ApplicantNo = '#url.applicantno#'
	</cfif>	
	<!--- AND   S.Source IN ('#CLIENT.Submission#','#Parameter.PHPSource#','Manual') --->
	AND          A.Status != '9'
	AND          A.ExperienceCategory = '#URL.ID2#'
	ORDER BY     ExperienceCategory, ExperienceStart DESC	
</cfquery>

<cfoutput>

  <script language="JavaScript">
	  
	function edadd(cls,src) {
		  ptoken.location('#SESSION.root#/Roster/Candidate/Details/Background/BackgroundEntry.cfm?owner=#url.owner#&applicantno=#url.applicantno#&section=#url.section#&entryScope=#url.entryScope#&Topic='+cls+'&ID=&ID1=#URL.ID#&ID2='+cls+'&source='+src)
	}  
	
	function ededit(expno,cls,src) {
		  ptoken.location('#SESSION.root#/Roster/Candidate/Details/Background/BackgroundEntry.cfm?owner=#url.owner#&applicantno=#url.applicantno#&section=#url.section#&entryScope=#url.entryScope#&Topic='+cls+'&ID=' + expno + '&ID1=#URL.ID#&ID2='+cls+'&source='+src)
	}
	
	function edpurge(expno,src) {
	
	  <cf_tl id="Do you want to remove this record" var="1">	
	  if (confirm("#lt_text# ?")) {
		 ptoken.location('#SESSION.root#/Roster/Candidate/Details/Background/BackgroundPurge.cfm?owner=#url.owner#&applicantno=#url.applicantno#&section=#url.section#&entryScope=#url.entryScope#&ID=#URL.ID#&ID2=#URL.ID2#&Topic=#URL.Topic#&ID0=' + expno + '&source='+src)
	  }			  
	}

</script>

</cfoutput>

<cfif url.entryScope eq "BackOffice">

	<cfinvoke component="Service.Access"  
	 method="roster" 
	 returnvariable="AccessRoster"
	 role="'AdminRoster','CandidateProfile'">
	 
<cfelseif url.entryScope eq "Portal">

	<cfset AccessRoster = "ALL">

</cfif>  

<cfquery name="getSource" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Source
	WHERE    Source = '#url.source#'
</cfquery>

<cfquery name="qCheckOwnerSection" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ApplicantSectionOwner
	WHERE    Owner = '#URL.Owner#'
	AND      Code  = '#URL.Section#' 
</cfquery>

<cfif qCheckOwnerSection.recordcount eq 0>
	<cfset AccessLevelEdit = "2">
<cfelse>	
	<cfset AccessLevelEdit = qCheckOwnerSection.AccessLevelEdit>
</cfif>	

<!--- PMD comment we can use the source of the applicantsubmission to make it show
in edit mode, here the source = Compendium --->

<!--- ---------------------------------- --->
<!--- determine if we can edit this form --->
<!--- ---------------------------------- --->

<cfset mode = "read">

<cfif getSource.operational eq "1" and getSource.allowedit eq "1">
			
 	<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
		
		<cfif AccessLevelEdit eq "2">
		
			<cfset mode = "edit">
		
		</cfif>
		
	</cfif>	

</cfif>

<table width="96%" bgcolor="white" align="center" class="navigation_table">

<tr><td height="5"></td></tr>

<cfoutput>
	
	<cfif URL.Topic neq "All">
	
		<tr><td height="30" colspan="6" class="labellarge" style="padding-left:8px;padding-bottom:4px">
				
		  <cfif mode eq "edit">		 
		
	  		  <cf_tl id="Add record" var="1">
		  
			  <cfswitch expression="#URL.ID2#">
			  <cfcase value="School">
			   <A href="javascript:edadd('School','#url.source#')"><cfoutput>#lt_text#</cfoutput></a>		   
			  </cfcase>
			  <cfcase value="University">
			   <A href="javascript:edadd('University','#url.source#')"><cfoutput>#lt_text#</cfoutput></a>		  
			  </cfcase>
			  <cfcase value="Training">
			   <A href="javascript:edadd('Training','#url.source#')"><cfoutput>#lt_text#</cfoutput></a>		 
			  </cfcase>
			  </cfswitch>
			  
		  </cfif>  
		  
		</td></tr>
			
	</cfif>

</cfoutput>

<cfif detail.recordcount eq "0">
	<tr>	
	<td colspan="6" class="labelmedium" style="height:30px" align="center"><cf_tl id="No records found"></td>
	</TR>
</cfif>
  
<cfoutput query="Detail" group="ExperienceId">

	<tr class="navigation_row">
	
	<td style="padding-left:4px" class="labelmedium">
	
	   <cfif URL.Topic eq "All"> 
	   
	   <cfelse>
	   
	   	   <cfif mode eq "edit"> 	
	   		       
			   <table>
				   <tr>
					   <td><cf_img icon="edit" navigation="yes" onclick="javascript:ededit('#ExperienceId#','#ExperienceCategory#','#Source#')"></td>					    
					   <td style="padding-top:3px;padding-left:5px"><cf_img icon="delete" onclick="javascript:edpurge('#ExperienceId#','#Source#')"></td>				
				   </tr>	
			   </table>
				
		   </cfif> 
	   
	   </cfif>
	   
	</td>	
	<td class="labelmedium" style="font-size:25px;width:70%" colspan="4">
	
		<table>
		<tr class="labelmedium"><td style="font-size:21px">#OrganizationName#</td></tr>
		<tr>
			<td class="labelmedium" style="padding-left:5px">#DateFormat(ExperienceStart,"YYYY/MM")#
			- <cfif ExperienceEnd lt "01/01/40" or ExperienceEnd gt "01/01/2030"><cf_tl id="Todate"><cfelse>#DateFormat(ExperienceEnd,"YYYY/MM")#</cfif>&nbsp;#OrganizationCity# #CountryName#</td>
		</tr>
		</table>
	
	</td>
		
	<cfif Parameter.PHPSource eq Source>
		<td class="labelit" align="center">#Source# <cfif updated neq "">:#dateformat(updated,CLIENT.DateFormatShow)#</cfif></td>
	<cfelse>
		<td class="labelit" align="right">#Source# (#dateformat(updated,CLIENT.DateFormatShow)#)</td>
	</cfif>
	</tr>

	<cfif Remarks neq ExperienceDescription and remarks neq "">
		<tr class="labelit navigation_row_child">
		<td></td>
		<td class="labelit" colspan="6">#Remarks#</td>
		</tr>
	</cfif>
	
	<cfif OrganizationAddress neq "">
		<tr class="labelit navigation_row_child">
		<td></td>
		<td class="labelit" colspan="6">#OrganizationAddress#</td>
		</tr>
	</cfif>
	
	<cfif OrganizationTelephone neq "">
		<tr class="labelit navigation_row_child">
		<td></td>
		<td class="labelit" colspan="6"><cf_tl id="Tel">:#OrganizationTelephone#</td>
		</tr>
	</cfif>
	
	<cfif Status neq "9">
	    <tr class="labelit navigation_row_child">
	<cfelse>	
	    <tr bgcolor="FED7CF" class="labelit navigation_row_child">	
	</cfif>
		<td></td>
		<td colspan="6" style="padding-left:10px">			
		 <cfif OrganizationClass neq ""><b>#OrganizationClass#&nbsp;</b></cfif>
		 <cfif ExperienceDescription neq ""> - #ExperienceDescription#</cfif>
		 <cfif SalaryCurrency neq "">
		    #SalaryCurrency# &nbsp;&nbsp;#NumberFormat(SalaryStart,'_,_')# - &nbsp;#NumberFormat(SalaryEnd,'_,_')#
		</cfif>
		</td>
		
	</tr>

    <cfif TopicStatus eq "1">
		
		<tr class="labelit navigation_row_child">
	
		    <td></td>		    
		    <td colspan="6" style="padding-left:10px">
			
			<cfoutput>
			#Description#
			<cfif CLIENT.submission neq "Skill">
			<cfif StatusDomain is "0">(Pd)</cfif>
			<cfif StatusDomain is "1">(Cl)</cfif>
			<cfif StatusDomain is "9">(Ca)</cfif>
			</cfif>		
			|
			</cfoutput>
			
			</td>	
				
		</TR>
	
	</cfif>	
	
	<tr><td style="height:10px"></td></tr>
	<tr class="line"><td colspan="6"></td></tr>	
	<tr><td style="height:10px"></td></tr>

</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>

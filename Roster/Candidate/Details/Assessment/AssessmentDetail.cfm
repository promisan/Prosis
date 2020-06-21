
<cfparam name="url.pdfform" default="">

<cfif url.source eq "">
 
	<cfquery name="Source" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_Source C
	  WHERE   AllowAssessment = 1
	</cfquery>  

	<cfset URL.source = "#source.source#">
	
</cfif>

<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
	WHERE Identifier = 'A'
	</cfquery>
	
<cfif url.pdfform neq "">

	<!--- check folder --->	
	
    <cfquery name="Path" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Attachment
	WHERE DocumentPathName = '#Parameter.DocumentLibrary#'
	</cfquery>
	
	<cfif Path.documentfileserverroot neq "">
	   <cfset pt = Path.documentfileserverroot>
	<cfelse>
	   <cfset pt = SESSION.rootDocumentPath>
	</cfif>
	
	<cftry>
	
		<cfpdfform action = "read"
			source = "#pt#\#Parameter.DocumentLibrary#\#URL.ID#\#url.pdfform#"
			result = "pdfdata"/>
		
		<cfquery name="Code" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT    *
			FROM      dbo.Ref_Assessment
			ORDER BY ListingOrder
		</cfquery>
		
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT * FROM ApplicantAssessment
		WHERE PersonNo = '#URL.ID#'
		AND Owner      = '#URL.Owner#'
		</cfquery>
		
		<cftransaction>
		
			<cfquery name="Clear" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				DELETE FROM ApplicantAssessmentDetail
				WHERE AssessmentId = '#Check.AssessmentId#'
				AND Source = '#URL.Source#'
			</cfquery>	
					
			<cfoutput query="Code">
			
			
				<cftry>

				<cfif StructFind(pdfdata, "#SkillCode#") eq "Yes">
							
					<cfquery name="Insert" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ApplicantAssessmentDetail 
					         (AssessmentId, 
							 Owner,
							 Source,
							 SkillCode,
							 OfficerUserId,
							 OfficerLastName, 
							 OfficerFirstName)
					  VALUES ('#Check.AssessmentId#', 
					          '#URL.Owner#',
							  '#URL.Source#',
							  '#SkillCode#',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
					 </cfquery>
					 								
				</cfif>
				
				<cfcatch></cfcatch>
				</cftry>
							
			</cfoutput>
			
		</cftransaction>	
		
		
		<cfcatch>
			
			<table width="100%"><tr><td align="center" class="labelit">
				<font size="2" color="FF0000">
				<b>&nbsp;&nbsp;<cf_tl id="Problem: content of"> <u><cfoutput>#URL.PDFForm#</cfoutput></u> <cf_tl id="could not be read"> !</font>
			</td></tr></table>
			
		</cfcatch>
	
	</cftry>
	
	
</cfif>

<cfinvoke component="Service.Access"  
 method="roster" 
 returnvariable="AccessRoster"
 role="'AdminRoster','CandidateProfile'">

<!--- check record --->
	  
<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   ApplicantAssessment
  WHERE  PersonNo  = '#URL.ID#'
  AND    Owner     = '#URL.Owner#'
</cfquery>

<cfif check.recordcount eq "0">

	<cf_assignId>

	<cfset id = rowguid>

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  INSERT INTO ApplicantAssessment
		         (PersonNo, 
				  Owner, 
				  AssessmentId,
				  OfficerUserName,
				  OfficerlastName,
				  OfficerFirstName)
	  VALUES ('#URL.ID#',
	          '#URL.Owner#',
			  '#id#',
			  '#SESSION.acc#','#SESSION.last#', '#SESSION.first#')
	</cfquery>
	
<cfelse>

	<cfset id = check.assessmentid>

</cfif>
  
<cfquery name="Assessment" 
datasource="AppsSelection" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   R1.Description AS CategoryDescription, R.SkillCode, R.SkillDescription, A.*
		FROM     Ref_AssessmentCategory R1 INNER JOIN
                 Ref_Assessment R ON R1.Code = R.AssessmentCategory INNER JOIN
                 ApplicantAssessment P INNER JOIN
                 ApplicantAssessmentDetail A ON P.AssessmentId = A.AssessmentId ON R.Owner = A.Owner AND R.SkillCode = A.SkillCode AND P.Owner = '#URL.Owner#' AND 
                 P.PersonNo    = '#URL.ID#'
		WHERE    R.Owner       = '#URL.Owner#'	
		AND      R.Operational = 1	  
		ORDER BY A.Source, R.AssessmentCategory, R.ListingOrder			
</cfquery>	

<cfif Assessment.recordcount eq "0" or URL.ID2 eq "Edit">

	    <cfinclude template="AssessmentEntry.cfm">
		
<cfelse>
  						
	<table width="98%" align="center">
	
	<tr>
	    <td width="100%" colspan="2">
		
	    <table width="100%" class="formpadding">
		 
		<tr>
		<td class="labellarge" height="23"><cf_tl id="Job Assessment"> <cfoutput>#url.owner#</cfoutput></b></td>
		<td colspan="3" align="right">
		  <cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
			     <input class="button10g" type="button" onclick="load()" name="editcompetence" value="Update">
		  </cfif>	 
		</td>	
		</tr> 
		
		<tr><td height="1" colspan="4" class="linedotted"></td></tr>
				
	<cfif Assessment.recordcount eq "0">
					
		<tr>
		<td colspan="4" align="center" class="labelit"><b><cf_tl id="No records found"></b></td>
		</TR>
	
	</cfif>
	
	<tr><td colspan="4" height="30">
		
	 <cf_filelibraryN
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#URL.ID#" 
		Filter="#URL.Owner#_#Source#"
		LoadScript="No"
		Insert="No"
		Remove="No"
		ShowSize="yes">	
	
	</td></tr>
	
	<cfoutput query="Assessment" group="Source">	
			
		<cfquery name="Source" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM Ref_Source C
		  WHERE Source = '#Source#'
		</cfquery>  
		
		<tr><td height="6"></td></tr>			
		<tr><td class="line" colspan="4" class="labellarge">#Source.Description#</font></td></tr>
				
		<cfoutput>				
			<TR class="labelit">
				<td style="padding-left:14px">#CategoryDescription#</td>
			    <td>#SkillDescription#</td>
				<td>#Remarks#</td>
				<td align="right">#OfficerFirstName# #OfficerLastName# #DateFormat(Created,CLIENT.DateFormatShow)#</td>				
			</TR>		
	    </cfoutput>
	
	</cfoutput>
	
	</table>
	
	</td>
	
	</tr>
	
	</table>
		
</cfif>

<script>
	Prosis.busy('no')
</script>

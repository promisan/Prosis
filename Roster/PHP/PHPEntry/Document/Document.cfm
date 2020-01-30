
<cfparam name="URL.status" 			default=0>
<cfparam name="URL.section"         default=""> 
<cfparam name="URL.entryScope"      default="Backoffice"> 
<cfparam name="URL.ApplicantNo"     default="">
<cfparam name="URL.ShowHeader"      default="Yes">

<cfset alias = "appsSelection">

<cfif URL.ApplicantNo eq "">

    
	<cfset URL.ApplicantNo = session.ApplicantNo>
				
	<cfquery name="qApplicant" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PersonNo
		FROM   ApplicantSubmission R 
		WHERE  ApplicantNo = '#URL.ApplicantNo#' 
		AND    SourceOrigin is not null		
	</cfquery>	
	

	<cfset url.id = qApplicant.PersonNo>

<cfelse>

	<cfquery name="qApplicant" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PersonNo 
		FROM   ApplicantSubmission R 
		WHERE  ApplicantNo = '#URL.ApplicantNo#' 
	</cfquery>	

	<cfset URL.ID = qApplicant.PersonNo>
		
</cfif>	

<cfoutput>

<script language="JavaScript">

	function issuedocument(persno) {	
	    ptoken.location("#session.root#/Roster/Candidate/Details/Document/DocumentEntry.cfm?owner=#url.owner#&ApplicantNo=#URL.ApplicantNo#&section=#url.section#&entryscope=#url.entryscope#&ID=" + persno);
	}

	function edit(persno,docid) {
	    ptoken.location("#session.root#/Roster/Candidate/Details/Document/DocumentEdit.cfm?owner=#url.owner#&ApplicantNo=#URL.ApplicantNo#&section=#url.section#&entryscope=#url.entryscope#&ID=" + persno+"&ID1="+docid);
	}

	function reloadForm(persno,st) {	   	   
	    ptokenlocation("#session.root#/Roster/Candidate/Details/Document/Document.cfm?owner=#url.owner#&ApplicantNo=#URL.ApplicantNo#&section=#url.section#&ID="+ persno + "&entryscope=#url.entryscope#&status=" + st);
		
	}	
	
</script>

</cfoutput>

<cfif URL.Status eq "0">
      <cfset condition = "">
<cfelseif URL.Status eq "1">
      <cfset condition = "AND (AD.DateExpiration > #now()# or AD.DateExpiration is NULL)">
<cfelse>	  
	  <cfset condition = "AND AD.DateExpiration < #now()#">
</cfif>

<cfquery name="Search" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   AD.*, PC.PostalName
		FROM     ApplicantDocument AD LEFT OUTER JOIN Employee.dbo.Ref_PostalCode PC ON	
			     PC.Code = AD.IssuedPostalCode
		WHERE    AD.PersonNo = '#URL.Id#'
		         #preserveSingleQuotes(condition)#
		ORDER BY AD.DocumentType, AD.DateEffective DESC				
</cfquery>

<cfquery name="Parameter" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Parameter
</cfquery>

<cf_screentop height="100%" scroll="no" html="No" jQuery="Yes">

<cfinclude template="../NavigationCheck.cfm">

<table width="95%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
<cfif URL.Owner eq "" or url.entryscope eq "backoffice">

	<!--- backoffice --->	
	<tr>
		<td>				
		<cfinclude template="../../../Candidate/Details/Applicant/Applicant.cfm">				
		</td>	
	</tr>	
	
<cfelseif url.entryscope eq "portal">

	<!--- backoffice --->	
	<cfif URL.ShowHeader eq "Yes">
	<tr>
		<td>		
		<cfinclude template="../PHPIdentity.cfm">				
		</td>	
	</tr>	
	</cfif>

<cfelse>

	<!--- profile navigation --->
	<tr><td height="10"></td></tr>	
	<tr><td colspan="2" style="padding-top:5px;padding-left:14px"><cf_navigation_header1 alias="appsSelection" toggle="Yes"></td></tr>	
			
</cfif>

<tr><td style="padding-top:10px;padding-left:35px;padding-right:30px" height="100%">
	
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

  <cfoutput>
  
	  <tr>  
	     <td class="labelmedium" style="padding-top:9px;padding-right:4px;font-size:20px">
		    <a href="javascript:issuedocument('#URL.ID#')"><font color="0080C0"><cf_tl id="Add document"></a>		
			<cf_space spaces="40">
	    </td>
		
	    <td height="44" align="right" >
		    <table>
			<tr>
			
			<td class="labellarge" style="font-size:25px;padding-right:1px"></td>
			<td style="padding-left:4px" class="labelmedium"><input type="radio" name="Status" id="Status" class="radiol" value="0" onClick="reloadForm('#url.id#','0')" <cfif URL.Status eq "0">checked</cfif>></td><td style="padding-left:4px;padding-right:6px" class="labelmedium"><cf_tl id="All"></td>
			<td style="padding-left:4px" class="labelmedium"><input type="radio" name="Status" id="Status" class="radiol" value="1" onClick="reloadForm('#url.id#','1')" <cfif URL.Status eq "1">checked</cfif>></td><td style="padding-left:4px;padding-right:6px" class="labelmedium"><cf_tl id="Current"></td>
			<td style="padding-left:4px" class="labelmedium"><input type="radio" name="Status" id="Status" class="radiol" value="2" onClick="reloadForm('#url.id#','2')" <cfif URL.Status eq "2">checked</cfif>></td><td style="padding-left:4px;padding-right:6px" class="labelmedium"><cf_tl id="Expired"></td>
			</tr>
			</table>
		</td>		
	   
	   </tr>
  
   </cfoutput>
  
   <tr><td colspan="2" class="linedotted"></td></tr>
    
   <tr>
  	<td height="100%" width="100%" colspan="3" valign="top">
	
				
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		
			<tr class="labelit linedotted">
		    	<td width="5%" height="20" align="center"></td>
				<td width="18%"><cf_tl id="Type"></TD>
				<td width="10%"><cf_tl id="DocumentNo"></TD>
				<td width="20%"><cf_tl id="Issued"></td>
		    	<td width="10%"><cf_tl id="Effective"></td>
				<td width="10%"><cf_tl id="Expiration"></TD>
				<td width="20%"><cf_tl id="Remarks"></TD>					
			</tr>
		
			<cfset last = '1'>
									
			<cfoutput query="Search">
				
				<cfif DateExpiration lt now() and DateExpiration neq "">
				
					<tr bgcolor="yellow" class="labelit linedotted navigation_row labelmedium">
					<td align="center">
					
					    <img src="#SESSION.root#/Images/caution.gif" alt="" name="img0_#currentrow#" 
							  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
							  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/caution.gif'"
							  style="cursor: pointer;" alt="" width="11" height="11" border="0" align="middle" 
							  onClick="edit('#URL.ID#','#DocumentId#')">
					</td>	
				
				<cfelse>
				
					<TR class="linedotted navigation_row labelmedium" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F9F9F9'))#">
					<td align="center">	
						 <cf_img icon="edit" navigation="Yes" onClick="javascript:edit('#URL.ID#','#DocumentId#')">	
					</td>	
				
				</cfif>
				
				<cfparam name="attNo" default="0">
										
					<cfquery name="get" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  * 
					    FROM    Ref_DocumentType
					    WHERE   DocumentType = '#DocumentType#'	
					</cfquery>
						
					<td><cf_tl id="#get.Description#"></TD>
					<td>#DocumentReference#</TD>
					
					<cfquery name="get" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  * 
					    FROM    Ref_Nation
					    WHERE   Code = '#IssuedCountry#'	
					</cfquery>
					
					<td>#PostalName# #get.Name#</td>
					<td>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
					<td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
					<td>#Remarks#</td>					
				</tr>
			
				<cf_filelibraryCheck
			    	DocumentURL  = "#Parameter.DocumentURL#"
					DocumentPath = "#Parameter.DocumentLibrary#"
					SubDirectory = "#PersonNo#" 
					Filter       = "#left(DocumentId,8)#">
											
				<cfif files gte "1">
				
					<tr>			
					<td colspan="7" style="padding-left:30px">
						<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
						  <tr><td width="100%">
						  
						 	 <cf_filelibraryN
									DocumentPath="#Parameter.DocumentLibrary#"
									SubDirectory="#PersonNo#" 
									Filter="#left(documentid,8)#"
									Insert="no"							
									Remove="no"
									Listing="yes">
									
						  </td></tr>
						</table>
					</td>		
					</tr>					
					<tr><td style="height:4px"></td></tr>
				
				</cfif>		
			
			</cfoutput>
			
		</TABLE>
	
	</td>
	</tr>

	<tr><td height="1" class="linedotted"></td></tr>
	
	<tr>
		<td align="center" colspan="2" width="100%" style="padding-top:5px;">
			<cfinclude template="../NavigationSet.cfm">			
			<cf_Navigation
			 Alias         = "AppsSelection"
			 TableName     = "ApplicantSubmission"
			 Object        = "Applicant"
			 ObjectId      = "No"
			 Group         = "PHP"
			 Section       = "#URL.Section#"
			 SectionTable  = "Ref_ApplicantSection"
			 Id            = "#URL.ApplicantNo#"
			 BackEnable    = "#BackEnable#"
			 HomeEnable    = "#NextEnable#"
			 ResetEnable   = "0"
			 ResetDelete   = "0"	
			 ProcessEnable = "0"
			 NextEnable    = "#NextEnable#"
			 NextSubmit    = "0"
			 OpenDirect    = "0"
			 SetNext       = "#setNext#"
			 NextMode      = "#setNext#"
			 IconWidth 	  = "32"
			 IconHeight	  = "32">
		</td>
	</tr>

</table>

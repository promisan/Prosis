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
<!---
 template to generate a report as a file to be used for
 instant : user selects from my reports the mail option
 distribution : batch eMail
--->

<!--- ------------------------------- --->
<!--- Condition as defined by SQL.cfm --->
<!--- ------------------------------- --->

<cfif Condition eq "9">
	<cfabort>
</cfif>

<!--- identify layout --->
<cfquery name="Report" 
     datasource="AppsSystem">
	 SELECT     R.*, U.*, 
	            L.TemplateReport, 
				L.LayoutClass, 
				L.LayoutName, 
				L.LayoutTitle,
				L.LayoutSubtitle,
				L.OutputEncryption, 
				L.OutputPermission, 
				L.PasswordOwner, 
				L.PasswordUser
	 FROM       UserReport U, 
	            Ref_ReportControlLayout L, 
				Ref_ReportControl R
	 WHERE      ReportId    = '#URL.ReportId#' 
	 AND        R.ControlId = L.ControlId 
	 AND        U.LayoutId = L.LayoutId
</cfquery>

<!--- identify layout --->
<cfquery name="Layout" 
     datasource="AppsSystem">
	 SELECT     L.*, R.*, O.eMailAddress
	 FROM       Ref_ReportControlLayOut L, 
	            Ref_ReportControl R, 
	 			Ref_SystemModule M, 
				Organization.dbo.Ref_AuthorizationRoleOwner O	
	 WHERE      LayoutId = '#Report.LayoutId#'
	 AND        R.ControlId = L.ControlId 
	 AND        R.SystemModule = M.SystemModule
	 AND        M.RoleOwner = O.Code 
</cfquery>

<HTML><HEAD><TITLE>Requested report</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="CLIENT.MailTemplate" 
         default="MailTemplate/MailTemplate1.cfm">

<cfif URL.mode eq "Instant">
	<cf_Wait text="Please wait while I am preparing your report">
</cfif>	

<cfparam name="currentrow" default="#round(Rand()*500)#">
<cfset FileNo = currentRow>

<cfif Report.TemplateReport neq "Excel">

	<cfif not FileExists("#reppath#/#Report.TemplateSQL#")>
		 <cfif url.mode eq "Form" or url.Mode eq "Link">
	 		<cf_message message = "I am not able to locate the SQL query script for this report. <p></p>File: </b></u> ../#Layout.ReportPath#/#Layout.TemplateSQL#."
			 return = "no">
			<cfabort> 
		 </cfif>			 
	</cfif>

	<cfif not FileExists("#reppath#/#Report.TemplateReport#")>
		
		<cfif URL.mode neq "Form" or URL.Mode eq "Link">
			 <cf_message message = "I am not able to locate the report template.<p></p> Template : </b></u>../#reportPath#/#Layout.TemplateReport#."
			  return = "no">
	    </cfif>
        <cfabort>	
			
	</cfif>
	
</cfif>

<cfif Report.TemplateReport eq "Excel">

<!--- disabled Dev : the purpose was to generate and attach excels

<cfparam name="ControlId" default="#URL.ControlId#">

	<cfset attach = "">

	<cfquery name="Output" 
    	 datasource="AppsSystem">
		 SELECT     *
		 FROM       Ref_ReportControlOutput O
		 WHERE      ControlId = '#Layout.controlId#' 
		 AND Operational = 1
		 ORDER BY ListingOrder 
	</cfquery>
							
	<cfoutput query = "Output">
	
	    <cftry> 
	
		<cfset table = Evaluate("VariableName")>
		<cfset table = Evaluate("Attributes." & #table#)>
						
		<cfquery name="Fields" 
		datasource="#DataSource#">
		SELECT   C.name 
	    FROM     SysObjects S, SysColumns C 
		WHERE    S.id = C.id
		AND      S.name = '#table#'	
		ORDER BY C.ColId
		</cfquery>

		<cfset fld = "">
		<cfloop query="Fields">
		 <cfif #fld# eq "">
		    <cfset fld="#Fields.name#">
		 <cfelse>
		    <cfset fld="#fld#,#Fields.name#"> 	
		 </cfif>
		</cfloop>
		
		<cfquery name="SearchResult" 
		datasource="#DataSource#">
		SELECT *  FROM #table# 
		</cfquery>
		
		<!--- addition spreadsheet stuff header/footer --->
		
		<cfoutput>
		<cfsavecontent variable="begin">
		<table width="100%" bgcolor="lightgray" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="#Fields.recordcount#">
			<table width="100%">
			<tr>
			   <td colspan="#Fields.recordcount#"><u><b><font face="Trebuchet MS" size="3">#SESSION.welcome# </font></b></td>
			</tr>
			<tr>
			   <td colspan="#Fields.recordcount#"><font face="Trebuchet MS" size="2">#OutputName#</td>
			</tr>
			<tr>
			   <td colspan="#Fields.recordcount#"><font face="Trebuchet MS" size="1">dd: #DateFormat(now(), APPLICATION.DateFormatShow)#</td>
			</tr>
			</table>
		</td></tr>
		</table>
		</cfsavecontent>
		
		<cfsavecontent variable="end">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="#Fields.recordcount#">
			<table width="100%">
			<tr>
			   <td>#outputMemo#</td>
			</tr>
			</table>
		</td></tr>
		</table>
		</cfsavecontent>
		
		</cfoutput>
				
		<cfif not DirectoryExists("#SESSION.rootPath#\CFReports\CFRStage\#SESSION.acc#\")>

		   <cfdirectory 
		     action="CREATE" 
             directory="#SESSION.rootPath#\CFReports\CFRStage\#SESSION.acc#\">

		</cfif>
		
		<cfset fileName = replace(#OutputName#,"  ","_","ALL")>
		<cfset fileName = replace(#fileName#," ","_","ALL")>
		<cfset fileName = replace(#fileName#,"+","_","ALL")>
				
		<cf_DynamicMSS
		query="Searchresult"
		headers="#fld#"
		DDateFormat="#APPLICATION.DateFormatShow#"
		Beginning="#begin#"
		Ending="#end#"
		HeaderBold="Yes"
		HeaderSize="2"
		HeaderFontFamily="Trebuchet MS"
		DataFontFamily="Trebuchet MS"
		DataAlign="Left"
		DataBGColor="white,yellow"
		Border="1"
		BorderColor="green"
		CellPadding="1"
		CellSpacing="1"
		File="#fileName#[#currentRow#].xls"
		FilePath="#SESSION.rootPath#\CFReports\CFRStage\#SESSION.acc#\"
		FileAction="Write"
		FileOverwrite="overwrite">
		
		<cfif attach neq "">
		  <cfset attach = "#attach#,#FileName#[#currentRow#].xls">
		<cfelse>
		  <cfset attach = "#FileName#[#currentRow#].xls">  
		</cfif>
							
		<cfcatch></cfcatch>
		
		</cftry>
														
	</cfoutput>
	
	--->
	  
<cfelseif Report.LayoutClass eq "View">
	
	<cfif Layout.ReportRoot eq "Application">
		<cfset path = "#Layout.ReportPath#">
	<cfelse>	
		<cfset path = "CFRStage/Report/#Layout.ControlId#">				   			
	</cfif>		
	
	<!--- archive the report --->
	
	<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'  
	</cfquery>
	
	<cfparam name="distributionid" default="">
	
	<cfset url.fileformat = form.FileFormat>	
	
	<cffile action="READ" 
	  file="#SESSION.rootpath#/#path#/#Layout.TemplateReport#" 
	  variable="pdftemplate">
	
	<!--- test if the rending view is an PDF cfdocument file --->
	
	<cfif find("mypdfoutputfile","#pdftemplate#")>
			    		
		<!--- create the PDF file by running the template --->	
		<cfinclude template="../../#path#/#Layout.TemplateReport#">
						
		<cfset fileName = replace(Report.LayoutName," ","_","ALL")>
		<cfset attach = "#FileName#[#fileNo#].pdf">
		
		<!--- reset to PDF --->
		<cfquery name="Update" 
		     datasource="AppsSystem">
			 UPDATE UserReportDistribution
			 SET    FileFormat = 'PDF'
			 WHERE  DistributionId = '#distributionid#'
		</cfquery>
		
		<!--- write file to PDF --->
		
		<cfpdf action="WRITE"
          destination="#SESSION.rootPath#CFRStage\User\#SESSION.acc#\#attach#"
          source="mypdfoutputfile"
          overwrite="Yes">
				
		<cfif Parameter.EnableReportArchive eq "1">
		
		    <!--- archiving --->
			
			<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#")>
	
			    <cfdirectory action="CREATE" 
				directory="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#">
			
			</cfif>
			
			<cffile action="COPY" 
				source="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#" 
				destination="#SESSION.rootDocumentPath#\CFReports\#report.account#\#distributionid#.pdf">	
												 
		</cfif>	 
	
	<cfelseif Form.FileFormat eq "PDF">
	
		    <cfset fileName = replace(Report.LayoutName," ","_","ALL")>
			<cfset attach = "#FileName#[#fileNo#].pdf">
		
			<cfdocument 
	          filename          = "#SESSION.rootPath#CFRStage\User\#SESSION.acc#\#attach#"
	          format            = "PDF"
	          pagetype          = "letter"
	          margintop         = "0.2"
	          marginbottom      = "0.6"
	          marginright       = "0.01"
	          marginleft        = "0.01"
	          orientation       = "portrait"
	          unit              = "in"
	          encryption        = "none"
	          fontembed         = "Yes"
	          scale             = "95"
	          overwrite         = "Yes"
	          backgroundvisible = "No"
	          bookmark          = "False"
	          localurl          = "No">
			  <cfinclude template="../../#path#/#Layout.TemplateReport#">
	       </cfdocument>
		
		<cfif Parameter.EnableReportArchive eq "1">
		
		    <!--- archiving --->
			
			<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#")>
	
			    <cfdirectory action="CREATE" 
				directory="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#">
			
			</cfif>
						
			<cffile action="COPY" 
				source="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#" 
				destination="#SESSION.rootDocumentPath#\CFReports\#report.account#\#distributionid#.pdf">	
									
		</cfif>	
				
	<cfelse>
	
		<!--- pass others as HTML file --->
	
		<cfset fileName = replace(Report.LayoutName," ","_","ALL")>
		<cfset attach = "#FileName#[#fileNo#].htm">
	
		<cfsavecontent variable="outputhtml">

			<cfinclude template="../../#path#/#Layout.TemplateReport#">
			
		</cfsavecontent>	
						
		<cffile action="WRITE" 
			 file="#SESSION.rootPath#CFRStage\User\#SESSION.acc#\#attach#" 
			 output="#outputhtml#" 
			 addnewline="Yes" 
			 fixnewline="No">		
				
		<cfif Parameter.EnableReportArchive eq "1">
		
		    <!--- archiving --->
			
			<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#")>
	
			    <cfdirectory action="CREATE" 
				directory="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#">
			
			</cfif>
				
			<cffile action="COPY" 
				source="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#" 
				destination="#SESSION.rootDocumentPath#\CFReports\#report.account#\#distributionid#.htm">	
			 
		</cfif>	 	
		
	</cfif>
	


<!--- disabled deprecated code for views
		
<cfelseif FindNoCase(".cfm", Report.TemplateReport)>
		
   	    <cfswitch expression="#Form.FileFormat#">
		 <cfcase value="RTF">        <cfset suffix = "rtf"> </cfcase> 
		 <cfcase value="FlashPaper"> <cfset suffix = "swf"> </cfcase>
		 <cfcase value="Excel">      <cfset suffix = "xls"> </cfcase>
		 <cfdefaultcase>             <cfset suffix = "pdf"> </cfdefaultcase>
		</cfswitch> 
	  
		<cfset attach = "document#FileNo#.#suffix#">
							
		<cfdocument 
	      format="#Form.FileFormat#"  
	      pagetype="letter"
		  overwrite="yes"
		  filename="#SESSION.rootPath#/CFReports/CFRStage/#SESSION.acc#/#attach#"
		  margintop="2.2"
	      marginright="0.0"
	      marginleft="0.0"
	      orientation="portrait"
	      unit="cm"
	      encryption="none"
	      fontembed="No"
	      scale="70"
	      backgroundvisible="Yes">
		  
		  <!--- #URL.Table1# etc... --->
		 		 
		  <cfinclude template="#reportlayout#">
	  	 
	      </cfdocument>	
		  
		  --->
	    		
<cfelse>
  
	<!--- define suffix -> CFR or CFM this section can be removed --->
	
	<cfswitch expression="#Form.FileFormat#">
	 <cfcase value="FlashPaper"><cfset suffix = "swf"></cfcase>
	 <cfcase value="PDF">       <cfset suffix = "pdf"></cfcase>
	 <cfcase value="RTF">       <cfset suffix = "rtf"></cfcase>
	 <cfcase value="Excel">     <cfset suffix = "xls"></cfcase>
	 <cfcase value="HTML">      <cfset suffix = "htm"></cfcase>
	 <cfcase value="XML">       <cfset suffix = "xml"></cfcase>
	</cfswitch> 
		
	<cfset fileName = replace("#Report.LayoutName#"," ","_","ALL")>
	<cfset attach = "#FileName#[#fileNo#].#suffix#">
	
	<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'  
	</cfquery>		
	
	<cfset pathl = len(SESSION.rootDocumentPath)>
	 
	<cfif mid(SESSION.rootDocumentPath,pathl,1) neq "\">
	   <cfset filepath = "#SESSION.rootDocumentPath#\">
	<cfelse>
	   <cfset filepath = "#SESSION.rootDocumentPath#">	   
	</cfif>   
																		
	<cfreport  
	   template      = "#rootpath#\#Report.ReportPath#\#Report.TemplateReport#" 
	   format        = "#Form.fileformat#" 
	   overwrite     = "yes" 
	   encryption    = "#Report.OutputEncryption#"
	   permissions   = "#Report.OutputPermission#"
	   ownerpassword = "#report.PasswordOwner#"
	   userpassword  = "#report.PasswordUser#"
	   filename      = "#filepath#CFRStage\User\#SESSION.acc#\#attach#">
	 
		    <cfreportparam name = "Table1"     value="#Table1#">
			<cfreportparam name = "Table2"     value="#Table2#">
			<cfreportparam name = "Table3"     value="#Table3#">
			<cfreportparam name = "Table4"     value="#Table4#">
			<cfreportparam name = "Table5"     value="#Table5#">
			<cfreportparam name = "Table6"     value="#Table6#">	
			<cfreportparam name = "Table7"     value="#Table7#">	
			<cfreportparam name = "Table8"     value="#Table8#">	
			<cfreportparam name = "Table9"     value="#Table9#">	
			<cfreportparam name = "Table10"    value="#Table10#">		
			<cfreportparam name = "variable1"  value="#variable1#"> 
			<cfreportparam name = "variable2"  value="#variable2#"> 	
			<cfreportparam name = "variable3"  value="#variable3#"> 	
			<cfreportparam name = "variable4"  value="#variable4#"> 	
			<cfreportparam name = "variable5"  value="#variable5#"> 	
			<cfreportparam name = "variable6"  value="#variable6#"> 	
			<cfreportparam name = "variable7"  value="#variable7#"> 	
			<cfreportparam name = "variable8"  value="#variable8#"> 	
			<cfreportparam name = "variable9"  value="#variable9#"> 	
			<cfreportparam name = "variable10" value="#variable10#"> 		
			
			<!--- other variables --->					
			<cfreportparam name = "root"            value="#SESSION.root#">
			<cfreportparam name = "rootpath"        value="#SESSION.rootpath#">
			<cfreportparam name = "logoPath"        value="#Parameter.LogoPath#">
			<cfreportparam name = "logoFileName"    value="#Parameter.LogoFileName#">
			<cfreportparam name = "system"          value="#SESSION.welcome#">	
			<cfreportparam name = "dateformatshow"  value="#CLIENT.DateFormatShow#"> 
			<cfreportparam name = "languageCode"  	value="#Report.LanguageCode#">
						
			<cfparam name="client.datetime" default="#dateformat(now(),CLIENT.DateFormatshow)# #timeformat(now(),'HH:MM')#">	
			
			<cfreportparam name = "localtimestamp"  value="#CLIENT.datetime#">	
			
			<cfreportparam name = "clientTimestamp"  value="#CLIENT.datetime#">
			
			<cfif Report.ReportLabel eq "">
			    <cfreportparam name = "ReportLabel" value="#Report.FunctionName#">
			<cfelse>
				<cfreportparam name = "ReportLabel" value="#Report.ReportLabel#">
			</cfif>	
			<cfreportparam name = "ReportTitle"     value="#Report.LayoutTitle#">
			<cfreportparam name = "ReportSubTitle"  value="#Report.LayoutSubTitle#">
			
	</cfreport>	
			
	<!--- archive the report --->
		
	<cfparam name="distributionid" default="">
			
	<cfif Parameter.EnableReportArchive eq "1" and distributionid neq "">
	
		<!--- archive the created report to match the distribution id --->
		
		<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFReports\#report.account#")>

		    <cfdirectory 
				action    = "CREATE" 
				directory = "#SESSION.rootDocumentPath#\CFReports\#report.account#">
		
		</cfif>
							
		<cffile action="COPY" 
			source      = "#SESSION.rootDocumentPath#\CFRStage\User\#SESSION.acc#\#attach#" 
			destination = "#SESSION.rootDocumentPath#\CFReports\#report.account#\#distributionid#.#suffix#">			
	
	</cfif>	
						
</cfif>

	
<!--- identify distribution settings --->
<cfquery name="User" 
    datasource="AppsSystem">
	 SELECT     U.*, Usr.eMailAddress
	 FROM       UserReport U, UserNames Usr		
	 WHERE      ReportId = '#URL.ReportId#'
	 AND        Usr.Account = U.Account
</cfquery>

<cfquery name="Parameter" 
	   datasource="AppsSystem">
	    SELECT * 
		FROM Parameter
</cfquery>
	
<!--- store distribution action --->

<cfif URL.Mode eq "Instant" or URL.Status eq "5">
			
	<cfoutput>
	
	<cfif URL.Status eq "5">	  
	
		<cf_tl id="Mail Attachment has been prepared">
		
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>
	
		<script language="JavaScript">					
					    
			if (rpt) {								   
			 	rpt.src = "#SESSION.root#/Tools/Mail/Mail.cfm?ID1=#Report.FunctionName#&ID2=#attach#&Source=Listing&Sourceid=#URL.ReportId#&Mode=Full&GUI=#URL.GUI#&mid=#mid#"
			} else {						
				window.location = "#SESSION.root#/Tools/Mail/Mail.cfm?ID1=#Report.FunctionName#&ID2=#attach#&Source=Listing&Sourceid=#URL.ReportId#&Mode=Full&GUI=#URL.GUI#&mid=#mid#"
			}
			Prosis.alert("#lt_text#.") 
				
		</script>		
	
	<cfelse>
	
		<!--- send eMail --->		
		
		<cfinclude template="#Parameter.ReportMailTemplate#">
		
		<script language="JavaScript">		
				   
		   alert("Completed.  Email has been sent to your account and your request was logged.");		   
		   #ajaxLink('#SESSION.root#/tools/cfreport/ReportSQLInstant.cfm?status=1')#
		   
		</script> 			
		
	</cfif>	
	
	</cfoutput>
			
<cfelse>

<!--- send eMail as part of batch --->

<cfinclude template="#Parameter.ReportMailTemplate#">	
										
</cfif>

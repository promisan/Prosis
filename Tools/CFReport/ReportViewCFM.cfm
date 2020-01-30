
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Parameter" 
datasource="AppsInit">
	SELECT * 
	FROM Parameter
	WHERE HostName = '#CGI.HTTP_HOST#'  
</cfquery>
		
<cfparam name="url.distributionid" default="">
		
<cfswitch expression="#URL.FileFormat#">
			 
	 <cfcase value="Excel"> 			
		 <cfcontent type="application/msexcel">
		 <cfheader name="Content-Disposition" value="filename=report.xls">			 
	 </cfcase>
			 
	 <cfcase value="RTF"> 
		 <cfcontent type="application/msword">
		 <cfheader name="Content-Disposition" value="filename=report.doc">
	 </cfcase>
			 
	 <cfdefaultcase>	 
		 <cfcontent type="text/html">
		 <cfheader name="Content-Disposition" value="filename=report.htm">	 
	 </cfdefaultcase>
			 
</cfswitch> 

<!--- identify layout --->
<cfquery name="UserReport" 
     datasource="AppsSystem">
	 SELECT     L.*, R.*, O.eMailAddress
	 FROM       Ref_ReportControlLayOut L, 
	            Ref_ReportControl R, 
	 			Ref_SystemModule M, 
				Organization.dbo.Ref_AuthorizationRoleOwner O	
	 WHERE      LayoutId = '#URL.LayoutId#'  <!--- <cfqueryparam
							 value="#URL.LayoutId#"
							 cfsqltype="CF_SQL_IDSTAMP"> --->
	 AND        R.ControlId    = L.ControlId
	 AND        R.SystemModule = M.SystemModule
	 AND        M.RoleOwner    = O.Code  
</cfquery>

<cfif UserReport.ReportRoot eq "Application">
	<cfset path = "#UserReport.ReportPath#">
<cfelse>	
	<cfset path = "CFRStage/Report/#UserReport.ControlId#">				   			
</cfif>	
<cfoutput>

<!--- inspect template for PDF rendering by developer --->

    <cftry>
		<cffile action="READ" file="#SESSION.rootpath#/#path#/#UserReport.TemplateReport#" variable="template">
		<cfcatch>
		 	<cfset template = "">
		</cfcatch>	
	</cftry>
			
	<cfif find("mypdfoutputfile","#template#")>		
		
		<!--- reset to PDF --->
		<cfquery name="Update" 
		     datasource="AppsSystem">
			 UPDATE UserReportDistribution
			 SET FileFormat = 'PDF'
			 WHERE DistributionId = '#URL.distributionid#'
		</cfquery>
				
		<!--- create the PDF file by running the template --->	
		<cfinclude template="../../#path#/#UserReport.TemplateReport#">
		
		<!--- define a name for the file --->		
		<cfparam name="currentrow" default="#round(Rand()*500)#">
		<cfset FileNo = currentRow>
		
		<cfset fileName = replace(UserReport.LayoutName," ","_","ALL")>
		<cfset attach = "#FileName#[#fileNo#].pdf">
			
		<cfpdf action="WRITE"
          destination="#SESSION.rootPath#CFRStage\user\#SESSION.acc#\#attach#"
          source="mypdfoutputfile"
          overwrite="Yes">
				
		<cfif Parameter.EnableReportArchive eq "1" and url.distributionid neq "">
					
		    <!--- archiving --->
									
			<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#")>
	
			    <cfdirectory action="CREATE" 
				directory="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#">
			
			</cfif>
						
			<cfpdf action = "WRITE" 
			destination   = "#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#\#url.distributionid#.pdf" 
			source        = "mypdfoutputfile"
			overwrite="Yes">
						 
		</cfif>	
		
		<cflocation url="#SESSION.root#/CFRStage/User/#SESSION.acc#/#attach#" addtoken="No">
			
	<cfelseif find("<cfdocument","#template#") and UserReport.enableAttachment eq "1">
	
		<cf_message message="Problem PDF view has not been correctly configured. <br> Please add name='mypdfoutputfile' to the tag of this report [#path#/#UserReport.TemplateReport#]" return="No">
	
	<cfelseif URL.FileFormat eq "PDF">
								
		<!--- archive the PDF version report --->
				
		<cfif Parameter.EnableReportArchive eq "1" and url.distributionid neq "">
		
		    <!--- archiving --->
			
			<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#")>
	
			    <cfdirectory action="CREATE" 
				directory="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#">
			
			</cfif>
			
			<cfdocument 
	          filename     = "#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#\#url.distributionid#.pdf"
	          format       = "PDF"
	          pagetype     = "letter"
	          margintop    = "0.2"
	          marginbottom = "0.6"
	          marginright  = "0.01"
	          marginleft   = "0.01"
	          orientation  = "portrait"
	          unit         = "in"
	          encryption   = "none"
	          fontembed    = "Yes"
	          scale        = "95"
	          overwrite    = "Yes"
	          backgroundvisible="No"
	          bookmark     = "False"
	          localurl     = "No">
			  <cfinclude template="../../#path#/#UserReport.TemplateReport#">
	       </cfdocument>
			
		</cfif>	
		
		<cfdocument 
			margintop    = "0.2"   
			marginbottom = "0.6"   
			marginleft   = "0.01"   
			marginright  = "0.01"	
			format       = "PDF" 
			scale        = "95">
				<cfinclude template="../../#path#/#UserReport.TemplateReport#">
		</cfdocument>		
		
	<cfelse>
		
		<cfsavecontent variable="outputhtml">

			<cfinclude template="../../#path#/#UserReport.TemplateReport#">
			
		</cfsavecontent>	
						
		<cfif Parameter.EnableReportArchive eq "1" and url.distributionid neq "">
		
		    <!--- archiving --->
			
			<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#")>
	
			    <cfdirectory action="CREATE" 
				directory="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#">
			
			</cfif>
							
			<cffile action="WRITE" 
			 file="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#\#url.distributionid#.htm" 
			 output="#outputhtml#" 
			 addnewline="Yes" 
			 fixnewline="No">
			 
		</cfif>	 
		
		<cf_screentop height="100%" scroll="Yes" html="No">
		<table width="100%" height="98%" cellspacing="0" cellpadding="0" class="formpadding">
		  <tr><td valign="top">
		   #outputhtml#
		   </td></tr>
		</table>
		<cf_screenbottom>
		
	</cfif>
</cfoutput>


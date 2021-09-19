

<!---  usage of this form

dashboard : user uses dashboard; 
link : user uses hyperlink; 
form : user acceses form 

The output of the reports has 3 variations

1. Excel/Dataset
2. A report output using *.cfm
3. A report output using *.cfr
--->

<!---
<cfset session.status = 0>
--->


<HTML><HEAD><TITLE><cf_tl id="Requested report"></TITLE></HEAD>
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0"></body>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!---
<cfif client.browser eq "Explorer">
	<cf_wait1 controlid = "#URL.ControlId#" flush="yes"> 
</cfif>
--->
	
<cfparam name="url.distributionid" default="">			  
<cfparam name="UserReport.TemplateReport" default="">
<cfparam name="URL.Table1" default="">
<cfparam name="URL.Table2" default="">
<cfparam name="URL.Table3" default="">
<cfparam name="URL.Table4" default="">
<cfparam name="URL.Table5" default="">
<cfparam name="URL.Table6" default="">
<cfparam name="URL.Table7" default="">
<cfparam name="URL.Table8" default="">
<cfparam name="URL.Table9" default="">
<cfparam name="URL.Table10" default="">

<cfparam name="URL.var1" default="">
<cfparam name="URL.var2" default="">
<cfparam name="URL.var3" default="">
<cfparam name="URL.var4" default="">
<cfparam name="URL.var5" default="">
<cfparam name="URL.var6" default="">
<cfparam name="URL.var7" default="">
<cfparam name="URL.var8" default="">
<cfparam name="URL.var9" default="">
<cfparam name="URL.var10" default="">

<cfinclude template="LoginAccess.cfm">

<cfset fn = round(Rand()*1000)>
<cfparam name="FileNo" default="#fn#">

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
	 AND        R.ControlId = L.ControlId
	 AND        R.SystemModule = M.SystemModule
	 AND        M.RoleOwner = O.Code  
</cfquery>

<!--- this will show the report --->

<cfif UserReport.TemplateReport eq "Excel">

    <!--- ----------------------------- --->
    <!--- show the dataset/excel ------ --->
	<!--- ----------------------------- --->

	<cf_waitEnd>
	<cf_tl id="Opening Analysis Tool" var="1">
	<cfoutput>
	<cf_wait1 text="#lt_text#" flush="yes" controlid="#ControlId#" last="1">
	</cfoutput>
	
	<!--- define the user interface needed for presenting the results --->
	
	<cfif FileFormat eq "Excel">
	   <cfset p = "ExcelFormat/FormatExcel.cfm">
	<cfelse>	 	
	   <cfset p = "Analysis/SelectSource.cfm">
	</cfif>

	<cf_SystemScript>	
	<cfif URL.Status eq "5">
		
	    <cfset URL.acc = "#SESSION.acc#">
		
		<cfquery name="Output" 
		datasource="appsSystem">
		SELECT   TOP 1 *
	    FROM     Ref_ReportControlOutput R, 
		         UserReportOutput U
		WHERE    ControlId      =  <cfqueryparam
							 		value="#URL.ControlId#"
								    cfsqltype="CF_SQL_IDSTAMP"> 
		AND      R.OutputId     = U.OutputId
		AND      UserAccount    = '#SESSION.acc#'
		</cfquery>
		
		<cfif Output.recordcount neq "0">		
			<cfset URL.ID = Output.OutputId>					
		</cfif>

		<cfoutput>
			<script>
				ptoken.location ("#p#?controlid=#controlid#&reportid=#reportid#&table1=#URL.Table1#&table2=#URL.Table2#&table3=#URL.Table3#&table4=#URL.Table4#&table5=#URL.Table5#&table6=#URL.Table6#&&table7=#URL.Table7#&&table8=#URL.Table8#&table9=#URL.Table9#&table10=#URL.Table10#&variable1=#URL.var1#&variable2=#URL.var2#&variable3=#URL.var3#&variable4=#URL.var4#&variable5=#URL.var5#&variable6=#URL.var6#&variable7=#URL.var7#&variable8=#URL.var8#&variable9=#URL.var9#&variable10=#URL.var10#")
			</script>
		</cfoutput>
		
	<cfelse>
	    
	  	<cfoutput>
	  		<script>			
				ptoken.location ("#p#?controlid=#controlid#&reportid=#reportid#&table1=#URL.Table1#&table2=#URL.Table2#&table3=#URL.Table3#&table4=#URL.Table4#&table5=#URL.Table5#&table6=#URL.Table6#&&table7=#URL.Table7#&&table8=#URL.Table8#&table9=#URL.Table9#&table10=#URL.Table10#&variable1=#URL.var1#&variable2=#URL.var2#&variable3=#URL.var3#&variable4=#URL.var4#&variable5=#URL.var5#&variable6=#URL.var6#&variable7=#URL.var7#&variable8=#URL.var8#&variable9=#URL.var9#&variable10=#URL.var10#")
			</script>
		</cfoutput>
		
	</cfif>	
		   
<cfelseif UserReport.LayoutClass eq "View">	

        <!--- ----------------------------- --->
	    <!--- show the views  ------------- --->
		<!--- ----------------------------- --->

		 <cfoutput>	 			 
			 <script>			 			 
			 	window.location = "ReportViewCFM.cfm?distributionid=#url.distributionid#&layoutid=#url.layoutid#&fileformat=#url.fileformat#&table1=#URL.Table1#&table2=#URL.Table2#&table3=#URL.Table3#&table4=#URL.Table4#&table5=#URL.Table5#&table6=#URL.Table6#&&table7=#URL.Table7#&&table8=#URL.Table8#&table9=#URL.Table9#&table10=#URL.Table10#&variable1=#URL.var1#&variable2=#URL.var2#&variable3=#URL.var3#&variable4=#URL.var4#&variable5=#URL.var5#&variable6=#URL.var6#&variable7=#URL.var7#&variable8=#URL.var8#&variable9=#URL.var9#&variable10=#URL.var10#"			
			 </script>				
	    </cfoutput>		
		  	   				
<cfelse>
		
	<cfset FileNo = round(Rand()*1000)>
	
	<cfif url.mode eq "Dashboard">
	
		<cfset format = "HTML">	
		<cfset suffix = "htm">
	
	<cfelse>	
		
		<cfset format = "#URL.FileFormat#">
			   
		<cfswitch expression="#URL.FileFormat#">
			 <cfcase value="FlashPaper"><cfset suffix = "swf"></cfcase>
			 <cfcase value="PDF">       <cfset suffix = "pdf"></cfcase>
			 <cfcase value="RTF">       <cfset suffix = "rtf"></cfcase>
			 <cfcase value="Excel">     <cfset suffix = "xls"></cfcase>
			 <cfcase value="HTML">      <cfset suffix = "htm"></cfcase>
	    	 <cfcase value="XML">       <cfset suffix = "xml"></cfcase>
		</cfswitch> 
	
	</cfif>
		
	<cfset attach = "Report_#fileNo#.#suffix#">
				
	<cfif UserReport.ReportRoot eq "Application">
	   <cfset reppath  = "#SESSION.rootpath#\#UserReport.ReportPath#\#UserReport.TemplateReport#">
	<cfelse>
	   <!-- find the localised copy of the format --->
	   <cfset reppath  = "#SESSION.rootpath#\CFRStage\Report\#UserReport.Controlid#\#UserReport.TemplateReport#">
	</cfif>	
			
	<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#' 
	</cfquery>	
	

	<!--- KHERRERA Oct 08, 2012:  Added to get the client's timestamp --->
	<cfset vClientTimeStamp = createDateTime(url.tscYear,url.tscMonth,url.tscDay,url.tscHours,url.tscMinutes,url.tscSeconds)>
							
	<cfreport template  = "#reppath#" 
	   format    = "#format#" 
	   overwrite = "yes" 
	   filename  = "#SESSION.rootDocumentpath#\CFRStage\User\#SESSION.acc#\Report_#fileNo#.#suffix#">
	 					
		<cfreportparam name = "Table1"         value="#URL.Table1#">
		<cfreportparam name = "Table2"         value="#URL.Table2#">
		<cfreportparam name = "Table3"         value="#URL.Table3#">
		<cfreportparam name = "Table4"         value="#URL.Table4#">
		<cfreportparam name = "Table5"         value="#URL.Table5#">	
		<cfreportparam name = "Table6"         value="#URL.Table6#">	
		<cfreportparam name = "Table7"         value="#URL.Table7#">	
		<cfreportparam name = "Table8"         value="#URL.Table8#">			
		<cfreportparam name = "Table9"         value="#URL.Table9#">	
		<cfreportparam name = "Table10"        value="#URL.Table10#">		
		<cfreportparam name = "variable1"      value="#URL.var1#"> 
		<cfreportparam name = "variable2"      value="#URL.var2#"> 	
		<cfreportparam name = "variable3"      value="#URL.var3#"> 	
		<cfreportparam name = "variable4"      value="#URL.var4#"> 	
		<cfreportparam name = "variable5"      value="#URL.var5#"> 	
		<cfreportparam name = "variable6"      value="#URL.var6#"> 	
		<cfreportparam name = "variable7"      value="#URL.var7#"> 	
		<cfreportparam name = "variable8"      value="#URL.var8#"> 	
		<cfreportparam name = "variable9"      value="#URL.var9#"> 	
		<cfreportparam name = "variable10"     value="#URL.var10#"> 	
		
		<!--- other variables --->	
		<cfreportparam name = "root"            value="#SESSION.root#">		
		<cfreportparam name = "rootpath"        value="#SESSION.rootpath#">
		<cfreportparam name = "logoPath"        value="#Parameter.LogoPath#">
		<cfreportparam name = "logoFileName"    value="#Parameter.LogoFileName#">
		<cfreportparam name = "system"          value="#SESSION.welcome#">	
		<cfreportparam name = "dateformatshow"  value="#CLIENT.DateFormatShow#"> 
		<cfreportparam name = "languageCode"  	value="#UserReport.LanguageCode#">
		
		<!--- <cfparam name="client.datetime" default="#dateformat(now(),CLIENT.DateFormatShow)# #timeformat(now(),'HH:MM')#">	
		<cfreportparam name = "localtimestamp"  value="#CLIENT.datetime#">	 --->
		
		<cfreportparam name = "clientTimestamp"  value="#vClientTimeStamp#">
		
		<cfif UserReport.ReportLabel eq "">
		    <cfreportparam name = "ReportLabel" value="#UserReport.FunctionName#">
		<cfelse>
			<cfreportparam name = "ReportLabel" value="#UserReport.ReportLabel#">
		</cfif>		
		
		<cfreportparam name = "ReportTitle"     value="#UserReport.LayoutTitle#">
		<cfreportparam name = "ReportSubTitle"  value="#UserReport.LayoutSubTitle#">			

	</cfreport>		
	
	<!--- --------------------------------------------------- --->
	<!--- as report is generated we can now remove the tables --->
	<!--- --------------------------------------------------- --->
	
	<cfif UserReport.CleanSQLTables eq "1">
	
		<cfinclude template="SQLDropTable.cfm">
	
	</cfif>	
	
	
	<cfif Parameter.EnableReportArchive eq "1" and url.distributionid neq "">
	
		<!--- archive the created report to match the distribution id --->
		
		<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#")>

		    <cfdirectory action="CREATE" 
			             directory="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#">
		
		</cfif>
							
		<cffile action="COPY" 
			source="#SESSION.rootDocumentPath#\CFRStage\User\#SESSION.acc#\Report_#fileNo#.#suffix#" 
			destination="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#\#url.distributionid#.#suffix#">			
		
	</cfif>	
		
	<!--- ----------------------------------------------------------- --->	
	<!--- now open and launch the the report in the designated screen --->
	<!--- ----------------------------------------------------------- --->
		
	<cfoutput>	
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/> 
		
		<script>		
				
			window.location = "#SESSION.root#/CFRStage/getFile.cfm?file=Report_#fileNo#&suffix=#suffix#&mid=#mid#"
			//window.open('#SESSION.root#/CFRStage/User/#SESSION.acc#/Report_#fileNo#.#suffix#');
			/*
			var ifrm = document.createElement("IFRAME"); 
		 	ifrm.setAttribute("src", "#SESSION.root#/CFRStage/User/#SESSION.acc#/Report_#fileNo#.#suffix#?ts=#now()#");
			ifrm.style.width = "100%"; 
   			ifrm.style.height = "100%";
			var myNode = parent.document.getElementById('reportbox');
			myNode.appendChild(ifrm);
			*/
		</script>
		
	</cfoutput>	
													
</cfif>		


<head>
	<title>Launch report</title>
</head>

<cfparam name="URL.Mode" default="Variant">

<cfset url.reportid = "#replace(URL.reportid,' ','','ALL')#">

<cfif URL.Mode neq "Link">

    <cfset category  = "Launch variant">
	<cfset userid    = "#SESSION.acc#">	
	
	<cfquery name="Check" 
	 datasource="AppsSystem">
	 	 SELECT * 
		 FROM   UserReport	
		 WHERE  ReportId = <cfqueryparam
						value="#URL.reportid#"
						cfsqltype="CF_SQL_IDSTAMP">
	</cfquery>		
	
<cfelse>
	
	<cfif CGI.HTTPS eq "off">
		<cfset tpe = "http">
	<cfelse>	
		<cfset tpe = "https">
	</cfif>
			
	<cfset SESSION.refer = "#tpe#://" & CGI.HTTP_HOST & CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING>
		
	<cfset category  = "Launch hyperlink">
	<cfset userid    = "#CGI.Remote_Addr#">	
	
	<!--- enforces logon if not enabled based on the parameters passed	
		<cfinclude template="Anonymous/PublicInit.cfm">
	--->
	
	<cftry>
			
	<cfquery name="Check" 
	 datasource="AppsSystem">
	 	 SELECT * 
		 FROM   UserReport	
		 WHERE  ReportId = <cfqueryparam
						value="#URL.reportid#"
						cfsqltype="CF_SQL_IDSTAMP"> 
	</cfquery>		
	
	<cfif SESSION.acc neq Check.account and SESSION.isAdministrator eq "No">
		
		<cfoutput>	
			<cf_message message="#SESSION.welcome# Security agent, you are not the owner of this report." return="No">
		</cfoutput>	
		<cfabort>	
	
	</cfif>
	
	<cfcatch>
	
	    <cfoutput>	
			<cf_message message="#SESSION.welcome# Security agent, you supplied an invalid link." return="No">
		</cfoutput>	
		<cfabort>	
	
	</cfcatch>
	
	</cftry>
				
</cfif>


<cfquery name="getInit" 
	 datasource="AppsSystem">
 	 SELECT * 
	 FROM   Parameter			 
</cfquery>		

<cf_screentop height="100%"
	    scroll="No" 
		layout="webapp" 
		banner="gray" 
		blockevent="rightclick"
		bannerheight="55"
		line="no"
		label="#Check.DistributionSubject#" 
		user="Yes">

<cfset URL.ReportId = replace("#URL.ReportId#"," ","","ALL")>

<table width="100%" height="100%">
					 
	  <tr id="myprogressbox" class="xhide">  <!--- xhide as otherwise progress bar does not show properly --->
	  
	      <td height="30" align="center" style="padding-top:20px">

				<cfif isDefined("Session.status")>
						<cfscript>
							StructDelete(Session,"Status");
						</cfscript>
				</cfif>
				
				<!--- we get historical information in this report --->
				
				<cfquery name="get"
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   TOP 1 PreparationMillisecond
						FROM     UserReportDistribution
						WHERE    ReportId  = '#url.reportid#' 						
						ORDER BY Created DESC
					</cfquery>											
					
					<cfif get.PreparationMillisecond gte "500">																								
					
						<cfprogressbar name="pBar" 
								style="bgcolor:fafafa;progresscolor:c1c1c1"  
								duration="#get.PreparationMillisecond#" 
								height="20" 
								interval="200" 													
								autoDisplay="false" 
								width="506"/>  
					
					<cfelse>
								
				  		<cfif getInit.VirtualDirectory eq "">					
						
							 <cfprogressbar name="pBar" 
							   style="bgcolor:fafafa;progresscolor:c1c1c1" 
								bind="cfc:component.Authorization.AuthorizationBatch.getstatus()" 
								height="20" 
								interval="200" 
								autoDisplay="false" 
								width="506"/> 
							
						 <cfelse>
						 
							 <cfset pre = "#getInit.VirtualDirectory#.component">
							 				 
							  <cfprogressbar name="pBar" 
							    style="bgcolor:fafafa;progresscolor:c1c1c1" 
								bind="cfc:#pre#.Authorization.AuthorizationBatch.getstatus()" 
								height="20" 
								interval="200" 
								autoDisplay="false" 
								width="506"/> 				 
						 
						 </cfif>	
						 
					</cfif>	 
								
		  </td>
	  </tr>
	  	  
	  <tr class="hide"><td height="1" id="action"></td></tr>
		 		  
	  <tr><td height="100%" id="myreportcontent" style="padding:20px;">
	  
	  		<cfparam name="Client.Browser" default="Explorer">
	  		 
			<!--- ACTUAL CONTENT OF THE REPORT --->
			<cfif client.browser eq "Chrome">
			
			 	<cf_divscroll overflowy="hidden">
				
	    			<iframe 
						name="report"
			        	id="report"
			        	width="100%"
			       		height="100%"
			       		scrolling="no"
			        	frameborder="0"
			        	style="border: 1px ridge gray">
					</iframe>
					
				</cf_divscroll>
				
			<cfelse>
			
				<iframe 
					name="report"
			        id="report"
			        width="100%"
			        height="100%"
			        scrolling="no"
			        frameborder="0"
			        style="border: 1px ridge gray;">
				</iframe>
				
			</cfif>
											
		  </td>
		  </tr>
		  
</table>

<cf_screenbottom layout="webapp">

<!--- canvas was made and now we start creating the report --->

<cfoutput>

	<cfparam name="url.mid" default="">
	 
	<script>    
	     ColdFusion.navigate('ReportLinkOpenGo.cfm?reportId=#url.reportid#&Mode=Link&Category=#category#&userid=#userid#&mid=#url.mid#','action')		
	</script>

</cfoutput>


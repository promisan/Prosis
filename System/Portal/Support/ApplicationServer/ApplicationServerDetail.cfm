<cfparam name="url.accFilter" 		default="null">
<cfparam name="url.statusFilter" 	default="">
<cfparam name="url.classFilter" 	default="">
<cfparam name="url.sortingFilter" 	default="0">
<cfparam name="url.dateFilter" 		default="#lsDateFormat(now(),client.dateFormatShow)#">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dateFilter#">
<cfset vDateFilter = dateValue>

<cfquery name="Servers" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT *
		FROM   Control.dbo.ParameterSite
		WHERE  ServerLocation = 'Local' 
		AND Operational = 1 
		ORDER  BY ApplicationServer
</cfquery>

<cf_pane 
		id="appServer" 
		height="auto"
		paneItemMinSize="#url.itemSize#" 
		paneItemOffset="#url.itemOffset#">
			

			<cfloop query="Servers">
				
				<cfquery name="checkLinkedServer"   datasource="AppsSystem">  
					Select 1 Where Exists (Select SRVID From MASTER.DBO.sysservers Where SRVNAME='#DatabaseServer#')  
				</cfquery>
				
				<cfif checkLinkedServer.recordcount eq 1>
			
					<cfset appServer = rereplacenocase(ApplicationServer, '[^a-z]', '', 'all')>
			
				
								<cfset vType = 0>
								<cfset vStyle = "background-color:##52ACD1;">
								
								<!---
								<cfif dateDiff('d',Created, now()) gt vThreshold>
									<cfset vType = 1>
									<cfset vStyle = "background-color:##E04937;">
								</cfif>
								--->
						
								<cf_paneItem id="#appServer#" 
										source="#session.root#/System/Portal/Support/ApplicationServer/ApplicationServerContent.cfm?Server=#ApplicationServer#"
										filtervalue = "#ApplicationServer#"
										style="background-color:##F2F2F2; border:1px solid ##F2F2F2; -moz-border-radius:5px; -webkit-border-radius:5px; -ms-border-radius:5px; -o-border-radius:5px; border-radius:5px;"
										headerStyle="font-size:175%; color:##FFFFFF; font-weight:bold; padding-top:0px; padding-bottom:0px; #vStyle#"
										showSeparator="0"
										systemfunctionid="#url.systemfunctionid#"
										width="#url.itemSize#px"
										height="250px"
										ShowPrint="1"
										Transition="fade"
										TransitionTime="1000"
										IconSet="white"
										IconHeight="15px"
										label="#ApplicationServer#">
				
				</cfif>
			
			</cfloop>	

</cf_pane>





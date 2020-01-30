<cfparam name="url.header" default="1">

<!--- HTML5 --->
<!DOCTYPE html>

<html>

	<head>
		<cf_screentop html="no" jquery="yes" scroll="yes">
		<cf_paneScript>
		<cf_presentationScript>
		<cf_systemScript>
		
		<style>
			.clsIcon img {
				height:20px;
			}
		</style>
		
		<cfoutput>
			<script>
				function showConfigurations(id) {
					ptoken.open("#session.root#/System/Modules/PortalBuilder/RecordEdit.cfm?systemmodule=SelfService&id="+id+"&ts="+new Date().getTime(), 'p_ShowConfigurations', "status=no,height=850,width=1024,top=50,left=50,resizable=yes");
				}
			</script>
		</cfoutput>
		
	</head>
	
	<body>
	
		<div style="padding-top:25px;">
			<cfif url.header eq 1>
				<table width="96%">
					<tr>
						<td style="padding-left:20px;">
							<cfquery name="Parameter" 
								datasource="AppsInit">
									SELECT 	* 
									FROM 	Parameter
									WHERE 	HostName = '#CGI.HTTP_HOST#'  
						    </cfquery>
							
							<cfset vAppLogo = "#session.root#/images/noImageAvailable.png">
							<cfif Parameter.recordCount eq 1>
								<cfif trim(Parameter.AppLogoPath) neq "" and trim(Parameter.AppLogoFileName) neq "">
									<cfset vAppLogo = "#session.root#/#Parameter.AppLogoPath#/#Parameter.AppLogoFileName#">
								</cfif>
							</cfif>
							<cfoutput>
								<cfset vHome = session.root>
								<cfset vHome = replace(vHome,"/nucleus","","ALL")>
								<a href="#vHome#" target="_blank" title="Home">
									<img src="#vAppLogo#" style="height:85px; cursor:pointer;">
								</a>
							</cfoutput>
						</td>
						<cfoutput>
						<td align="right" style="padding-top:19px; padding-left:30px; font-size:40px; color:##808080;" class="labellarge"><b>#Parameter.SystemTitle# <cf_tl id="HTML5 Portals"></td>
						</cfoutput>
					</tr>
				</table>
			</cfif>
		</div>

		<cfquery name="basedata" 
			datasource="AppsSystem">
				SELECT	*
				FROM	Ref_ModuleControl RM
				WHERE	SystemModule = 'SelfService'
				AND		FunctionClass = 'SelfService'
				AND		MenuClass IN ('Main','Mission')
				AND		Operational = 1
				AND		FunctionTarget = 'HTML5'
				<cfif getAdministrator('*') neq '1'>
					AND EXISTS (
						SELECT 	TOP 1 'X' 
						FROM 	System.dbo.UserModule as US 
						WHERE 	US.SystemFunctionId = RM.SystemFunctionId
						AND		US.Account = '#Session.acc#'
						AND     US.Status!='9'
					)
				</cfif>
				ORDER BY FunctionTarget, MenuOrder ASC
		</cfquery>
		
		<cfset vItemSize = 330>
		<cfset vItemOffset = 10>
			
		<div align="center" style="padding-left:20px;width:95%;padding-right:20px;">
			
			<cfoutput query="basedata" group="FunctionTarget">	
			
				<cf_pane 
					id="target_#FunctionTarget#" 
					height="auto"
					<!--- label="#UCASE(FunctionTarget)#" --->
					search="No"
					paneItemMinSize="#vItemSize#" 
					paneItemOffset="#vItemOffset#">
						
						<cfoutput>
						
							<cfquery name="qLogo" 
								datasource="AppsSystem">
									SELECT 	*
									FROM	Ref_ModuleControl
									WHERE	SystemModule	= 'SelfService'
									AND		FunctionClass	= '#FunctionName#'
									AND		MenuClass		= 'Layout'
									AND		FunctionName	= 'FavIcon'
									AND		Operational		= 1
							</cfquery>
							
							<cfset vLogo = "">
							<cfif qLogo.recordCount eq 1>
								<cfif trim(qLogo.functionDirectory) neq "" and trim(qLogo.FunctionPath) neq "">
									<cfset vLogo = "<span class=clsIcon><img src=#session.root#/#qLogo.functionDirectory##qLogo.FunctionPath#></span>">
								</cfif>
							</cfif>
							
							<cfset vId = replace(SystemFunctionId,"-","","ALL")>
							<cf_paneItem id="#vId#" 
								source="#session.root#/Portal/PortalListingContent.cfm?SystemFunctionId=#SystemFunctionId#"
								filterValue="#FunctionTarget# #FunctionName# #FunctionInfo# #FunctionMemo#"
								style="background-color:##F2F2F2; border:1px solid ##C0C0C0; -moz-border-radius:5px; -webkit-border-radius:5px; -ms-border-radius:5px; -o-border-radius:5px; border-radius:5px; padding:0px;"
								headerStyle="font-size:20px; color:##FFFFFF; font-weight:bold; padding:10px; background-color:##52ACD1; text-align:left;"
								showSeparator="0"
								systemfunctionid="#systemfunctionid#"
								width="#vItemSize#px"
								height="270px"
								ShowPrint="0"
								ShowRefresh="0"
								Transition="fade"
								TransitionTime="1000"
								IconSet="white"
								IconHeight="15px"
								IconStyle="padding-top:11px;"
								label="#vLogo#&nbsp;<span>#FunctionMemo#</span>">
									
						</cfoutput>
						
				</cf_pane>
			
			</cfoutput>	
		
		</div>
		
	</body>

</html>
<!--- HTML5 --->
<!DOCTYPE html>

<html>

	<head>
	
		<cfoutput>
			<!-- CSS -->
			<link rel="stylesheet" charset="utf-8" href="#session.root#/Portal/Backoffice/HTML5/css/HTML5/portal.css" id="mainStyle" />
			
			<script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/jQuery/jquery.js"></script>
		</cfoutput>
	
	</head>
	
	<body>
	
		<cfquery name="ExtendedPortal" 
			datasource="AppsSystem">
				SELECT 	*
				FROM	Ref_ModuleControl
				WHERE	SystemModule	= 'SelfService'
				AND		FunctionClass 	= 'SelfService'
				AND		FunctionName	= '_#url.id#'
				AND		Operational		= 1
		</cfquery>
		
		<cfquery name="qAutoIE8" 
			datasource="AppsSystem">
				SELECT 	*
				FROM	Ref_ModuleControl
				WHERE	SystemModule	= 'SelfService'
				AND		FunctionClass	= '#url.id#'
				AND		MenuClass		= 'Function'
				AND		FunctionName	= 'AutoIE8'
		</cfquery>
		
		<cfquery name="qFAQ" 
			datasource="AppsSystem">
				SELECT 	*
				FROM	Ref_ModuleControl
				WHERE	SystemModule	= 'SelfService'
				AND		FunctionClass	= '#url.id#'
				AND		MenuClass		= 'Menu'
				AND		FunctionName	= 'FAQ'
		</cfquery>

		<cfif ExtendedPortal.recordCount eq 1>
			
			<cfset vAutoIE8 = 0>
			<cfif qAutoIE8.recordCount eq 0>
				<cfset vAutoIE8 = 1>
			<cfelseif qAutoIE8.recordCount eq 1>
				<cfif qAutoIE8.Operational eq 1>
					<cfset vAutoIE8 = 1>
				</cfif>
			</cfif>
			
			<cfif vAutoIE8 eq 1>
			
				<cfoutput>
					<script>
						parent.window.location = "#session.root#/Portal/SelfService/default.cfm?id=_#url.id#&mission=#url.mission#";
					</script>
				</cfoutput>
				
			</cfif>
			
		</cfif>
		
		<div class="clsLoginLocalResult" style="width:100%; text-align:center; margin-top:150px; font-size:200%;">
			<cf_tl id="This browser version/mode is not supported">
		</div>
		<div class="clsLoginLocalResult" style="width:100%; text-align:center; font-size:125%;">
			<cfif trim(qAutoIE8.functionInfo) eq "">
				<cf_tl id="Please contact your IT administrator">
			<cfelse>
				<cfoutput>#qAutoIE8.functionInfo#</cfoutput>
			</cfif>
		</div>
		
		<div style="font-size:125%; width:100%; text-align:center; margin-top:50px; color:#808080;">
		
			<p>
				<cf_tl id="You may be using an older version of Internet Explorer or Firefox, which are not supported.">&nbsp;&nbsp;<cf_tl id="To continue, we recommend you to download the latest version of Chrome.">
			</p>
			<cfif qFAQ.recordCount eq 1>
				<cfif trim(qFAQ.FunctionDirectory) neq "" and trim(qFAQ.FunctionPath) neq "">
					<p>
						<cfoutput>
							<cf_tl id="For details on supported devices and browsers, please visit our"> <a href="#session.root#/#qFAQ.FunctionDirectory##qFAQ.FunctionPath#?id=#url.id#&showPortalName=1&&#qFAQ.FunctionCondition#" target="_blank">FAQ</a>.
						</cfoutput>
					</p>
				</cfif>
			</cfif>
			<br><br>
		
		    <cfinvoke component = "Service.Process.System.Client"  
			   method           = "getBrowser"
			   browserstring    = "#CGI.HTTP_USER_AGENT#"	  
			   returnvariable   = "thisbrowser">	   
					
			<cf_tl id="Your browser: ">
			<cfoutput>
			#thisbrowser.name# #thisbrowser.release#
			</cfoutput>
						
			<div id="docModeContainer" style="font-size:80%; display:none;">
				<cf_tl id="Mode: "> Explorer <span id="docMode"></span>
			</div>
			
			<cfoutput>
				<script>
					if (document.documentMode) {
						$('##docMode').html(document.documentMode);
						$('##docModeContainer').css('display','block');
					}
				</script>
			</cfoutput>
		</div>
		
		<cfif ExtendedPortal.recordCount eq 1>
			<br>
			<br>
			<div style="font-size:125%; width:100%; text-align:center; margin-top:50px; color:#808080;">
				<cfoutput>
					<cf_tl id="Or check our IE8 Portal">: <a href="#session.root#/Portal/SelfService/default.cfm?id=_#url.id#&mission=#url.mission#" target="_blank"><cf_tl id="Here"></a>
				</cfoutput>
			</div>
		</cfif>
		
		<!--- recheck the ie version --->
		<cf_validateBrowser minIE="10" setDocumentMode="1">
		
		<cfif clientbrowser.pass eq 1>
			<cfoutput>
				<script>
					parent.window.location = "#session.root#/Portal/SelfService/default.cfm?id=#url.id#&mission=#url.mission#";
				</script>
			</cfoutput>
		</cfif>
		
	</body>
	
</html>


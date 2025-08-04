<!--
    Copyright © 2025 Promisan

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
	
	<cfquery name="Portal" 
		datasource="AppsSystem">
			SELECT 	*
			FROM	Ref_ModuleControl
			WHERE	SystemModule	= 'SelfService'
			AND		FunctionClass 	= 'SelfService'
			AND		FunctionName	= '#url.id#'
	</cfquery>
	
	<body>
		
		<div class="clsLoginLocalResult" style="width:100%; text-align:center; margin-top:250px; font-size:200%;">
			<cf_tl id="Hi"> <cfoutput>#session.first# #session.last# (#session.acc#)</cfoutput> !<br><br>
			<cf_tl id="We're sorry. Your account does not have access to"> <cfoutput><cfif trim(Portal.FunctionMemo) neq "">#Portal.FunctionMemo#<cfelse>#Portal.FunctionName#</cfif></cfoutput>
		</div>
		<div class="clsLoginLocalResult" style="width:100%; text-align:center; margin-top:20px; font-size:125%;">
			<cfoutput>
				<cf_tl id="To request access for you or your office, please contact"> <a href="mailto:#Portal.FunctionContact#">#Portal.FunctionContact#</a>
			</cfoutput>
		</div>
		
		<div style="font-size:125%; width:100%; text-align:center; margin-top:50px; color:#808080;">
			<cfoutput>
				<a href="#session.root#/Portal/SelfService/default.cfm?id=#url.id#&mission=#url.mission#"><cf_tl id="Back to Login Page"></a>
			</cfoutput>
		</div>
		
		<cfdiv id="_processAjax" style="display:none;">
		<cfoutput>
			<script>
				_cf_loadingtexthtml = '';
				ptoken.navigate('#SESSION.root#/Portal/selfservice/HTML5/Logoff.cfm?host=#CGI.HTTP_HOST#&autoReload=0','_processAjax');
			</script>
		</cfoutput>
		
	</body>
	
</html>


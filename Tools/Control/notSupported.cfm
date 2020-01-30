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
		
		<div class="clsLoginLocalResult" style="width:100%; text-align:center; margin-top:150px; font-size:200%;">
			<cf_tl id="This browser version/mode is not supported">
		</div>
		<div class="clsLoginLocalResult" style="width:100%; text-align:center; font-size:125%;">
			<cf_tl id="Please contact your IT administrator">
		</div>
		
		<div style="font-size:125%; width:100%; text-align:center; margin-top:50px; color:#808080;">
		
			<p>
				<cf_tl id="You are using an older version of Internet Explorer that is not supported.">&nbsp;&nbsp;<cf_tl id="To continue, we recommend you to download the latest version of Internet Explorer.">
			</p>   
					
			<cf_tl id="Your browser: ">
			<cfoutput>
			#url.name# #url.release#
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
			<br><br><br>
			<p style="color:#808080;">
				<cfoutput>#session.welcome#</cfoutput>
			</p>
		</div>
		
		<!--- recheck the ie version --->
		<cf_validateBrowser minIE="#url.minIE#" minChrome="#url.minChrome#" setDocumentMode="1">
		
		<cfif clientbrowser.pass eq 1>
			<cfoutput>
				<script>
					parent.window.location = "#session.root#/default.cfm";
				</script>
			</cfoutput>
		</cfif>
		
	</body>
	
</html>


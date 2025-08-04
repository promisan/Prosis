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
<cfparam name="attributes.appId"					default="">
<cfparam name="attributes.welcome"					default="Powered by Promisan, B.V.">
<cfparam name="attributes.validateLogin"			default="yes">
<cfparam name="attributes.grid"						default="no">
<cfparam name="attributes.awesomeCheckbox"			default="no">
<cfparam name="attributes.datepicker"				default="no">
<cfparam name="attributes.flotCharts"				default="no">
<cfparam name="attributes.chartJS"					default="no">
<cfparam name="attributes.toastr"					default="no">
<cfparam name="attributes.customCSS"				default="">
<cfparam name="attributes.bodyClass"				default="">
<cfparam name="attributes.bodyStyle"				default="">
<cfparam name="attributes.printWindowSize"			default="10">
<cfparam name="attributes.printWindowSizeChrome"	default="800">
<cfparam name="attributes.allowLogout"				default="true">
<cfparam name="attributes.loading"					default="<div class='text-center'><i class='fa fa-cog fa-spin fa-3x text-success'></i></div>">
<cfparam name="Attributes.Signature"     	 		default="No">

<cfquery name="getApplication"
		datasource="AppsSystem">
	SELECT  *
	FROM    Ref_ModuleControl
	WHERE	SystemModule = 'PMobile'
	AND		FunctionClass = 'PMobile'
	AND		FunctionName = '#attributes.appId#'
AND		Operational = 1
</cfquery>

<cfif thisTag.ExecutionMode is "start">

	<cfoutput>

		<!DOCTYPE html>
		<html>
		<head>

			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

			<meta http-equiv="X-UA-Compatible" content="IE=edge">

			<!-- Page title -->
		<title>#getApplication.FunctionMemo#</title>

		<!-- Place favicon.ico and apple-touch-icon.png in the root directory -->
		<cfif attributes.appId neq "">
				<link rel="shortcut icon" type="image/ico" href="#session.root#/images/#attributes.appId#/favicon.ico" />
		</cfif>

			<!-- Vendor styles -->
				<!-- <link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/fontawesome/css/font-awesome.css" />-->
			<link rel="stylesheet" href="#session.root#/images/css/standard.css" />
			<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/metisMenu/dist/metisMenu.css" />
			<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/animate.css/animate.css" />
			<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/css/bootstrap.css" />
			<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/sweetalert/lib/sweet-alert.css">

		<cfif trim(lcase(attributes.grid)) eq "yes" or trim(lcase(attributes.grid)) eq "1">
				<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/datatables_plugins/integration/bootstrap/3/dataTables.bootstrap.css" />
		</cfif>

		<cfif trim(lcase(attributes.toastr)) eq "yes" or trim(lcase(attributes.toastr)) eq "1">
			<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/toastr/build/toastr.min.css" />
				<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/styles/static_custom.css">
		</cfif>

		<cfif trim(lcase(attributes.awesomeCheckbox)) eq "yes" or trim(lcase(attributes.awesomeCheckbox)) eq "1">
				<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css">
		</cfif>

			<!-- App styles -->
				<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/fonts/pe-icon-7-stroke/css/pe-icon-7-stroke.css" />
			<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/fonts/pe-icon-7-stroke/css/helper.css" />
			<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/styles/style.css">

		<!-- Vendor scripts -->
			<script src="#session.root#/scripts/jquery/jquery.js"></script>
			<script src="#session.root#/scripts/mobile/resources/vendor/jquery-ui/jquery-ui.min.js"></script>
			<script src="#session.root#/scripts/mobile/resources/vendor/slimScroll/jquery.slimscroll.min.js"></script>
			<script src="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/js/bootstrap.min.js"></script>
			<script src="#session.root#/scripts/mobile/resources/vendor/metisMenu/dist/metisMenu.min.js"></script>
			<script src="#session.root#/scripts/mobile/resources/vendor/iCheck/icheck.min.js"></script>
			<script src="#session.root#/scripts/mobile/resources/vendor/peity/jquery.peity.min.js"></script>
			<script src="#session.root#/scripts/mobile/resources/vendor/sparkline/index.js"></script>
			<script src="#session.root#/scripts/mobile/resources/vendor/sweetalert/lib/sweet-alert.min.js"></script>

		<cfif trim(lcase(attributes.grid)) eq "yes" or trim(lcase(attributes.grid)) eq "1">
			<script src="#session.root#/scripts/mobile/resources/vendor/datatables/media/js/jquery.dataTables.min.js"></script>
				<script src="#session.root#/scripts/mobile/resources/vendor/datatables_plugins/integration/bootstrap/3/dataTables.bootstrap.min.js"></script>
		</cfif>

		<cfif trim(lcase(attributes.toastr)) eq "yes" or trim(lcase(attributes.toastr)) eq "1">
				<script src="#session.root#/scripts/mobile/resources/vendor/toastr/build/toastr.min.js"></script>
		</cfif>

		<cfif trim(lcase(attributes.datepicker)) eq "yes" or trim(lcase(attributes.datepicker)) eq "1">
				<!-- Include Bootstrap Datepicker -->
					<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/datePicker/css/datepicker.min.css" />
				<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/datePicker/css/datepicker3.min.css" />
				<script src="#session.root#/scripts/mobile/resources/vendor/datePicker/js/bootstrap-datepicker.min.js"></script>
		</cfif>

		<cfif trim(lcase(attributes.flotCharts)) eq "yes" or trim(lcase(attributes.flotCharts)) eq "1">
			<script src="#session.root#/scripts/mobile/resources/vendor/jquery-flot/jquery.flot.js"></script>
				<script src="#session.root#/scripts/mobile/resources/vendor/jquery-flot/jquery.flot.resize.js"></script>
				<script src="#session.root#/scripts/mobile/resources/vendor/jquery-flot/jquery.flot.pie.js"></script>
				<script src="#session.root#/scripts/mobile/resources/vendor/flot.curvedlines/curvedLines.js"></script>
				<script src="#session.root#/scripts/mobile/resources/vendor/jquery.flot.spline/index.js"></script>
		</cfif>

		<cfif trim(lcase(attributes.chartJS)) eq "yes" or trim(lcase(attributes.chartJS)) eq "1">
				<script src="#session.root#/scripts/mobile/resources/vendor/chartjs/chartjs_2-7-2.js"></script>
		</cfif>

			<!-- App scripts -->
				<script src="#session.root#/scripts/mobile/resources/scripts/app.js"></script>

		<!-- Prosis mobile custom styles -->
		<style>
			.dataTables_wrapper {
				width:98%;
			}
		</style>

		<cfif trim(attributes.customCSS) neq "">
				<link rel="stylesheet" href="#attributes.customCSS#">
		</cfif>

<!--- Print function --->
		<cfajaximport tags="cfform">
		<cfajaxproxy cfc="service.authorization.passwordCheck" jsclassname="systempassword">
		<cf_ChangePasswordScript Context="Mobile">
		<cf_validateBrowser>
		<cfset _prosisWebPrintWindowWidth = "#attributes.printWindowSize#">
		<cfset _prosisWebPrintWindowHeight = "#attributes.printWindowSize#">
		<cfif clientbrowser.name eq "Chrome" OR clientbrowser.name eq "Edge">
			<cfset _prosisWebPrintWindowWidth = "#attributes.printWindowSizeChrome#">
			<cfset _prosisWebPrintWindowHeight = "#attributes.printWindowSizeChrome#">
		</cfif>
			<script>

			function ___prosisMobileWebPrint(selector, directPrint, customPrintStyle, callback) {
				var vHtml = '<!DOCT'+'YPE ht'+'ml><ht'+'ml><he'+'ad>';
			var vStyles = '<'+'lin'+'k rel="style'+'sheet" href="#session.root#/scripts/mobile/resources/vendor/fontawesome/css/font-awesome.css" />'
					+ '<'+'lin'+'k rel="style'+'sheet" href="#session.root#/scripts/mobile/resources/vendor/metisMenu/dist/metisMenu.css" />'
					+ '<'+'lin'+'k rel="style'+'sheet" href="#session.root#/scripts/mobile/resources/vendor/animate.css/animate.css" />'
					+ '<'+'lin'+'k rel="style'+'sheet" href="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/css/bootstrap.css" />'
					+ '<'+'lin'+'k rel="style'+'sheet" href="#session.root#/scripts/mobile/resources/vendor/sweetalert/lib/sweet-alert.css" />'
					+ '<'+'lin'+'k rel="style'+'sheet" href="#session.root#/scripts/mobile/resources/fonts/pe-icon-7-stroke/css/pe-icon-7-stroke.css" />'
					+ '<'+'lin'+'k rel="style'+'sheet" href="#session.root#/scripts/mobile/resources/fonts/pe-icon-7-stroke/css/helper.css" />'
					+ '<'+'lin'+'k rel="style'+'sheet" href="#session.root#/scripts/mobile/resources/styles/style.css" />';

				if ($.trim(customPrintStyle) != '' && customPrintStyle != null) {
					vStyles = vStyles + '<lin'+'k rel="style'+'sheet" href="' + $.trim(customPrintStyle) + '" />';
				}

			var vScripts = '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/jquery/dist/jquery.min.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/jquery-ui/jquery-ui.min.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/slimScroll/jquery.slimscroll.min.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/js/bootstrap.min.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/metisMenu/dist/metisMenu.min.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/iCheck/icheck.min.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/peity/jquery.peity.min.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/sparkline/index.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/chartjs/chartjs_2-7-2.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/vendor/sweetalert/lib/sweet-alert.min.js"></'+'scri'+'pt>'
				+ '<'+'scri'+'pt src="#session.root#/scripts/mobile/resources/scripts/app.js"></'+'scri'+'pt>';

			var vBody = '</he'+'ad><bo'+'dy onl'+'oad="windo'+'w.print(); wi'+'ndow.clo'+'se();">';
			if (!directPrint) {
				vBody = '</he'+'ad><bo'+'dy>';
			}
			var vBodyClose = '</bo'+'dy>';
			var vHtmlClose = '</bo'+'dy></ht'+'ml>'

			var vContent = '';
			var vCanvasArray = [];
			var vCanvasElements = [];
			$(selector).each(function(){
				if ($.trim($(this).html()) != '') {
					vContent += $(this).html() + '<br>';
					vCanvasArray.push($(vContent).find('canvas'));
				}
			});
			for (var i = 0; i < vCanvasArray[0].length; i++) {
				var vThisCanvas = {};
				vThisCanvas.id = vCanvasArray[0][i].id;
				vThisCanvas.image = "<img src='" + document.getElementById(vCanvasArray[0][i].id).toDataURL("image/jpg") + "'/>";
				vCanvasElements.push(vThisCanvas);
			}

			var fnReplaceCanvas = '';
		for (var i = 0;  i < vCanvasElements.length; i++) {
				fnReplaceCanvas += '$("##' + vCanvasElements[i].id + '").parent().append("' + vCanvasElements[i].image + '");';
		}
			if (fnReplaceCanvas != '') {
				fnReplaceCanvas += ' $("canvas").remove();';
			}

			var vCallback = '';
			if ($.trim(callback) != '') {
				vCallback = callback;
			}

			var vFinalScripts = '<scr'+'ipt>$(".clsNoPrint").css("display","none"); ' +  vCallback + fnReplaceCanvas + '</scr'+'ipt>';

		if (directPrint) {
				w = window.open('', 'Print_Page', 'scrollbars=yes, width=#_prosisWebPrintWindowWidth#, height=#_prosisWebPrintWindowHeight#');
		} else {
				w = window.open('', 'Print_Page', 'scrollbars=yes, resizable=yes, width=#_prosisWebPrintWindowWidth#, height=#_prosisWebPrintWindowHeight#');
		}
			w.document.write(vHtml + vStyles + vScripts + vBody + vContent + vFinalScripts + vBodyClose + vHtmlClose);
			w.document.close();
		}

			<cfif trim(lcase(attributes.toastr)) eq "yes" or trim(lcase(attributes.toastr)) eq "1">
				toastr.options = {
					"closeButton": true,
					"debug": false,
					"newestOnTop": true,
					"progressBar": false,
					"positionClass": "toast-bottom-right",
					"preventDuplicates": false,
					"toastClass": "animated fadeInDown"
				}
			</cfif>

			</script>


		<cfif attributes.Signature eq "Yes">
			<cf_UIGadgets TreeTemplate="No">

				<meta name="viewport" content="width=device-width, initial-scale=1.0">
				<script>
					function getSignatureWidth()
					{
						let width = screen.width;

						if (width <= 480)
							document.getElementById("dCanvasMobile").style.display = "block";
						else
							document.getElementById("dCanvasDesktop").style.display = "block";

						document.getElementById("bSign").style.display = "none";
						document.getElementById("bClear").style.display = "block";
						document.getElementById("bDone").style.display = "block";
					}

					function clearSignature()
					{
						let width = screen.width;
						if (width <= 480)
							surfaceMobile.clear();
						else
							surfaceDesktop.clear();
					}

					function saveSignature()
					{
						let width = screen.width;
						if (width <= 480)
						{
							_saveSVGMobile();
							document.getElementById("dCanvasMobile").style.display = "none";
						}
						else
						{
							_saveSVGDesktop();
							document.getElementById("dCanvasDesktop").style.display = "none";
						}
						document.getElementById("bSign").style.display = "block";
						document.getElementById("bClear").style.display = "none";
						document.getElementById("bDone").style.display = "none";
					}

				</script>
			<cf_UISignatureScript Mode = "Desktop">
			<cf_UISignatureScript Mode = "Mobile">
			<cf_UISignatureViewScript>
		</cfif>



		</head>
				<body class="#attributes.bodyClass#" style="#attributes.bodyStyle#">

	<!-- Simple splash screen-->
	<div class="splash"> <div class="color-line"></div><div class="splash-title"><h1>#getApplication.FunctionMemo#</h1><p>#attributes.welcome#</p><i class="fa fa-cog fa-spin fa-4x ProsisColorOrng"></i></div> </div>
	<!--[if lt IE 7]>
	<p class="alert alert-danger">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
	<![endif]-->

<!--- Preventing cache for security --->
		<cf_preventCache>


		<cfif trim(lcase(attributes.validateLogin)) eq "yes" or trim(lcase(attributes.validateLogin)) eq "1">
			<cfif isDefined("session.authent") and session.authent eq "1">
			<cfelse>
				<script>
						window.location.href = "#session.root#/portal/mobile/logoff.cfm?appId=#attributes.appId#";
			</script>
			</cfif>
		</cfif>


<!--- Wait Modal --->
		<div
				class="modal fade"
				id="_waitModal"
				data-keyboard="false"
				data-backdrop="false"
				role="dialog"
				aria-hidden="true"
				style="display:none; background-color:rgba(0,0,0,0.6);">
		<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="color-line"></div>
		<div class="modal-header text-center">
		<h4 class="modal-title">#getApplication.FunctionMemo#</h4>
	<small class="font-bold">#attributes.welcome#</small>
	</div>
		<div class="modal-body text-center">
			<i class="fa fa-cog fa-spin fa-3x"></i>
			<div class="modal-body-text" style="padding-top:10px;"></div>
		</div>
	</div>
	</div>
	</div>


	</cfoutput>

<!--- Used only to load basic CF scripts --->
	<cfdiv id="dummy" style="display:none;">
	<cfoutput>
		<script>
				_cf_loadingtexthtml="#Attributes.loading#";
	</script>
	</cfoutput>


<cfelse>

	</body>
	</html>

</cfif>
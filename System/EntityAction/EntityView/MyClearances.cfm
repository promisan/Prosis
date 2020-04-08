
<cfparam name="scope" 				default="default">
<cfparam name="URL.EntityGroup" 	default="">
<cfparam name="URL.Mission" 		default="">
<cfparam name="URL.Owner" 			default="">
<cfparam name="URL.Me" 				default="false">
<cfparam name="URL.mode" 			default="">
<cfparam name="URL.search" 			default="">

<!--- Start mobile application --->
<cf_mobile 
	appId="MyClearances" 
	validateLogin="Yes">

	<cf_dialogStaffing>
	<cf_systemscript>
	<cf_uigadgets>
	<cfinclude template="MyClearancesDataPrepare.cfm">
	<cfinclude template="MyClearancesScript.cfm">

	<style>
		.mainGroupTitle {
			font-size:175%;
			padding-top:10px;
		}

		.subGroupTitle {
			color:#808080;
			font-size:125%;
			border-bottom:1px solid #E1E1E1;
			padding-top:5px;
		}

		.pullTextRight {
			text-align:right;
		}

		.boldText {
			font-weight:bold;
		}

		.entityIcon { 
			font-size:80%;
			color: #E1E1E1;
		}

		.subGroupSubTitle {
			font-size:80%;
		}

		.form-control {
			margin-bottom:3px;
		}

		.rowHighlight:hover {
			background-color:#F7F7F7;
		}

		#head > div.animate-panel > div.animated-panel > div.hpanel {
			margin-bottom:0px;
		}
	</style>
	
	<cfset vParameters = "mode=#url.mode#&EntityGroup=#URL.EntityGroup#&Mission=#URL.Mission#&Owner=#URL.Owner#&me=#url.me#&search=#url.search#">
	<cfdiv style       = "position:sticky; top:0px; z-index:1; padding-bottom:0px;" bind="url:#SESSION.root#/system/entityaction/entityview/MyClearancesFilters.cfm?#vParameters#" id="head"/>
	<cfdiv bind        = "url:#SESSION.root#/system/entityaction/entityview/MyClearancesDetail.cfm?#vParameters#" id="listing"/>

</cf_mobile>
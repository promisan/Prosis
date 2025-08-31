<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.scope" 			default="default">
<cfparam name="URL.EntityGroup" 	default="">
<cfparam name="URL.Mission" 		default="">
<cfparam name="URL.Owner" 			default="">
<cfparam name="URL.EntityDue" 	  	default="due">
<cfparam name="URL.Me" 				default="false">
<cfparam name="URL.mode" 			default="">
<cfparam name="URL.search" 			default="">
<cfparam name="URL.height" 			default="100">

<cf_tl id="My Clearances" var="vMainLabel">
<cfset vLayout = "webapp">

<cf_screentop jquery="yes" bootstrap="yes" html="no" label="#vMainLabel#">

	<cf_dialogStaffing>
	<cf_systemscript>
	<cf_uigadgets>
	<cfinclude template="MyClearancesDataPrepare.cfm">
	<cfinclude template="MyClearancesScript.cfm">

	<style>
		.mainGroupTitle {
			font-size:175%;		
		}

		.subGroupTitle {			
			font-size:145%;
			border-bottom:1px solid #E1E1E1;
			padding-top:5px;
			height:30px;
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
			font-size:90%;
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

		.x-border-box, .x-border-box * {
		    box-sizing: border-box;
		    -moz-box-sizing: border-box;
		    -ms-box-sizing: border-box;
		}
	</style>

	<cfoutput>
		<div style="height:#URL.height#%;padding-left:15px;padding-right:15px;padding-bottom:60px" class="toggleScroll-y">
			<cfset vParameters = "mode=#url.mode#&EntityGroup=#URL.EntityGroup#&Mission=#URL.Mission#&Owner=#URL.Owner#&entityDue=#url.EntityDue#&me=#url.me#&search=#url.search#&scope=#url.scope#">
			<cfdiv style       = "position:sticky; top:0px; z-index:1; background-color:##FFFFFF; padding-bottom:0px; back" bind="url:#SESSION.root#/system/entityaction/entityview/MyClearancesFilters.cfm?#vParameters#" id="head"/>
			<cf_securediv bind = "url:#SESSION.root#/system/entityaction/entityview/MyClearancesDetail.cfm?#vParameters#" id="listing">
		</div>
	</cfoutput>

<cf_screenbottom layout="#vLayout#">
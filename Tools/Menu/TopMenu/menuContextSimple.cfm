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
<cfoutput>
	
	<cfparam name="attributes.template" default="prosis_test1">
	<cfparam name="attributes.align" default="left">
	<cfparam name="attributes.items" default="1">
	
	<script type="text/javascript">

	var dmWorkPath     =  "#SESSION.root#/Tools/Menu/Topmenu/#Attributes.template#.files/";
	var pathPrefix_img =  "#SESSION.root#/Tools/Menu/Topmenu/#Attributes.template#.files/";
	var arrowImageMain = ["#SESSION.root#/Tools/Menu/Topmenu/#Attributes.template#.files/arrv_black.gif",""];
	var arrowImageSub  = ["#SESSION.root#/Tools/Menu/Topmenu/#Attributes.template#.files/arr_black.gif","#SESSION.root#/Tools/Menu/topmenu/#Attributes.template#.files/arr_white.gif"];
	var blankImage     =  "#SESSION.root#/Tools/Menu/Topmenu/#Attributes.template#.files/blank.gif";
	
	var menuItems = 
	
	[
	
	<cfloop index="itm" from="1" to="#attributes.items#" step="1">
	
	   <cfparam name="attributes.item#itm#Level"  default="0">
	   <cfparam name="attributes.item#itm#Icon"   default="">
	   <cfparam name="attributes.item#itm#IconHL" default="#evaluate("attributes.item#itm#Icon")#">
	   <cfparam name="attributes.item#itm#Tool"   default="">
	   <cfparam name="attributes.item#itm#Target" default="_blank">
	  	
	   <cfset Level   = #evaluate("attributes.item#itm#Level")#>
	   <cfset Name    = #evaluate("attributes.item#itm#Name")#>
	   <cfset Command = #evaluate("attributes.item#itm#Command")#>
	   <cfset Icon    = #evaluate("attributes.item#itm#Icon")#>
	   <cfset IconHL  = #evaluate("attributes.item#itm#IconHL")#>
	   <cfset Tool    = #evaluate("attributes.item#itm#Tool")#>
	   <cfset Target  = #evaluate("attributes.item#itm#Target")#>
	 		
	   ["#name#","#command#", "#SESSION.root#/Images/#icon#", "#SESSION.root#/Images/#iconHL#", "#tool#", "#target#", "0", "0", , ],
	  	
	</cfloop>

	];
	
	</script>
	
	<script src="#SESSION.root#/Tools/Menu/Topmenu/#Attributes.template#.files/dmenu.js" type="text/javascript"></script>
    <script type="text/javascript" src="#SESSION.root#/tools/menu/Topmenu/#Attributes.template#.js"></script>	
	
</cfoutput>	

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
<!--- -------------------------------- --->


<cfset path = "#SESSION.root#/Images/Cart">		
<cfset modelist = "grayshadow,blueshadow,silver,graylarge,silverlarge,orangelarge,bluelarge,greenlarge,blacklarge,red">
<cfset status = "button,buttonhl,buttondown">

<cfoutput>

<style>	
	<cfloop list="#modelist#" index="i">	
		<cfloop list="#status#" index="s">
			<cfif s eq "buttondown" and i neq "grayshadow">
				<!--- buttondown only applies for mode grayshadow --->
				<cfbreak>
			</cfif>	
			.#i##s#left{ background-image:url('#path#/#i#/#s#_left_tip.png'); background-repeat:no-repeat; background-position:center }		
			.#i##s#center{ background-image:url('#path#/#i#/#s#_center_bg.png'); background-repeat:repeat-x; background-position:center  }		
			.#i##s#right{ background-image:url('#path#/#i#/#s#_right_tip.png'); background-repeat:no-repeat; background-position:center }	
		</cfloop>
	</cfloop>		

	.linkbuttonhlcenter{
	background-image:url('/apps/Images/Cart/link/buttonhl_center_bg.jpg');
	background-repeat:repeat-x;
	margin-left:0; 
	text-align:left;}
	
	.linkbuttoncenter{
	background-image:url('/apps/Images/Cart/link/button_center_bg.jpg');
	width:150px;
	text-align:left;}
	
	.linkbuttonleft{
	margin-left:0;
	width:0px;
	display:none;}
	
	.linkbuttonhlleft{
	display:none;}
	
	.linkbuttonright{
	width:0px;
	display:none;}
	
	.linkbuttonhlright{
	width:0;
	display:none;}
	
</style>

</cfoutput>	


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
<cf_tl id="My Picture" var="vTitle">

<cfparam name="attributes.acc" 			default="#session.acc#">
<cfparam name="attributes.width" 		default="54px">
<cfparam name="attributes.height" 		default="44px">
<cfparam name="attributes.mode" 		default="edit">
<cfparam name="attributes.module" 		default="user">
<cfparam name="attributes.title" 		default="#vTitle#">
<cfparam name="attributes.destination" 	default="EmployeePhoto">
<cfparam name="attributes.style" 		default="">

<cfset url.width = attributes.width>
<cfset url.height = attributes.height>

<cfajaximport tags="cfform">

<script>
	function _pr_changeProfilePicture() {
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/Portal/Photo/PhotoUpload.cfm?pictureDialog=__ProsisPresentation_picturedialog&widmodalbg=__ProsisPresentation_widmodalbg&Pic=__ProsisPresentation_Pic<cfoutput>&filename=#attributes.acc#&title=#attributes.title#&width=#url.width#&height=#url.height#&destination=#attributes.destination#&mode=#attributes.module#&style=#attributes.style#</cfoutput>','__ProsisPresentation_picturedialog');
		$('#__ProsisPresentation_widmodalbg').css('display','block'); 
		$('#__ProsisPresentation_picturedialog').slideDown(300);
	}	
</script>

<div id="__ProsisPresentation_userPic">
	<div id="__ProsisPresentation_Pic">			
		<cf_securediv bind="url:#session.root#/Portal/PhotoShow.cfm?acc=#attributes.acc#&height=#attributes.height#&width=#attributes.width#&destination=#attributes.destination#&mode=#attributes.module#&style=#attributes.style#">
	</div>
</div>

<cfset AjaxOnLoad("function(){ $('##__ProsisPresentation_Pic').click(function(){_pr_changeProfilePicture();}); }")>
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
<cf_screentop height="100%" scroll="Yes" html="no" JQuery="yes">

<cfoutput>
	<link rel="stylesheet" href="#session.root#/Scripts/FlexSlider/flexslider.css" type="text/css" media="screen" />
	<script defer src="#session.root#/Scripts/FlexSlider/jquery.flexslider.js"></script>
</cfoutput>

<style>
	body, td, div, select, .labelit, .labelmedium, .labellarge { 
		font-family: "Century Gothic", CenturyGothic, "Avant Garde", Avantgarde, "AppleGothic", Verdana, Arial, sans-serif;
	}
	
	.clsPicture {
		-webkit-transition: all 0.3s ease;                  
    	-moz-transition: all 0.3s ease;                 
    	-o-transition: all 0.3s ease;   
    	-ms-transition: all 0.3s ease;          
    	transition: all 0.3s ease;
	}
	
	.rotate {
		transform: rotate(90deg);
	    -webkit-transform: rotate(90deg);
	    -moz-transform: rotate(90deg);
		-o-transform: rotate(90deg);
		-ms-transform: rotate(90deg);
	    filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1);
	}
</style>

<cf_layoutScript>

<cfajaximport tags="cfform,cfdiv">

<script>
	_cf_loadingtexthtml="<cfoutput><img src='#session.root#/images/busy10.gif' style='height:26px; width:26px;'></cfoutput>";
	
	function selectOrgUnit(pub,orgunit){
		ColdFusion.navigate('WorkActionPictures.cfm?publicationId='+pub+'&orgUnit='+orgunit,'actionsContainer');
		$('.clsOrgUnit').css('background-color','').css('border-style','none');
		$('#orgUnit_'+orgunit).css('background-color','#FAD88F').css('border','1px dotted #C0C0C0');
	}
</script>

<table height="100%" width="100%">
	<tr>
		<td height="100%">
		
			<cf_layout type="border" id="workActionLayout" style="height:99.9%; min-height:99.9%; width:100%; border-top:1px solid ##EDEDED; border-bottom:1px solid ##EDEDED; border-right:1px solid ##EDEDED;">

				<cf_layoutArea 
					name="left" 
					position="left" 
					size="250" 
					collapsible="true">
					
					<cf_divScroll>
						<table width="100%" height="100%">
							<tr>
								<td id="orgUnitsContainer">
									<cfinclude template="getOrgUnit.cfm">
								</td>
							</tr>
						</table>
					</cf_divScroll>
					
				</cf_layoutArea>
				
				<cf_layoutArea 
					name="center" 
					position="center" 						
					size="100%">
						<cf_divScroll>
							<table width="100%" height="100%">
								<tr>
									<td id="actionsContainer"></td>
								</tr>
							</table>
						</cf_divScroll>
				</cf_layoutArea>
				
			</cf_layout>
				
		</td>
	</tr>
	
</table>
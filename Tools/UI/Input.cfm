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
<cfparam name="attributes.type"	 	default = "">
<cfparam name="attributes.name"	 	default = "picker">
<cfparam name="attributes.palette"	default = "basic">
<cfparam name="attributes.ajax"	    default = "No">
<cfparam name="attributes.enabled"  default = "Yes">
<cfparam name="attributes.OnChange"  default = "">
<cfparam name="attributes.startLabel"  default = "">
<cfparam name="attributes.endLabel"  default = "">
<cfparam name="attributes.position"  default = "horizontal">
<cfparam name="attributes.DateValidStart"  default = "">
<cfparam name="attributes.DateValidEnd"  default = "">


<!--- used when the input is a color
		basic
		websafe
		basic
		monochrome
		login
		apex
		austin
		clarity
		slipstream
		metro
		flow
		hardcover
		trek
		verve
		icons
---->

<cfswitch expression="#attributes.type#">

	<cfcase value="ColorPicker">
		<cfoutput>
			<cfparam name="attributes.value" default = "##cc2222">
			<div id="_k_#attributes.name#" class="k-content">
				<input id="#attributes.name#" name="#attributes.name#" class="colorPicker" value="#attributes.value#" data-role="colorpicker" data-palette="#attributes.palette#">
			</div>			
	
			<cfif attributes.ajax eq false>
			     <script>
		         	$(document).ready(function() {
							kendo.init($('##_k_#attributes.name#'));
							<cfif attributes.enabled eq "No">
								var colorpicker =$("###attributes.name#").data("kendoColorPicker");
								colorpicker.enable(false);
							</cfif>
		         	});
		     	</script>
			 </cfif>
		 </cfoutput>		
	</cfcase>
	<cfcase value="dateRangePicker">

		<cfoutput>
			<div id="#attributes.name#" name="#attributes.name#" class="calendarRangePicker"></div>
			
			<input type="hidden" id="#attributes.name#_start"      name="#attributes.name#_start"      value="#attributes.DateValidStart#">
			<input type="hidden" id="#attributes.name#_end"        name="#attributes.name#_end"        value="#attributes.DateValidEnd#">			
			<input type="hidden" id="#attributes.name#_lbl_start"  name="#attributes.name#_lbl_start"  value="#attributes.startLabel#">
			<input type="hidden" id="#attributes.name#_lbl_end"    name="#attributes.name#_lbl_end"    value="#attributes.endLabel#">			
			<input type="hidden" id="#attributes.name#_enabled"    name="#attributes.name#_enabled"    value="#attributes.enabled#">			
			<input type="hidden" id="#attributes.name#_onchange"   name="#attributes.name#_onchage"    value="#attributes.onchange#">			
			<input type="hidden" id="#attributes.name#_date_start" name="#attributes.name#_date_start" value="#attributes.DateValidStart#">
			<input type="hidden" id="#attributes.name#_date_end"   name="#attributes.name#_date_end"   value="#attributes.DateValidEnd#">
			
			<cfset AjaxOnLoad("function (){ProsisUI.doCalendarRange('#attributes.name#')}")>
			<cfif attributes.position eq "vertical">
				<style>
				###attributes.name# .k-textbox-container {
					display:block;
				}
				
				input.k-textbox {
					border-color:silver !important;  
				}
				
				</style>
			</cfif>

		</cfoutput>


	</cfcase>

	<cfcase value="IconMap">
		<cfparam name="attributes.value" default = "">
		<cfparam name="attributes.color" default = "">

		<cfset aIcons = "0,1,2,3,4">
		<cfif NOT ListFind(aIcons, attributes.value)>
			<cfset attributes.value = 0>			
		</cfif>
		
		<cfset aColors = "'ddd1c3','d2d2d2','746153','ffcc33','ff6b21','fb455f','ac120f','3a4c8b','0018f4','33cc99'">
		<cfif NOT ListContains(aColors, attributes.color)> 
 			<cfset attributes.color = "ddd1c3">
		</cfif>
		
		<cfoutput>
			<table bgcolor="eaeaea" style="border:1px solid silver">
				<tr>
					<td align="left" width="210px" style="padding-left:2px">
						<div id= "_color_#attributes.name#" name= "_color_#attributes.name#" style="height:100%;width:200px"></div>
					</td>
					<td align="left" align="right" width="40px">
						<input type="hidden" id="MarkerColor" 		name="MarkerColor" value="#attributes.color#"/>
						<input type="text"   id="#attributes.name#" name="#attributes.name#" />
					</td>	
					<td align="left" style="padding-right:2px;padding-left:2px;border-left:1px solid silver">
						<img id="_#attributes.name#" name="_#attributes.name#" style="height:22px" src="<cfoutput>#client.root#/images/mapicons/#attributes.color#_#attributes.value#.png</cfoutput>"/>
					</td>
				</tr>		
			</table>									
							
		</cfoutput>	
				
		<cfif attributes.ajax eq false>
		
			<script>
			
			$(document).ready(function() {

		        $("#_color_<cfoutput>#attributes.name#</cfoutput>").kendoColorPalette({
					palette: [ <cfoutput>#aColors#</cfoutput>],
		            tileSize: 20,
		            value: "<cfoutput>#attributes.color#</cfoutput>",
					change: function() {
		                var colorId      = this.value().substring(1);
						var dropdownlist = $("#<cfoutput>#attributes.name#</cfoutput>").data("kendoDropDownList");
						var value        = dropdownlist.select();
						$('#MarkerColor').val(colorId);
						$('#_<cfoutput>#attributes.name#</cfoutput>').attr('src','<cfoutput>#client.root#</cfoutput>/images/mapicons/'+colorId+'_'+value+'.png');						
		            }					
		        });							
									
				$('#<cfoutput>#attributes.name#</cfoutput>').kendoDropDownList({
				  optionLabel: {
				        name: "Pin",
				        id  : 0
				  },
				  dataSource: [
				    { id: 1, name: "Balloon" },
					{ id: 2, name: "Office" },
					{ id: 3, name: "City" },
					{ id: 4, name: "Home" }
				  ],
				  dataTextField   : "name",
				  dataValueField  : "id",
				  template		  : '<span><img src="<cfoutput>#client.root#</cfoutput>/images/mapicons/<cfoutput>#attributes.color#</cfoutput>_#: id #.png" alt="#: name #" />#: name #</span>',
				  value   		  : <cfoutput>'#attributes.value#'</cfoutput>,
				  change  		  : function(e) {
    					var value 	    = this.value();
						var colorpicker = $("#_color_<cfoutput>#attributes.name#</cfoutput>").data("kendoColorPalette");
						var colorId     = colorpicker.value().substring(1);
						$('#MarkerColor').val(colorId);
						$('#_<cfoutput>#attributes.name#</cfoutput>').attr('src','<cfoutput>#client.root#</cfoutput>/images/mapicons/'+colorId+'_'+value+'.png');
  					}				  
				});
			});	
			</script>		
		</cfif>	
	</cfcase> 	
</cfswitch>

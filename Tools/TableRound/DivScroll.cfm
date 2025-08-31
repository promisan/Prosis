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
	<cfparam name="Attributes.close" 			default="yes">
	<cfparam name="Attributes.backgroundclose"  default="yes">
    <cfparam name="Attributes.onclose" 			default="">
    <cfparam name="Attributes.overflowx" 		default="hidden"> 	<!--- Standard cross compatible HORIZONTAL scrollbar  --->
	<cfparam name="Attributes.overflowy" 		default="auto"> 	<!--- Standard cross compatible VERTICAL scrollbar  --->
	<cfparam name="Attributes.hiddenScroll"		default="true">
	<cfparam name="Attributes.height" 			default="100%">
	<cfparam name="Attributes.width" 			default="100%">
	<cfparam name="Attributes.padding" 			default="0">
	<cfparam name="Attributes.bgcolor" 			default="transparent"> <!---  Main DIV Background color  --->
	<cfparam name="Attributes.zindex" 			default="1"> 		<!--- Layer the div to a certain depth level  --->
	<cfparam name="Attributes.float" 			default="no">		<!--- Make the div position:ABSOLUTE, therefore floating --->
	<cfparam name="Attributes.drag" 			default="no"> 		<!--- MUST be used with FLOAT="YES" and dragHandler must be used in the ajax request--->
	<cfparam name="Attributes.modal" 			default="no">
	<cfparam name="Attributes.scrollcolor" 		default="ffffff"> 	<!--- Scrollbar color --->
	<cfparam name="Attributes.hide" 			default="no"> 		<!--- Hide the div - Is used for jQuery fadeIn effect mainly --->
	<cfparam name="Attributes.draghandles" 		default="yes">
    <cfparam name="Attributes.resize" 		    default="">         <!--- CSS3 param, takes 'both', 'vertical' and 'horizontal' --->
    <cfparam name="client.veffects"        		default="">	
	<cfparam name="attributes.mode"             default="quirks">
	<cfparam name="client.browser" 				default="Explorer">

	<cfparam name="Attributes.Top" 				default="50%"> 		<!--- Div is NN % down from the main body or iframe element  --->
	<cfparam name="Attributes.Left" 			default="50%"> 		<!--- Div is NN % right from the main body or iframe element --->
	
	<cfparam name="Attributes.TouchScroll"		default="no">		<!--- Enables touch scroll support --->
	
	<!--- Provision for Height and Width removing 'px' from attributes for a math operation--->
	<cfset Attributes.height = replace(Attributes.height,"px","","ALL")>
	<cfset Attributes.width  = replace(Attributes.width,"px","","ALL")>
    
    <!--- Provision for inferring correct drag Attribute --->
    <cfif Attributes.drag neq "no" and Attributes.drag neq "yes" and Attributes.drag neq "">
    	<cfset attributes.drag = "yes">
    </cfif>
    <!--- Provision for inferring correct float Attribute --->
    <cfif Attributes.float eq "no" and Attributes.drag neq "no">
    	<cfset attributes.float = "yes">
    </cfif>
    <!--- Provision for inferring correct float Attribute --->
    <cfif Attributes.modal neq "no" and Attributes.float eq "no">
    	<cfset attributes.float = "yes">
    </cfif>
	
	<cfset vTouchScroll = "">
	<cfif Attributes.TouchScroll eq "yes">
		<cfset vTouchScroll = "-ms-overflow-style:-ms-autohiding-scrollbar; -webkit-overflow-scrolling:touch; ">
	</cfif>
		
	<cfoutput>	
	
		<cfif attributes.mode neq "quirks">
			<cfset px = "px">
		<cfelse>
			<cfset px = "">
		</cfif>

		<cfif thisTag.ExecutionMode is "start">

			<cfif Attributes.drag eq "yes">
				<!---   JS for dragging function, must be invoked at the top level of page, otherwise include manually   --->
				<script type="text/javascript" src="#SESSION.root#/Scripts/Drag/draggable.js"></script>			
			</cfif>
	
			<cfif Attributes.float eq "no">			
				<div style="#vTouchScroll# ffffff; position:relative; width:#Attributes.width##px#; height:#Attributes.height##px#; min-height:#Attributes.height##px#; max-height:#Attributes.height##px#; overflow-x:hidden; overflow-y:hidden; padding:0px; margin:0px; <cfif attributes.hide neq "no">display:none</cfif>">
			</cfif>		

			<cfset vToggleScrollXClass = "">
			<cfset vToggleScrollXStyle = "overflow-x:#Attributes.overflowx#;">
			<cfif lcase(trim(Attributes.overflowx)) neq "hidden" AND lcase(trim(Attributes.overflowx)) neq "none">
				<cfif lcase(trim(Attributes.hiddenScroll)) eq "true" OR lcase(trim(Attributes.hiddenScroll)) eq "yes" OR lcase(trim(Attributes.hiddenScroll)) eq "1">
					<cfset vToggleScrollXClass = "toggleScroll-x">
					<cfset vToggleScrollXStyle = "">
				</cfif>
			</cfif>

			<cfset vToggleScrollYClass = "">
			<cfset vToggleScrollYStyle = "overflow-y:#Attributes.overflowy#;">
			<cfif lcase(trim(Attributes.overflowy)) neq "hidden" AND lcase(trim(Attributes.overflowy)) neq "none">
				<cfif lcase(trim(Attributes.hiddenScroll)) eq "true" OR lcase(trim(Attributes.hiddenScroll)) eq "yes" OR lcase(trim(Attributes.hiddenScroll)) eq "1">
					<cfset vToggleScrollYClass = "toggleScroll-y">
					<cfset vToggleScrollYStyle = "">
				</cfif>
			</cfif>		
						
			<div id="#Attributes.id#" name="#Attributes.id#"
                     <cfif Attributes.float neq "no" and Attributes.close eq "yes">
                        onkeydown="if (event.keyCode == 27){document.getElementById('#Attributes.id#').style.display = 'none'; document.getElementById('modalbg').style.display = 'none'}"
                     </cfif>
					 class="clsCFDIVSCROLL_MainContainer #vToggleScrollXClass# #vToggleScrollYClass# <cfif Attributes.drag neq "no">drag </cfif>"
					 
					 style="#vTouchScroll# 
					 		position:absolute;
					 		#vToggleScrollXStyle#
							#vToggleScrollYStyle#
							width:#Attributes.width##px#; 
							height:#Attributes.height##px#;
							min-height:#Attributes.height##px#;
							max-height:#Attributes.height##px#;
							background-color:#Attributes.bgcolor#;
							margin:0; 
							padding:#Attributes.padding#;
							scrollbar-face-color: #Attributes.scrollcolor#;
							scrollbar-track-color: #Attributes.scrollcolor#;
							z-index:#Attributes.zindex#;
								<cfif attributes.hide neq "no">
									display:none;
								</cfif>
                                <cfif attributes.resize neq "">
									<!--- CSS3 property for resizing divscroll seamlessly on Chrome/FF --->
                                	resize:#attributes.resize#;
                                </cfif>
								<cfif Attributes.float neq "no" and Attributes.drag neq "yes">
									top:#Attributes.Top#;
									left:#Attributes.Left#;
									margin-top:-#Attributes.height/2##px#;
									margin-left:-#Attributes.width/2##px#;	
                                <cfelseif Attributes.drag eq "yes">	
                                <!--- needed as the dragHandler script looks for this property to exist --->
                                	top:0;
									left:0;				
								</cfif>								
							">					
			  														                            
                            <cfif Attributes.float neq "no" and Attributes.close eq "yes" and Attributes.id neq "">
																					
                            	<div id="#Attributes.id#_close"
                                	style="
									#vTouchScroll#
									position:absolute; 
                                    right:1px; 
                                    top:0px; 
                                    width:30px; 
                                    height:30px; 
									z-index:9;
                                    cursor:pointer" 
                                    title="Close" 
                                    onclick="try {$('###Attributes.id#').fadeOut(300); } catch (e) {document.getElementById('#Attributes.id#').style.display = 'none';} try {document.getElementById('modalbg').style.display = 'none'} catch (e) {}; try {#Attributes.onclose#} catch(e) {}">
                                	<img id="closemodal" name="closemodal" src="#SESSION.root#/Images/close.png" width="30px" height="30px" style="z-index:2; display:block">
                                </div>
                            </cfif>

							<cfif Attributes.float neq "no" and Attributes.drag neq "no" and Attributes.draghandles neq "no">
								<div style="position:absolute; right:1px; bottom:0px; width:15px; height:11px; cursor:move">
                                	<img src="#SESSION.root#/Images/draghandle.png" width="15px" height="11px" style="z-index:2; display:block">
                                </div>		
								<div style="position:absolute; left:1px; bottom:0px; width:15px; height:11px; cursor:move">
                                	<img src="#SESSION.root#/Images/draghandle.png" width="15px" height="11px" style="z-index:2; display:block">
                                </div>		
								<div style="position:absolute; left:1px; top:0px; width:15px; height:11px; cursor:move">
                                	<img src="#SESSION.root#/Images/draghandle.png" width="15px" height="11px" style="z-index:2; display:block">
                                </div>					
							</cfif>
							
		<cfelse>
		
				</div>
			<cfif Attributes.float eq "no">
			</div>
			</cfif> 
			
			<cfif Attributes.modal neq "no" and Attributes.float neq "no">
				<cfif client.browser eq "Explorer" and attributes.mode eq "quirks">
					<img id="modalbg" 
                    	name="modalbg" 
                        src="#SESSION.root#/Images/modal_bg.png" 
                        width="4000px" 
                        height="2000px" 
                        style="position:absolute; top:10px; left:80%; margin-left:-2000; margin-top:-10; z-index:9099" 
                        <cfif Attributes.close eq "yes" and Attributes.backgroundclose eq "yes">
                        	onclick="try {$('###Attributes.id#').fadeOut(400);} catch(e) {document.getElementById('#Attributes.id#').style.display = 'none';} document.getElementById('modalbg').style.display = 'none'; try {#Attributes.onclose#} catch(e) {alert('divscroll onclose function has an error');}"
						</cfif>
                        >
				<cfelse>
					<div id="modalbg" 
                        name="modalbg" 
						style="filter: Alpha(Opacity=40); -moz-opacity:0.4; opacity: 0.4; width: 100%; height: 100%; background-color: ##999999; position: absolute; z-index: 9099; top: 0px; left: 0px;" 
                        <cfif Attributes.close eq "yes" and Attributes.backgroundclose eq "yes">
							onclick="try {$('###Attributes.id#').fadeOut(400);} catch(e) {document.getElementById('#Attributes.id#').style.display = 'none';}; document.getElementById('modalbg').style.display = 'none'; try {#Attributes.onclose#} catch(e) {alert('divscroll onclose function has an error');}"
                        </cfif>
                        >						
					</div>
				</cfif>
			</cfif>		
		
        <!---  This triggers the drag function when the Ajax call finishes --->
        <cfif Attributes.drag neq "no" and Attributes.float neq "no">
        	<cfset AjaxOnLoad("dragHandler")> 
        </cfif>
        
		</cfif>
		
	</cfoutput>

	
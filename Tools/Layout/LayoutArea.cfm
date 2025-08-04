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
<cfparam name="attributes.type"           			default="">
<cfparam name="attributes.name"           			default="">
<cfparam name="attributes.id"           			default="">
<cfparam name="attributes.parentId"        			default="">
<cfparam name="attributes.position"        			default="">
<cfparam name="attributes.backgroundColor"    		default="">
<cfparam name="attributes.stateIconHeight"     		default="24px">
<cfparam name="attributes.title"        			default="">
<cfparam name="attributes.source"        			default="">
<cfparam name="attributes.label"        			default="">
<cfparam name="attributes.labelBackgroundColor"   	default="">
<cfparam name="attributes.labelHeight"       		default="40px">
<cfparam name="attributes.labelFont"       			default="calibri">
<cfparam name="attributes.labelFontSize"       		default="14px">
<cfparam name="attributes.labelFontColor"      		default="black">
<cfparam name="attributes.labelIcon"       			default="">
<cfparam name="attributes.labelIconHeight" 			default="24px">
<cfparam name="attributes.animationType"			default="swing"> <!---http://jqueryui.com/resources/demos/effect/easing.html--->
<cfparam name="attributes.animationDelay"    	   	default="750">
<cfparam name="attributes.style"       				default="">
<cfparam name="attributes.size"       				default="auto">
<cfparam name="attributes.maxSize"       			default="auto">
<cfparam name="attributes.minSize"       			default="auto">
<cfparam name="attributes.togglerColor"      	 	default="rgba(255, 255, 255, 0)">
<cfparam name="attributes.togglerBorder"     	  	default="1px solid ##EDEDED">
<cfparam name="attributes.togglerBorderColor"	  	default="##EDEDED">
<cfparam name="attributes.togglerOpenIcon"    	 	default="">
<cfparam name="attributes.togglerCloseIcon"    	 	default="">
<cfparam name="attributes.onshow"       			default="">
<cfparam name="attributes.onhide"       			default="">
<cfparam name="attributes.onrefresh"       			default="">
<cfparam name="attributes.collapsible"       		default="false">
<cfparam name="attributes.overflow"  	     		default=""> <!--- Different depending on the type and position --->
<cfparam name="attributes.initcollapsed"       		default="">

<cfif thisTag.ExecutionMode is "start">
	
	<!---Set the default header size for Borders--->
	<cfset vTotalBorderHeaderSize = "54px">
	
	<cfset parentLayout = getbasetagdata("CF_LAYOUT")>
     
    <cfif parentLayout.thisTag.executionmode neq 'inactive'>
		<!---nothing--->
    <cfelse>
		<cfset attributes.parentId = parentLayout.attributes.id>
		<cfif attributes.type eq "">
			<cfset attributes.type = parentLayout.attributes.type>
		</cfif>
	</cfif>
	
	<cfswitch expression="#lcase(attributes.type)#">
		<cfcase value="accordion">
			<cfif attributes.initcollapsed eq "">
				<cfset attributes.initcollapsed = "true">
			</cfif>
			
			<cfif attributes.overflow eq "">
				<cfset attributes.overflow = "hidden">
			</cfif>
			
			<cfif attributes.style eq "">
				<cfset attributes.style = "border:0px dotted ##C0C0C0; padding:5px;">
			</cfif>
			
			<cfif attributes.togglerOpenIcon eq "">
				<cfset attributes.togglerOpenIcon = "plusBlue.png">
			</cfif>
			
			<cfif attributes.togglerCloseIcon eq "">
				<cfset attributes.togglerCloseIcon = "minusBlue.png">
			</cfif>
		</cfcase>
		
		<cfcase value="border">
			<cfif attributes.initcollapsed eq "">
				<cfset attributes.initcollapsed = "false">
			</cfif>
			
			<cfif attributes.style eq "">
				<cfset attributes.style = "">
			</cfif>
			
			<cfif ucase(attributes.position) eq "RIGHT" or ucase(attributes.position) eq "LEFT">
				<cfif attributes.overflow eq "">
					<cfset attributes.overflow = "auto">
				</cfif>
				
				<cfif attributes.togglerOpenIcon eq "">
					<cfif ucase(attributes.position) eq "RIGHT">
						<cfset attributes.togglerOpenIcon = "HTML5/Gray/right.png">
					</cfif>
					<cfif ucase(attributes.position) eq "LEFT">
						<cfset attributes.togglerOpenIcon = "HTML5/Gray/left.png">
					</cfif>
				</cfif>
				
				<cfif attributes.togglerCloseIcon eq "">
					<cfif ucase(attributes.position) eq "RIGHT">
						<cfset attributes.togglerCloseIcon = "HTML5/Gray/left.png">
					</cfif>
					<cfif ucase(attributes.position) eq "LEFT">
						<cfset attributes.togglerCloseIcon = "HTML5/Gray/right.png">
					</cfif>
				</cfif>
			</cfif>		
			
			<cfif ucase(attributes.position) eq "TOP" or ucase(attributes.position) eq "BOTTOM">
				<cfif attributes.overflow eq "">
					<cfset attributes.overflow = "hidden">
				</cfif>
				
				<cfif attributes.togglerOpenIcon eq "">
					<cfif ucase(attributes.position) eq "TOP">
						<cfset attributes.togglerOpenIcon = "HTML5/Gray/up.png">
					</cfif>
					<cfif ucase(attributes.position) eq "BOTTOM">
						<cfset attributes.togglerOpenIcon = "HTML5/Gray/down.png">
					</cfif>
				</cfif>
				
				<cfif attributes.togglerCloseIcon eq "">
					<cfif ucase(attributes.position) eq "TOP">
						<cfset attributes.togglerCloseIcon = "HTML5/Gray/down.png">
					</cfif>
					<cfif ucase(attributes.position) eq "BOTTOM">
						<cfset attributes.togglerCloseIcon = "HTML5/Gray/up.png">
					</cfif>
				</cfif>
			</cfif>
			
			<cfif ucase(attributes.position) eq "CENTER" or ucase(attributes.position) eq "HEADER">
				<cfif attributes.overflow eq "">
					<cfset attributes.overflow = "hidden">
				</cfif>
			</cfif>	
			
			<cfif ucase(attributes.position) eq "HEADER">
				<cfif attributes.size eq "" or attributes.size eq "auto">
					<cfset attributes.size 		= vTotalBorderHeaderSize>
				</cfif>
				<cfif attributes.minsize eq "" or attributes.minsize eq "auto">
					<cfset attributes.minsize 	= vTotalBorderHeaderSize>
				</cfif>
				<cfif attributes.maxsize eq "" or attributes.maxsize eq "auto">
					<cfset attributes.maxsize 	= vTotalBorderHeaderSize>
				</cfif>
			</cfif>
			
		</cfcase>
	</cfswitch>
	
	<cfif attributes.id eq "">
		<cfset attributes.id = attributes.name>
	</cfif>
	
	<cfif attributes.label eq "">
		<cfset attributes.label = attributes.title>
	</cfif>
	
	<cfset __prosisPresentation_layoutAreaHeight			= "min-height:100px; height:80%;">
	<cfset __prosisPresentation_togglerLayoutAreaTextStyle 	= "padding-left:8px; padding-top:4px; padding-bottom:4px; font-family:#attributes.labelFont#; font-size:#attributes.labelFontSize#; color:#attributes.labelFontColor#;">
	<cfset __prosisPresentation_togglerLayoutAreaStyle 		= "height:#attributes.labelHeight#; font-family:#attributes.labelFont#; border:#attributes.togglerBorder#; background-color:###attributes.togglerColor#; padding-left:5px;">
	
	<cfset __prosisPresentation_layoutAreaOnShow = "">
	<cfif attributes.onshow neq "">
		<cfset __prosisPresentation_layoutAreaOnShow = attributes.onshow>
	</cfif>
	
	<cfset __prosisPresentation_layoutAreaOnHide = "">
	<cfif attributes.onhide neq "">
		<cfset __prosisPresentation_layoutAreaOnHide = attributes.onhide>
	</cfif>
	
	<cfset __prosisPresentation_layoutAreaState 	= "display:none;">
	<cfset __prosisPresentation_layoutAreaStateText = "font-size:100%;">
	<cfset __prosisPresentation_layoutAreaStateIcon = attributes.togglerOpenIcon>
	<cfif lcase(attributes.initcollapsed) eq "false">
		<cfset __prosisPresentation_layoutAreaState 	= "display:table-row;">
		<cfset __prosisPresentation_layoutAreaStateText = "font-size:125%;">
		<cfset __prosisPresentation_layoutAreaStateIcon = attributes.togglerCloseIcon>
	</cfif>

	<cfoutput>
	
		<cfswitch expression="#lcase(attributes.type)#">
		
			<cfcase value="accordion">
			
				<cfset _prosisPresentationColSpan = 1>
			
				<!--- Toggler --->
				<tr 
					style="cursor:pointer;" 
					class="#attributes.parentId#_clsTogglerLayoutArea" 
					id="#attributes.parentId#_togglerLayoutArea_#attributes.id#">
					
					<td 
						style="#__prosisPresentation_togglerLayoutAreaStyle# width:100%;"
						onmousedown="toggleLayoutArea('#attributes.parentId#', '#attributes.id#', #attributes.animationDelay#, '#attributes.togglerOpenIcon#', '#attributes.togglerCloseIcon#', function() { #__prosisPresentation_layoutAreaOnShow# });">
					
						<table width="100%" align="center">
							<tr>
								<td width="1%" style="padding-left:8px;">
									<img class="#attributes.parentId#_clsTogglerLayoutAreaImage" style="height:#attributes.stateIconHeight#;" src="#session.root#/Images/#__prosisPresentation_layoutAreaStateIcon#">
								</td>
								<cfif attributes.labelIcon neq "">
								<td width="1%" style="padding-left:8px;">
									<img style="height:#attributes.labelIconHeight#;" src="#session.root#/Images/#attributes.labelIcon#">
								</td>
								</cfif>
								<td class="#attributes.parentId#_clsTogglerLayoutAreaText" style="#__prosisPresentation_togglerLayoutAreaTextStyle# #__prosisPresentation_layoutAreaStateText#" height="20">
									#attributes.label#
								</td>
							</tr>
						</table>
					</td>
					<cfif attributes.onrefresh neq "">
						<cfset _prosisPresentationColSpan = 2>
						<td align="right" style="#__prosisPresentation_togglerLayoutAreaStyle# padding-right:8px; width:1%;" onclick="#attributes.onrefresh#">
							<img src="#session.root#/images/Refresh-Gray.png" width="24" height="24">
						</td>
					</cfif>
				</tr>
				
				<!--- Container --->
				<tr 
					id="#attributes.parentId#_containerLayoutArea_#attributes.id#" 
					class="#attributes.parentId#_clsLayoutArea" 
					style="#__prosisPresentation_layoutAreaState#">
					
					<td id="#attributes.parentId#_layoutArea_#attributes.id#" style="height:100%; min-height:100%; width:100%;" colspan="#_prosisPresentationColSpan#">	
						<table width="100%" height="100%" align="center">
							<tr>
								<td valign="top" style="#attributes.style# #__prosisPresentation_layoutAreaHeight# background-color:#attributes.backgroundColor#;">
			
			</cfcase>
			
			<cfcase value="border">
						
				<div id="#attributes.parentId#_tempContainer_#attributes.id#" style="display:none;">

				<!--- put the temp content in an html comment --->

				<!--
			</cfcase>
			
		</cfswitch>
							
	</cfoutput>
	
<cfelse>

	<cfoutput>
		
		<cfswitch expression="#lcase(attributes.type)#">
			
			<cfcase value="accordion">
	
									</td>
								</tr>
							</table>							
						</td>
					</tr>
					<tr><td style="height:5px;"></td></tr>
				
			</cfcase>
			
			<cfcase value="border">
				-->
				
				</div>
							
																
				<script>
					function #attributes.parentId#_initBorderLayout_#attributes.parentId#_#attributes.id# () {
						setIdBorderSection('#attributes.parentId#','#attributes.id#','#ucase(attributes.position)#');
						appendBorderSection('#attributes.parentId#','#attributes.id#', "#attributes.source#");
						setOverflowBorderSection('#attributes.parentId#','#attributes.id#','#lcase(attributes.overflow)#');
						onEvents('#attributes.parentId#','#ucase(attributes.position)#', '#attributes.animationType#', '#attributes.animationDelay#', '#attributes.togglerOpenIcon#', '#attributes.togglerCloseIcon#', function() { #__prosisPresentation_layoutAreaOnShow# }, function() { #__prosisPresentation_layoutAreaOnHide# }, '#attributes.id#');
						showBorderSection('#attributes.parentId#','#ucase(attributes.position)#');
						setLabelBorderSection('#attributes.parentId#','#ucase(attributes.position)#','#attributes.label#','#__prosisPresentation_togglerLayoutAreaTextStyle#','#attributes.labelBackgroundColor#');
						setStatusBorderSection('#attributes.parentId#','#ucase(attributes.position)#','#lcase(attributes.initcollapsed)#');
						applyBorderAttributes('#attributes.parentId#','#ucase(attributes.position)#', '#attributes.togglerBorderColor#', '#attributes.togglerColor#', '#attributes.backgroundColor#', '#attributes.collapsible#', '#attributes.size#','#attributes.maxSize#','#attributes.minSize#', '#lcase(attributes.initcollapsed)#', '#attributes.togglerOpenIcon#', '#attributes.togglerCloseIcon#', '#attributes.style#');
					}
					#attributes.parentId#_initBorderLayout_#attributes.parentId#_#attributes.id# ();
				</script>
								
				
			</cfcase>
				
		</cfswitch>
		
	</cfoutput>
		
</cfif>
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
<cfparam name="attributes.id"  					default="">
<cfparam name="attributes.type"  				default="button"> <!--- button, reset, submit, print --->
<cfparam name="attributes.mode"  				default="button"> <!--- button, link, icon --->
<cfparam name="attributes.width"				default="100px">
<cfparam name="attributes.height"				default="30px">
<cfparam name="attributes.borderColor"			default="##808080">
<cfparam name="attributes.bordercolorInit"	    default="black">
<!---
<cfparam name="attributes.fontFamily"			default="'Century Gothic',CenturyGothic,'Avant Garde',Avantgarde,AppleGothic,Verdana,Arial,sans-serif !important;">
--->
<cfparam name="attributes.fontFamily"			default="-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,'Raleway', sans-serif;">
<cfparam name="attributes.borderRadius"			default="4px">
<cfparam name="attributes.bgColor"				default="##F4F4F4">
<cfparam name="attributes.style"				default="">
<cfparam name="attributes.class"				default="">
<cfparam name="attributes.image"				default="">
<cfparam name="attributes.imageHeight"			default="25px">
<cfparam name="attributes.imagepos"				default="left">
<cfparam name="attributes.text"					default="">
<cfparam name="attributes.textSize"				default="13px">
<cfparam name="attributes.subText"				default="">
<cfparam name="attributes.subTextSize"			default="14px">
<cfparam name="attributes.textColor"			default="black">
<cfparam name="attributes.textAlign"			default="">
<cfparam name="attributes.title"				default="">

<cfparam name="attributes.onclick"				default="">
<cfparam name="attributes.onmouseover"			default="">
<cfparam name="attributes.onmouseout"			default="">


<!--- Print Attributes --->
<cfparam name="attributes.printIcon"			default="Print.png"> <!--- jquery selector --->
<cfparam name="attributes.printTitle"			default=""> <!--- jquery selector --->
<cfparam name="attributes.printContent"			default=""> <!--- jquery selector --->
<cfparam name="attributes.printCallback"		default=""> <!--- javascript function, i.e.: function() { alert('test'); } --->
<cfparam name="attributes.printShowUser"		default="true">
<cfparam name="attributes.printAfterClick"		default="true"> <!--- true = prints after the onclick event, false = prints before the onclick event --->


<cfset vType = trim(attributes.type)>
<cfset vOnClickEvent = trim(attributes.onclick)>
<cfset vImageSrc = trim(attributes.image)>
<cfset vTextColor = trim(attributes.textColor)>
<cfset vBGColor = trim(attributes.bgColor)>
<cfset vTitle = trim(attributes.title)>
<cfset vTextAlign = trim(attributes.textAlign)>
<cfset vBorderRadius = trim(attributes.borderRadius)>
<cfset vFontFamily = trim(attributes.fontFamily)>

<!--- ----------------------------- -------- -------------------------------- --->
<!--- ------------------------- Default Values ------------------------------ --->
<!--- ----------------------------- -------- -------------------------------- --->

<!--- Type --->
<cfif vType eq "print">
	<cfset vType = "button">
	
	<cfif attributes.printAfterClick eq "true">
		<cfset vOnClickEvent = vOnClickEvent & "; Prosis.webPrint.print('#attributes.printTitle#','#attributes.printContent#', #attributes.printShowUser#, function(){ #attributes.printCallback# });">
	<cfelse>
		<cfset vOnClickEvent = "Prosis.webPrint.print('#attributes.printTitle#','#attributes.printContent#', #attributes.printShowUser#, function(){ #attributes.printCallback# }); " & vOnClickEvent>
	</cfif>
	
	<cfif vImageSrc eq "">
		<cfset vImageSrc = attributes.printIcon>
	</cfif>
</cfif>

<!--- TextColor --->
<cfif vTextColor eq "">
	<cfif attributes.mode eq "button" or attributes.mode eq "icon">
		<cfset vTextColor = "##FFFFFF">
	</cfif>
	
	<cfif attributes.mode eq "link">
		<cfset vTextColor = "##4EABFC">
	</cfif>
</cfif>

<!--- BGColor --->
<cfif vBGColor eq "red">
	<cfset vBGColor = "##DB4F66">
<cfelseif vBGColor eq "blue">
	<cfset vBGColor = "##3388DE">
<cfelseif vBGColor eq "green">
	<cfset vBGColor = "##47BA50">
<cfelseif vBGColor eq "darkGray">
	<cfset vBGColor = "##808080">
<cfelseif vBGColor eq "gray">
	<cfset vBGColor = "##B5B5B5">
<cfelseif vBGColor eq "black">
	<cfset vBGColor = "##4A4A4A">
<cfelseif vBGColor eq "white">
	<cfset vBGColor = "##FFFFFF">
<cfelse>
	<!--- Gray as default --->
	<cfif vBGColor eq "">
		<cfset vBGColor = "##B5B5B5">
	</cfif>
</cfif>

<!--- Title --->
<cfif vTitle eq "">
	<cfset vTitle = attributes.text>
</cfif>

<!--- TextAlign --->
<cfif vTextAlign eq "">
	<cfif vImageSrc eq "">
		<cfset vTextAlign = "center">
	<cfelse>
		<cfset vTextAlign = "center">
	</cfif>
</cfif>

<cf_validateBrowser minIE="11">

	
<cfoutput>

	<cfif attributes.mode eq "button" or attributes.mode eq "icon">
		
		<cfset vButtonBorder = "border:none;">
		<cfif attributes.mode eq "button">
			<cfset vButtonBorder = "border:1px solid ##CCCCCC;">
		</cfif>

		<button type = "#vType#" 
			id       = "#attributes.id#"
			name     = "#attributes.id#" 
			onclick  = "#vOnClickEvent#" 
			title    = "#vTitle#"
			class    = "#attributes.class# clsButton2Button"
			style    = "cursor:pointer; #vButtonBorder# padding:0; margin:0; background-color:transparent; width:#attributes.width#; height:#attributes.height#;">
				
				<cfif attributes.mode eq "button">
				
					<cfsavecontent variable="vDivStyle">
						width:100%; 
						margin:0; 
						background-color:#vBGColor#;
						
						<cfif clientbrowser.pass eq 0>
							height:80%;
						<cfelse>
							height:100%;
							<!--- -webkit-border-radius:#vBorderRadius#; 
							-moz-border-radius:#vBorderRadius#; 
							-ms-border-radius:#vBorderRadius#; 
							-o-border-radius:#vBorderRadius#; 
							border-radius:#vBorderRadius#; 
														
							-webkit-transform-style: preserve-3d;
							-moz-transform-style: preserve-3d;
							-o-transform-style: preserve-3d;
							-ms-transform-style: preserve-3d;
							transform-style: preserve-3d; --->
						</cfif>						
						#attributes.style#
					</cfsavecontent>	
										
										
					<div style="#vDivStyle#;" 
						onmouseover="#attributes.onmouseover#"
						onmouseout="#attributes.onmouseout#">
												
							<cfsavecontent variable="vDivVerticalAlignStyle">
								float:left; 
								position:relative;
								
								<cfif clientbrowser.pass eq 0>
									top:6%;
									-ms-filter:'progid:DXImageTransform.Microsoft.Matrix(M11=1, M12=0, M21=0, M22=1, SizingMethod=\'auto expand\')';
								<cfelse>
									top:48%; 
									-webkit-transform:translateY(-50%); 
									-moz-transform:translateY(-50%); 
									-ms-transform:translateY(-50%); 
									-o-transform:translateY(-50%); 
									transform:translateY(-50%);
								</cfif>
								
							</cfsavecontent>
														
							<cfif vImageSrc neq "">
							
								<table width="100%" height="100%">
								<tr>
								<td width="20%" style="padding-left:10px; padding-right:4px; text-align:#vTextAlign#;" class="clsButton2IconLeft">
															    
								    <cfif attributes.ImagePos eq "left">									
										<img src="#session.root#/images/#vImageSrc#" style="height:#attributes.imageHeight#;">									
									</cfif>	
																								
								</td>
								
								<td width="45%" align="center" style="padding-top:0px; border:0px solid silver;" class="clsButton2Text">																			
									<div style="display:inline-block; white-space:nowrap; color:#vTextColor#; font-size:#attributes.textSize#; font-family:#vFontFamily#; text-align:#vTextAlign#;">#trim(attributes.text)#</div>
									<cfif trim(attributes.subText) neq "">
										<div style="white-space:nowrap; color:#vTextColor#; font-size:#attributes.subTextSize#; font-family:#vFontFamily#; text-align:#vTextAlign#;">#trim(attributes.subText)#</div>
									</cfif>
								</td>
								
								
								
								<td width="45%" align="center" style="padding-right:10px; padding-top:1px;padding-left:4px;width:20%;border:0px solid silver" class="clsButton2IconRight">
								<!---
								<div style="height:100%; padding-right:10px; padding-top:1px;padding-left:4px; #vDivVerticalAlignStyle#">	
								--->
								
								<cfif attributes.ImagePos eq "right">																		
									<img src="#session.root#/images/#vImageSrc#" style="height:#attributes.imageHeight#;">
								</cfif>								
								<!---	
								</div>
								--->								
								
								</td>
								
								
								
								</tr></table>
																
							<cfelse>	
													
								<div style="height:auto; width:100%; #vDivVerticalAlignStyle#">								
									<div style="color:#vTextColor#; font-size:#attributes.textSize#; font-family:#vFontFamily#; text-align:#vTextAlign#;">#trim(attributes.text)#</div>
									<div style="color:#vTextColor#; font-size:#attributes.subTextSize#; font-family:#vFontFamily#; text-align:#vTextAlign#;">#trim(attributes.subText)#</div>
								</div>
								
							</cfif>							
					</div>
					
				</cfif>
				
				<cfif attributes.mode eq "icon">
					<table>
						<tr onmouseover="#attributes.onmouseover#" onmouseout="#attributes.onmouseout#">
							<cfif vImageSrc neq "">
							<td style="height:#attributes.height#;"><img src="#session.root#/images/#vImageSrc#" style="height:#attributes.imageHeight#; #attributes.style#"></td>
							</cfif>
							<cfif trim(attributes.text) neq "">
							<td valign="middle" style="color:#vTextColor#; font-size:#attributes.textSize#; font-family:#vFontFamily#; padding:5px; padding-left:3px;">
								#trim(attributes.text)#
							</td>
							</cfif>
						</tr>
					</table>
				</cfif>
				
		</button>
	
	</cfif>
	
	<cfif attributes.mode eq "link">
		<a id="#attributes.id#"
			name="#attributes.id#" 
			onclick="#vOnClickEvent#" 
			title="#vTitle#"
			style="cursor:pointer; color:#vTextColor#; font-size:#attributes.textSize#; font-family:#vFontFamily#; #attributes.style#">
				#trim(attributes.text)#
		</a>
	</cfif>
	
</cfoutput>

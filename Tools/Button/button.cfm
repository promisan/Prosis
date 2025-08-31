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
<cfparam name="attributes.id"           default="">
<cfparam name="attributes.name"         default="#attributes.id#">
<cfparam name="attributes.onClick"      default="">
<cfparam name="attributes.height"       default="25">
<cfparam name="attributes.mode"         default="grayshadow">
<cfparam name="attributes.type"         default="">
<cfparam name="attributes.icon"         default="">
<cfparam name="attributes.label"        default="">
<cfparam name="attributes.label2"       default="">
<cfparam name="attributes.color"        default="0b0b0b">
<cfparam name="attributes.font"         default="verdana">
<cfparam name="attributes.transform"    default="none">
<cfparam name="attributes.alt"          default="">
<cfparam name="attributes.error"        default="">
<cfparam name="attributes.onmouseover"  default="yes">
<cfparam name="attributes.onmouseout"   default="yes">
<cfparam name="attributes.onmousedown"  default="yes">
<cfparam name="attributes.fontfamily"   default="">
<cfparam name="client.editing"          default="">
<cfparam name="attributes.value"        default="">

<cf_buttonStyles>

<cfoutput>	

	<cfif attributes.id eq "">
		<cf_AssignId>
		<cfset attributes.id = "button_#rowguid#">
	</cfif>
	
	<cfif attributes.value neq "">
		<cfset attributes.label = attributes.value>
	</cfif>
	
	<cfif attributes.type eq "button" or attributes.type eq "submit">		
		<cfset attributes.mode = "silver">		
		<cfif not isDefined("attributes.width")>
			<cfset attributes.width = "124px">
		</cfif>		
	</cfif>
	<!--- ----  ------------------------------------  ---- --->
	<!--- ----  Classes are defined in screentop.cfm  ---- --->
	<!--- ----  ------------------------------------  ---- --->
	
	<!--- ----  --------------------------------------------  ---- --->
	<!--- ----  JS Functions are defined in systemscript.cfm  ---- --->
	<!--- ----  --------------------------------------------  ---- --->
	
	<!--- ----  -------------------------  ---- --->
	<!--- ----  Start Handle Button modes  ---- --->
	<!--- ----  -------------------------  ---- --->
	
	<cfif attributes.mode eq "grayshadow">
		<cfset ht = "25px">
		<cfset wd = "15px">			
		<cfset attributes.label2 = "">
	
	<cfelseif attributes.mode eq "blueshadow">
		<cfset ht = "29px">
		<cfset wd = "22px">						
		<cfset attributes.onmousedown = "no">			
		<cfset attributes.label2 = "">
		
	<cfelseif attributes.mode eq "silver">
		<cfset ht = "24px">
		<cfset wd = "8px">						
		<cfset attributes.onmousedown = "no">			
		<cfset attributes.label2 = "">
			
	<cfelseif attributes.mode eq "grayLarge">
		<cfset ht = "56px">
		<cfset wd = "15px">					
		<cfset attributes.onmousedown = "no">	

	<cfelseif attributes.mode eq "silverLarge">
		<cfset ht = "55px">
		<cfset wd = "15px">							
		<cfset attributes.onmousedown = "no">	
		
	<cfelseif attributes.mode eq "orangeLarge">
		<cfset ht = "55px">
		<cfset wd = "15px">							
		<cfset attributes.onmousedown = "no">	
	
	<cfelseif attributes.mode eq "blueLarge">
		<cfset ht = "55px">
		<cfset wd = "15px">							
		<cfset attributes.onmousedown = "no">	
	
	<cfelseif attributes.mode eq "greenLarge">
		<cfset ht = "55px">
		<cfset wd = "15px">							
		<cfset attributes.onmousedown = "no">
		
	<cfelseif attributes.mode eq "blackLarge">
		<cfset ht = "55px">
		<cfset wd = "15px">							
		<cfset attributes.onmousedown = "no">
    <cfelseif attributes.mode eq "link">
		<cfset ht = "35px">
		<cfset wd = "200px">
		<cfset attributes.onmousedown = "no">    	
	<cfelseif attributes.mode eq "red">
		<cfset ht = "60px">
		<cfset wd = "15px">							
		<cfset attributes.onmousedown = "no">	
	
	<cfelse>		
		<cfset attributes.error = "yes">		
	</cfif>	
	<!--- ----  -----------------------  ---- --->
	<!--- ----  End Handle Button modes  ---- --->
	<!--- ----  -----------------------  ---- --->
	
	<cfif attributes.label2 neq "">
		<cfparam name="attributes.width"        default="120">
		<cfparam name="attributes.paddingtop"   default="3px">
		<cfparam name="attributes.align"        default="left">
		<cfparam name="attributes.paddingleft"  default="5px">
		<cfparam name="attributes.fontsize"     default="15">
		<cfparam name="attributes.fontweight"   default="bold">
		<cfparam name="attributes.iconheight"   default="29px">
		<cfparam name="attributes.lineheight"   default="17px">
	<cfelse>
		<cfparam name="attributes.width"        default="">
		<cfparam name="attributes.paddingtop"   default="0px">
		<cfparam name="attributes.align"        default="center">
		<cfparam name="attributes.paddingleft"  default="3px">
		<cfparam name="attributes.fontsize"     default="11">
		<cfparam name="attributes.fontweight"   default="normal">
		<cfparam name="attributes.iconheight"   default="19px">
		<cfparam name="attributes.lineheight"   default="">
	</cfif>

	<cfset attributes.width = REReplace(attributes.width,"[A-Za-z]","","ALL")>
			
	<cfif attributes.error neq "yes" and attributes.label neq "">
		
		<cfif attributes.type eq "submit" or attributes.type eq "reset" or attributes.type eq "button">

				<button type = "#attributes.type#" 
			      id         = "#attributes.id#" 
				  name       = "#attributes.name#" 
				  style      = "width:#attributes.width#; height:#ht#; background-color:transparent; border:0px; padding:0px; margin:0px; cursor:pointer; <cfif attributes.fontfamily neq "">font-family:#attributes.fontfamily#</cfif>; <cfif attributes.fontweight neq "">font-weight:#attributes.fontweight#</cfif>" 
				  onclick    = "#attributes.onClick#">
				  
		</cfif>
			
		<cfsavecontent variable = "events">
			<cfif attributes.type neq "submit" and attributes.type neq "button" and attributes.onClick neq "">
				onclick="#attributes.onClick#;"
				style="cursor:pointer" 
			</cfif>
			<cfif attributes.id neq "">
				<cfif attributes.onmouseover eq "yes">
					onmouseover="try {hlbg('#attributes.id#_leftBG','#attributes.id#_centerBG','#attributes.id#_rightBG','#attributes.mode#');} catch(e){}" 
				</cfif>
				<cfif attributes.onmouseout eq "yes">
					onmouseout="try {regbg('#attributes.id#_leftBG','#attributes.id#_centerBG','#attributes.id#_rightBG','#attributes.mode#');} catch(e) {}" 
				</cfif>
				<cfif attributes.onmousedown eq "yes">
					onmousedown="try {downbg('#attributes.id#_leftBG','#attributes.id#_centerBG','#attributes.id#_rightBG','#attributes.mode#');} catch(e) {}"
				</cfif>
			</cfif>
		</cfsavecontent>			
		
    	<cfif attributes.width neq "" and client.editing neq "1" >
			<div style="width:#attributes.width#px; height:#ht#; position:relative; top:0px; left:0px; margin:0px; padding:0px">
			<div title="#attributes.alt#" style="z-index:10; background-image:url('#SESSION.root#/Images/spacer1.gif'); background-repeat:repeat; width:100%; height:#ht#; position:absolute; top:0px; left:0px; cursor:pointer" #events#>			
			</div>
        
		</cfif>

		<table id="#attributes.id#" 
				name="#attributes.id#" 
				title="#attributes.alt#" 
				cellpadding="0" 
				cellspacing="0" 
				height="#ht#" 
				width="#attributes.width#px" 
				border="0" 
				<cfif attributes.width eq "" or client.editing eq "1">
					#events# 
				</cfif>
				>
								
			<tr>
            
				<td id="#attributes.id#_leftBG" name="#attributes.id#_leftBG" class="#attributes.mode#buttonleft" width="#wd#" height="#ht#"><img src="#SESSION.root#/Images/spacer1.gif" width="#wd#" height="#ht#" style="display:block"></td>
				<td id="#attributes.id#_centerBG" name="#attributes.id#_centerBG" class="#attributes.mode#buttoncenter" valign="middle" align="center">
					
					<table cellpadding="0" cellspacing="0" height="#ht#" border="0">
						<tr>
												
							<cfif attributes.icon neq "" and FileExists('#SESSION.rootpath##attributes.icon#')>
							<td valign="middle" <cfif attributes.mode eq "grayshadow">style="padding-bottom:2px"</cfif>>							
								<img src="#SESSION.root#/#attributes.icon#" border="0" alt="" align="absmiddle" height="#attributes.iconheight#" style="display:block">
							</td>
							</cfif>
							<td valign="middle" align="#attributes.align#" style="line-height:#attributes.lineheight#; text-transform:#attributes.transform#; font-family:#attributes.font#; font-size:#attributes.fontsize#; color:#attributes.color#; font-weight:#attributes.fontweight#; padding-top:#attributes.paddingtop#; <cfif attributes.icon neq "">padding-left:#attributes.paddingleft#;</cfif>">
 							
							<cf_tl id="#attributes.label#">							
							<cfif attributes.label2 neq "">
								<br style="line-height:5px">								
								<span style="font-family:#attributes.font#; font-size:11px; color:#attributes.color#; font-weight:normal;">
									<cf_tl id="#attributes.label2#" class="message">
								</span>
							</cfif>
							</td>
						</tr>
					</table>	
						
				</td>
				<td id="#attributes.id#_rightBG" name="#attributes.id#_rightBG" class="#attributes.mode#buttonright" width="#wd#" height="#ht#"><img src="#SESSION.root#/Images/spacer1.gif" width="#wd#" height="#ht#" style="display:block"></td>
			</tr>
			<!--- This preloads the onmouseover state to avoid the loading flicker --->
			<tr style="<cfif client.browser eq "Explorer">display:none<cfelse>height:0px</cfif>">
				<td class="#attributes.mode#buttonhlleft" style="line-height:0px">&nbsp;</td>
				<td class="#attributes.mode#buttonhlcenter" style="line-height:0px">&nbsp;</td>
				<td class="#attributes.mode#buttonhlright" style="line-height:0px">&nbsp;</td>
			</tr>
		</table>
		<cfif attributes.width neq "">
		</div>
		</cfif>
		<cfif attributes.type eq "submit" or attributes.type eq "reset" or attributes.type eq "button">	
		</button>	
		</cfif>
		
	<cfelseif attributes.error eq "yes">
	
		<cf_tableround mode="solidcolor" color="red" totalwidth="" alt="Mode:#attributes.mode#, does not exist">
		<font color="white" size="1" face="verdana">
			#attributes.mode# Button not configured properly
		</font>
		</cf_tableround>
		
	</cfif>
	
</cfoutput>
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

<cfparam name="attributes.id"          default="btn_Print">			<!--- ID for the button, must always be something otherwise onmouseover wont work for <cf_button--->
<cfparam name="attributes.wrap"        default="no">				<!--- When tool is used in conjuction with <cf_printcontent in a wrapped fashion, to print innerHTML--->
<cfparam name="attributes.cfbutton"    default="yes">				<!--- triggers a cf_button, but this is guided by the mode now--->
<cfparam name="attributes.bgcolor"     default="transparent">		<!--- bgcolor of container table--->
<cfparam name="attributes.printwidth"  default="100%">				<!--- Height of childNode(Iframe) created to print -not visible--->
<cfparam name="attributes.printheight" default="100%">				<!--- Width of childNode(Iframe) created to print -not visible--->
<cfparam name="attributes.align"       default="">					<!--- Alignment of container table--->
<cfparam name="attributes.var"         default="print=1">			<!--- contains the everpresent and much needed print=1 variable needed to print --->
<cfparam name="attributes.novariables" default="0">                 <!--- if variables are passed in attributes.source eq 1 otherwise eq 0 --->
<cfparam name="attributes.mode"        default="StandardButton">	<!--- Print Tool display mode, this guides the rest--->
<cfparam name="url.print"              default="0">					<!--- used as a provision as this is also in <cf_screentop is used globally--->

	<cfif attributes.wrap eq "no">
		<!--- ------------------------------------------- --->
		<!--- attributes.source default value is prepared --->
		<!--- ------------------------------------------- --->
		<cfset CurrentTemplatePath=lcase(CF_TEMPLATE_PATH)>  
		<cfset SESSION.rootpath = lcase(SESSION.rootpath)>					
		<cfset ctpath = Replace(CurrentTemplatePath, SESSION.rootpath,"","ALL")>					
		<cfset ctpath = Replace(ctpath,"\","/","ALL")>
		<cfparam name="attributes.source"    default="#SESSION.root#/#ctpath#?#CGI.QUERY_STRING#">	
		<!--- ------------------------------------------- --->

		<!--- ------------------------------------------- --->
		<!--- troot is prepared for FileExists Operation  --->
		<!--- ------------------------------------------- --->
		<cfset SESSION.root         = lcase(SESSION.root)> 
		<cfset client.virtualdir   = lcase(client.virtualdir)> 
		<cfset attributes.source   = lcase(attributes.source)> 
		
		<cfset troot = Replace(attributes.source, SESSION.root,"","ALL")>	
		<cfif client.virtualdir neq "">
			<cfset troot = Replace(troot, client.virtualdir,"","ALL")>
		</cfif>
		<cfset troot = Replace(troot,"/","\","ALL")>
		
		<cfif attributes.source neq "" and Find ("?",attributes.source)>
			<cfset troot = Left(troot,Find("?",troot)-1)>
		<cfelseif attributes.source neq "">
			<cfset attributes.novariables = "1">
		</cfif>
		<!--- ------------------------------------------- --->
		
	<cfelse>
	
		<cfset attributes.source = "">
		
	</cfif>

	<!--- ----  -------------------------  ---- --->
	<!--- ----  Start Handle Print modes   ---- --->
	<!--- ----  -------------------------  ---- --->	
	<cfif attributes.mode eq "StandardButton">
		<cfset attributes.cfbutton = "no">
		
		<cfparam name="attributes.class"       default="">
		<cfif attributes.class eq "">
			<cfset attributes.class = "button10s">
		</cfif>
		
		<cfif attributes.class eq "button10s">
			<cfparam name="attributes.width"       default="65px">
			<cfparam name="attributes.height"      default="23px">
		<cfelseif attributes.class eq "button10g">
			<cfparam name="attributes.width"       default="100px">
			<cfparam name="attributes.height"      default="22px">
		<cfelse>
			<cfparam name="attributes.width"       default="100px">
			<cfparam name="attributes.height"      default="22px">		
		</cfif>
		
	<cfelseif attributes.mode eq "Hyperlink">
		<cfset attributes.cfbutton = "no">
		<cfparam name="attributes.class"       default="label">
		<cfparam name="attributes.width"       default="45px">
		<cfparam name="attributes.height"      default="23px">
		
	<cfelseif attributes.mode eq "RoundedButton">
		<!--- classes are not used as this is a <cf_button --->
		<cfset attributes.buttonlayout.label2 = "">
		<cfparam name="attributes.width"       default="65px">
		<cfparam name="attributes.height"      default="23px">
		
	<cfelseif attributes.mode eq "LargeRoundedButton">
		<!--- classes are not used as this is a <cf_button --->
		<cfparam name = "Attributes.buttonlayout.label2" default="this screen">
		<cfparam name="attributes.width"       default="65px">
		<cfparam name="attributes.height"      default="23px">
	</cfif>
	<!--- ----  -------------------------  ---- --->
	<!--- ----  Start Handle Print  modes  ---- --->
	<!--- ----  -------------------------  ---- --->


<cfif attributes.cfbutton neq "yes">
	<cfset Attributes.buttonlayout.label2 = "">
</cfif>
	
<!--- ----------------------- --->
<!--- start <cf_button params --->
<!--- ----------------------- --->

<cfset init = structNew()>
<cfparam name="Attributes.buttonlayout" type="struct" default="#init#">

<CFParam name= "Attributes.buttonlayout.label"        default="Print">
<CFParam name= "Attributes.buttonlayout.color"        default="0b0b0b">
<cfparam name= "Attributes.buttonlayout.type"         default="">
<cfparam name= "Attributes.buttonlayout.font"         default="verdana">
<cfparam name= "Attributes.buttonlayout.transform"    default="none">
<cfparam name= "Attributes.buttonlayout.alt"          default="Click to Print ">
<cfparam name= "Attributes.buttonlayout.onmouseover"  default="yes">
<cfparam name= "Attributes.buttonlayout.onmouseout"   default="yes">
<cfparam name= "Attributes.buttonlayout.onmousedown"  default="yes">
<cfparam name= "Attributes.buttonlayout.onclick"      default="">

<cfif Attributes.buttonlayout.label2 neq "">

	<CFParam name="Attributes.buttonlayout.icon"         default="Images/Print.png">
	<cfparam name="Attributes.buttonlayout.iconheight"   default="29px">
	<CFParam name="Attributes.buttonlayout.mode"         default="silverlarge">
	<CFParam name="Attributes.buttonlayout.width"        default="155">
	<cfparam name="Attributes.buttonlayout.paddingtop"   default="3px">
	<cfparam name="Attributes.buttonlayout.align"        default="left">
	<cfparam name="Attributes.buttonlayout.paddingleft"  default="5px">
	<cfparam name="Attributes.buttonlayout.fontsize"     default="18">
	<cfparam name="Attributes.buttonlayout.fontweight"   default="bold">
	<cfparam name="Attributes.buttonlayout.lineheight"   default="17px">
	
<cfelse>

	<CFParam name="Attributes.buttonlayout.icon"         default="Images/print_small3.gif">
	<cfparam name="Attributes.buttonlayout.iconheight"   default="16px">
	<CFParam name="Attributes.buttonlayout.mode"         default="grayshadow">
	<CFParam name="Attributes.buttonlayout.width"        default="155">
	<cfparam name="Attributes.buttonlayout.paddingtop"   default="0px">
	<cfparam name="Attributes.buttonlayout.align"        default="center">
	<cfparam name="Attributes.buttonlayout.paddingleft"  default="3px">
	<cfparam name="Attributes.buttonlayout.fontsize"     default="12">
	<cfparam name="Attributes.buttonlayout.fontweight"   default="normal">
	<cfparam name="Attributes.buttonlayout.lineheight"   default="">
	
</cfif>	
	
<!--- ---------------------------------------------- --->
<!--- ------------ end  <cf_button params----------- --->
<!--- ---------------------------------------------- --->

<!--- ---------------------------------------------------------- --->
<!--- Print scripts are in Tools/DialogHandling/SystemScript.cfm --->
<!--- ---------------------------------------------------------- --->

<cfoutput>

<cfif url.print neq "1">
			
	<table cellpadding="0" cellspacing="0" width="#attributes.width#" height="#attributes.height#" bgcolor="#attributes.bgcolor#" align="#attributes.align#" class="noprint">
		<tr height="20px">
			
			<td width="20px" class="labelit">
				<cfif attributes.source eq "">
					<cfset donclick = "printDiv('printthis')" >
				<cfelse>
					<cfif attributes.novariables eq "0">
						<cfset char = "&">
					<cfelse>
						<cfset char = "?">
					</cfif>
					
					<cfif FileExists('#SESSION.rootpath##troot#')>
						<cfset donclick = "doTheIframe('#attributes.source##char##attributes.var#','#attributes.printwidth#','#attributes.printheight#')" >
					<cfelse>
						<cfset donclick = "alert('Specified source cannot be found')" >
					</cfif>
				</cfif>
					
				<cfif attributes.cfbutton eq "yes">
			
					<cf_button 
						mode        = "#attributes.buttonlayout.mode#" 
						label       = "#Attributes.buttonlayout.label#" 
						label2      = "#Attributes.buttonlayout.label2#"
						id          = "#Attributes.id#"  
						icon        = "#attributes.buttonlayout.icon#"
						onclick     = "#donclick#; #attributes.buttonlayout.onclick#" 
						width       = "#attributes.buttonlayout.width#" 
						color       = "#attributes.buttonlayout.color#"					   
						paddingtop  = "#attributes.buttonlayout.paddingtop#"
						align       = "#attributes.buttonlayout.align#" 
						paddingleft = "#attributes.buttonlayout.paddingleft#"
						fontsize    = "#attributes.buttonlayout.fontsize#"
						fontweight  = "#attributes.buttonlayout.fontweight#"
						iconheight  = "#attributes.buttonlayout.iconheight#"
						lineheight  = "#attributes.buttonlayout.lineheight#"
						type        = "#attributes.buttonlayout.type#"
						font        = "#attributes.buttonlayout.font#"
						transform   = "#attributes.buttonlayout.transform#"
						alt         = "#attributes.buttonlayout.alt#"
						onmouseover = "#attributes.buttonlayout.onmouseover#"
						onmouseout  = "#attributes.buttonlayout.onmouseout#"
						onmousedown = "#attributes.buttonlayout.onmousedown#">
				
				<cfelse>
				
					<table width="#attributes.width#" height="#attributes.height#" cellpadding="0" cellspacing="0" 
					   id="#Attributes.id#" onclick="#donclick#; #attributes.buttonlayout.onclick#">
						<tr>
												
							<td style="cursor:pointer; text-align:center"
							    class="#attributes.class#" 
								width="#attributes.width#" 
								height="#attributes.height#" 
								align="center" 
								title="#attributes.buttonlayout.alt#">
								<font color="6688aa">#Attributes.buttonlayout.label#</font>
							</td>
							
							<cfif FileExists('#SESSION.rootpath#/#Attributes.buttonlayout.icon#') and attributes.mode neq "standardbutton">
							<td style="padding-left:#attributes.buttonlayout.paddingleft#">							
								<img src="#SESSION.root#/#Attributes.buttonlayout.icon#" 
								    height="23" 
									width="23" 
									border="0" 
									style="cursor:pointer; display:block" 
									align="absmiddle" 
									height="#Attributes.buttonlayout.iconheight#">
							</td>		
							</cfif>	
						</tr>
					</table>				
					
				</cfif>
			</td>
			<td id="printprogressstatus" width="0px">
				<cfif attributes.source eq "">
					<!--- iframe used for seamless printing in conjunction with <cf_printcontent> ..html.. </cf_printcontent> --->
					<iframe name="printFrame" id="printFrame" width="0px" height="0px" frameborder="0" marginheight="0" marginwidth="0" scrolling="No"></iframe>
				</cfif>
			</td>
			
		</tr>
	</table>
</cfif>

	
</cfoutput>
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
<cfparam name="Attributes.tabid"      default="">
<cfparam name="Attributes.button"     default="No">
<cfparam name="Attributes.border"     default="No">
<cfparam name="Attributes.base"       default="menu">
<cfparam name="Attributes.item"       default="1">
<cfparam name="Attributes.itemclass"  default="dbutton">
<cfparam name="Attributes.type"       default="Vertical">
<cfparam name="Attributes.target"     default="box">
<cfparam name="Attributes.targetitem" default="#attributes.item#">
<cfparam name="Attributes.iconsrc"    default="">
<cfparam name="Attributes.width"      default="10%">
<cfparam name="Attributes.class"      default="regular">
<cfparam name="Attributes.fontcolor"  default="black">
<cfparam name="Attributes.iconwidth"  default="20">
<cfparam name="Attributes.iconheight" default="20">
<cfparam name="Attributes.name"       default="undefined">
<cfparam name="Attributes.iframe"     default="">
<cfparam name="Attributes.loadalways" default="Yes">
<cfparam name="Attributes.script"     default="">
<cfparam name="Attributes.source"     default="">
<cfparam name="Attributes.height"     default="20">
<cfparam name="Attributes.padding"    default="7">
<cfparam name="Attributes.selected"   default="highlight1">

<cfif attributes.tabid eq "">
    <cfset tabid      = attributes.item>
<cfelse>
	<cfset tabid      = attributes.tabid>
</cfif>	
<cfset base       = attributes.base>
<cfset item       = attributes.item>
<cfset target     = attributes.target>
<cfset targetitem = attributes.targetitem>
<cfset icon       = attributes.iconsrc>
<cfset icwd       = attributes.iconwidth>
<cfset icht       = attributes.iconheight>
<cfset name       = attributes.name>
<cfset source     = attributes.source>

<!--- determine values on the fly in { } --->
	
<cfset start = "1">
<cfset new   = source>

<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
				
			<cfset str = find("{","#new#",start)>
			<cfset str = str+1>
			<cfset end = find("}","#new#",start)>
			<cfset end = end>
			
			<cfset fld = Mid(new, str, end-str)>
									
			<cfif fld eq "height">
			
				<cfset qry = "'+document.body.clientHeight+'">						
			
			<cfelseif fld eq "width">
			
				<cfset qry = "'+document.body.clientWidth+'">	
			
			<cfelse>
			
			<cfset qry = "'+document.getElementById('#fld#').value+'">			
			
			</cfif>
			
			<cfset new = replace(new,"{#fld#}","#qry#")>  
			
			<cfset start = end>
			
		<cfelse>
		
			<cfset start = len(new)+1>	

		</cfif> 
	
</cfloop>		

<cfif source eq "">
	<cfset link = ""> <!--- nada --->

<cfelseif find("javascript:",source)>
    <cfset link = right(new,len(new)-11)>
		
<cfelseif find("alert:",source)>
    <cfset link = right(new,len(new)-6)>	
	<cfset link = "alert('#link#')">
	
<cfelseif find("report:",source)>
    <cfset controlid = right(new,len(new)-7)>	
	<cfset link = "ptoken.open('#SESSION.root#/tools/cfreport/submenureportview.cfm?controlid=#controlid#&context=embed','myreport')">
	
<cfelseif find("iframe:",source)> 
    <cfset link = right(new,len(new)-7)>	  
	<cfset link = "$('###attributes.iframe#').contents().find('body').empty();ptoken.open('#link#','#attributes.iframe#')">	
	
<cfelse>  	
    <cfif attributes.loadAlways eq "Yes">
	<cfset link = "_cf_loadingtexthtml='';ptoken.navigate('#new#','content#target##targetitem#');">	
	<cfelse>
	<cfset link = "_cf_loadingtexthtml='';var vContents = $('##contentbox2').contents().find('table').html();if ($.trim(vContents) == '') { ptoken.navigate('#new#','content#target##targetitem#'); }">	
	</cfif>
</cfif>

<cfinvoke component="Service.Presentation.Presentation"
   method="highlight" class="highlight1" 
   returnvariable="stylescroll"/>

<cfoutput>

<input type="hidden" id="id_menu#tabid#" name="id_menu#tabid#" value="#base##item#">

<td style="width:#Attributes.width#" #stylescroll# align="center" id="tmenu#tabid#" name="tmenu#tabid#" class="#attributes.itemclass#">

	<cfif attributes.button eq "yes" and attributes.tabid neq "">
	 
	<button class="bactive"
	    id="menu#tabid#" name="menu#tabid#" style="width:100%"
		onclick="if (document.getElementById('menu#tabid#').disabled == false) { mainmenu('#base#','#item#','#target#','#targetitem#','#attributes.selected#'); #preservesinglequotes(link)#;} " <cfif tabid neq "">disabled="disabled"</cfif>>
		
		
	</cfif>

	<table style="width:100%" align="center" style="<cfif attributes.border eq 'yes'>border:1px solid silver</cfif>">
	
	<tr class="fixlengthlist">
					
	<td class="#attributes.class#" id="#base##item#" name="#base##item#" 		
		style="width:100%;cursor:pointer; padding-top:#attributes.padding#px;padding-bottom:2px;" 
		align="center" 		
		onclick="#attributes.script#;<cfif attributes.button eq 'no' and attributes.tabid eq "">mainmenu('#base#','#item#','#target#','#targetitem#','#attributes.selected#'); #preservesinglequotes(link)#;</cfif>">
				
		<cfif attributes.type eq "Vertical">
				
			<table width="100%" style="cursor:pointer"  valign="center" align="center">
		  		<cfif icon neq "">
			  		<tr><td align="center">			
						<img width="#icwd#" height="#icht#" src="#SESSION.root#/Images/#icon#" id="imenu#tabid#" name="imenu#tabid#">						
					</td></tr>
				</cfif>
				<tr class="labelmedium fixlengthlist">
				<td align="center" name="menu#tabid#_text" id="menu#tabid#_text" style="font-size:15px;color:#attributes.fontcolor#;padding-top:4px">#Name#<td>
				</tr>
				
		  	</table>
			
		<cfelse>	
				
			<table width="100%" 			   				
				 align="center" 
				 style="cursor:pointer">
				 				 				 							
			  		<tr><td align="center" width="100%" style="padding-bottom:1px">
																				
						<table align="center">
							<tr class="labelmedium fixlenghtlist">
								<cfif icon neq "">
								<td align="right" style="padding-right:5px">
								<img width="#icwd#" align="absmiddle" height="#icht#" src="#SESSION.root#/Images/#icon#">
								</td>													
								</cfif>
								<td align="center" name="menu#tabid#_text" id="menu#tabid#_text" 
								   style="font-size:15px;color:#attributes.fontcolor#;text-rendering: optimizeLegibility">#Name#<td>
							</tr>
						</table>
					</tr>								
		  	</table>
		
		</cfif>
	</td>			
	
	</tr>
		
	</table>
	
	<cfif attributes.button eq "yes" and attributes.tabid neq "">	
	</button>
	</cfif>
	
</td>

</cfoutput>

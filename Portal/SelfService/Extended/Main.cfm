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
<cfparam name="banner" default="1">

<div id="detailcontent">		
  		
   <cfif SESSION.authent  eq "1">
   
   	   <!--- we go strainght to the portal backofgfice screens --->
	   <cfinclude template="LogonProcessOpen.cfm">
   		   
   <cfelse>		
   
       <!--- content is for the non backoffice screens prior to log --->
   		
		<div id="menu">
			<cfinclude template="menu.cfm">
		</div>
		<div id="menuline"></div>				
		
		<cfif FileExists ("#SESSION.rootPATH##LayoutBanner.FunctionDirectory##LayoutBanner.FunctionPath#") and LayoutBanner.Operational eq "1">

			<div id="dbanner">
				<cf_divround mode="solid">
				<cfoutput>
					
					<table width="100%" height="100px" cellpadding="0" cellspacing="0" border="0">
						<tr>
						<cfif find(".png",LayoutBanner.FunctionPath) gt "1" or
						      find(".jpg",LayoutBanner.FunctionPath) gt "1" or
							  find(".gif",LayoutBanner.FunctionPath) gt "1">
							<td align="center" valign="middle" id="banner" name="banner" style="background-image:url('../../#LayoutBanner.FunctionDirectory##LayoutBanner.FunctionPath#'); background-position:center center; background-repeat:no-repeat">
								&nbsp;
							<cfelseif 
								  find(".swf",LayoutBanner.FunctionPath) gt "1">
								 	<td align="center" valign="middle" id="banner" name="banner">
									<object width="800px" height="100px" style="display:block">
										<param name="movie" value="../../#LayoutBanner.FunctionDirectory##LayoutBanner.FunctionPath#">
										<param name="wmode" value="transparent">
											<embed src="../../#LayoutBanner.FunctionDirectory##LayoutBanner.FunctionPath#" width="800px" height="100px"  wmode="transparent" style="display:block">
											</embed>
									</object>
							<cfelseif
								  find(".cfm",LayoutBanner.FunctionPath) gt "1">
								    <td align="center" valign="middle" id="banner" name="banner">
								  	<cfinclude template="../../../#LayoutBanner.FunctionDirectory##LayoutBanner.FunctionPath#">
							<cfelse>
								  <td align="center" valign="middle" id="banner" name="banner">
								  <font color="red">Banner Object is a non allowed type.</font>
							</cfif>
							</td>
						</tr>
					</table>
					
				</cfoutput>
				</cf_divround>
			</div>

		<cfelseif LayoutBanner.Operational eq "1">
		
			<table height="100px" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="100px" style="padding-left:20px; padding-right:20px; padding-top:5px; padding-bottom:10px">
						<table width="100%" height="100px" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td align="center" valign="middle" style="font-size:16px; color:silver">
									&nbsp;<i>BANNER AREA</i>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			
		<cfelse>
		
			<cfset banner = "0">

		</cfif>		
		
		<div id="innercontent" <cfif banner eq "0">style="top:50px"</cfif>>
		
			<div id="innercontentleft">
				<cf_divround mode="solid">
					<cf_divround mode="solid" overflow="vertical">
						<div style="height:100%; width:auto; " id="dmenu">
						&nbsp;
						</div>
						<script>
						<cfoutput>
						ColdFusion.navigate('#SESSION.root#/Portal/SelfService/Extended/Option.cfm?id=#url.id#&webapp=#url.id#&link=&menu=','dmenu');
						</cfoutput>
						</script>
					</cf_divround>
				</cf_divround>
			</div>
			
			<div id="innercontentright">
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<cfif FileExists ("#SESSION.rootPATH##Login.FunctionDirectory##Login.FunctionPath#") and Login.Operational eq "1" and Login.recordcount eq "1">
						<tr>
							<td align="center">
							
								<cfinclude template="../../../#Login.FunctionDirectory##Login.FunctionPath#">
							</td>
						</tr>
					<cfelse>
						<tr>
							<td height="255px" valign="top" align="center" style="background-image:url('../../Portal/Selfservice/Extended/Images/Loginv6.png'); background-repeat:no-repeat; background-position: top center">
							<cfinclude template="logonajax.cfm">
							</td>
						</tr>
					</cfif>
					<tr>
						<td valign="top" align="center" id="widgets" name="widgets">
						<cfif FileExists ("#SESSION.rootPATH##LayoutWidgets.FunctionDirectory##LayoutWidgets.FunctionPath#") and LayoutWidgets.Operational eq "1">
							<cfinclude template="../../../#LayoutWidgets.FunctionDirectory##LayoutWidgets.FunctionPath#">														
						<cfelseif LayoutWidgets.Operational eq "1">
							<cfinclude template="widgets.cfm">						
						</cfif>
						</td>
					</tr>
				</table>
			</div>
		</div>
	
   </cfif>
	
</div>
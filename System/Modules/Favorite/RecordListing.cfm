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
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<table width="98%" align="center">

<tr><td height="8"></td></tr>

<tr><td>

	<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="white">
			<tr>
				<td width="5%">
				</td>

				<td height="80" valign="middle" align="left" width="98%" style="top; padding-left:10px">
					<table width="100%" cellpadding="0" cellspacing="0" border="0" >
						<tr>
							<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(<cfoutput>#SESSION.root#</cfoutput>/images/logos/BGV2.png); background-repeat:no-repeat">
							
							</td>
						</tr>
						<tr>
							<td style="z-index:5; position:absolute; top:23px; left:35px; ">
								<img src="<cfoutput>#SESSION.root#</cfoutput>/images/logos/favorites/favorites_icon.png">
							</td>
						</tr>
						<tr>
							<td style="z-index:3; position:absolute; top:25px; left:100px; color:45617d; font-family:calibri; font-size:25px; font-weight:normal;">
								<cf_tl id="Favorites">
							</td>
						</tr>
						<tr>
							<td style="position:absolute; top:5px; left:100px; color:e9f4ff; font-family:calibri; font-size:45px; font-weight:normal; z-index:2">
								<cf_tl id="Favorites">
							</td>
						</tr>
						
						<tr>
							<td style="position:absolute; top:55px; left:105px; color:45617d; font-family:calibri; font-size:12px; font-weight:normal; z-index:4">
								<cf_tl id="My Favorite Functions">
							</td>
						</tr>
						
						<tr>
							<td height="10"></td>
						</tr>
					</table>
				</td>
			</tr>
			</table>
</td>			
</tr>			

<tr><td height="4"></td></tr>

</table>

<cfset heading   = "Main Functions">
<cfset module    = "">
<cfset selection = "Favorite">
<cfset class     = "'Mission'">

<cfinclude template="../../../Tools/SubmenuMission.cfm">


<cfset heading   = "Supporting Functions">
<cfset module    = "">
<cfset selection = "Favorite">
<cfset class     = "any">

<cfinclude template="../../../Tools/Submenu.cfm">



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

<cf_screentop height="100%" scroll="Vertical" html="No">

<cfoutput>

<table width="100%" border="0">

	<tr>
		<td width="5%"></td>

		<td height="80" valign="middle" align="left" width="98%" style="top; padding-left:10px">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">
				<tr>
					<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(#SESSION.root#/images/logos/BGV2.png); background-repeat:no-repeat">
					</td>
				</tr>
				
				<tr>
					<td style="z-index:5; position:absolute; top:23px; left:35px; ">
						<img src="#SESSION.root#/images/logos/Roster/Roster_Manual.jpg">
					</td>
				</tr>
				<tr>
					<td style="z-index:3; position:absolute; top:25px; left:90px; color:45617d; font-family:calibri; font-size:25px; font-weight:bold;">
						Roster Reference 
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:5px; left:90px; color:e9f4ff; font-family:calibri; font-size:55px; font-weight:bold; z-index:2">
						Roster Reference 
					</td>
				</tr>
				
				<tr>
					<td style="position:absolute; top:50px; left:90px; color:45617d; font-family:calibri; font-size:12px; font-weight:bold; z-index:4">
						Reference
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
	
	<tr><td height="30"></td></tr>
			
	<tr><td colspan="2">	
	
	<table width="90%" align="center"><tr><td>	
	
	<cfinvoke component="Service.Access"  
	 method="roster" 
	 returnvariable="AccessRoster"
	 role="'AdminRoster'">
		
	<cfif AccessRoster eq "Edit" or AccessRoster eq "All">
		
			<cf_filelibraryN
				DocumentPath="Roster"
				SubDirectory="#URL.Owner#" 	
				Filter=""			
				Insert="yes"
				Remove="yes"
				width="100%"	
				Loadscript="yes"	
				AttachDialog="yes"
				align="left"
				border="1">	
				
	<cfelse>
	
			<cf_filelibraryN
				DocumentPath="Roster"
				SubDirectory="#url.Owner#" 
				Filter=""				
				Insert="no"
				Remove="no"
				reload="true"
				Loadscript="yes"
				width="100%"
				align="left"
				border="1">	
	
	</cfif>	
	
	</td></tr>
	</table>

</td>
</tr>

</table>
</cfoutput>




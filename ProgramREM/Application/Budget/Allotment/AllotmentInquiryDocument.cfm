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

<cfoutput>

<table width="97%" height="200" align="center" border=0">

	<tr>
		<td width="70%"></td>

		<td height="50" valign="middle" align="right" width="100%" style="top; padding-left:10px">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">
				<tr>
					<td align="right" style="z-index:1; width:100%; height:29px; right:0px; top:0px; background-image:url(#SESSION.root#/images/logos/BGV2.png); background-repeat:no-repeat">
					</td>
				</tr>
				
				<tr>
					<td align="right" style="top:23px; right:35px; ">
						<img src="#SESSION.root#/images/logos/Program/Program_Manual.jpg">
					</td>
				</tr>
				<tr>
					<td align="right" style="top:25px; left:90px; color:45617d; font-family:calibri; font-size:25px; font-weight:bold;">
						Supporting Documents
					</td>
				</tr>
								
			</table>
		</td>
	</tr>
	
	<tr><td height="10"></td></tr>
			
	<tr><td colspan="2">	
	
	<table width="98%" align="center"><tr><td>
	
	<!--- check for BudgetManager --->
	
	<cfquery name="Parameter" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM Parameter
	</cfquery>
	
	<cfinvoke component="Service.Access"  
	      method="Budget" 
		  role="'BudgetManager','BudgetOfficer'" 
		  mission = "#url.mission#"
		  scope="Mission"
		  editionid="'#URL.Editionid#'" 
		  returnvariable="access">
	
	<cfif Access eq "Edit" or Access eq "All">
		
		<cf_filelibraryN
				DocumentPath="#Parameter.DocumentLibrary#"
				SubDirectory="#URL.ProgramCode#" 
				Filter="Budget"
				Insert="yes"
				Remove="yes"
				width="100%"	
				Loadscript="yes"	
				AttachDialog="yes"
				align="left"
				border="1">	
				
	<cfelse>
	
			<cf_filelibraryN
				DocumentPath="#Parameter.DocumentLibrary#"
				SubDirectory="#URL.ProgramCode#" 
				Filter="Budget"
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





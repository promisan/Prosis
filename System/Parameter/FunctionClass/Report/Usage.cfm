<!--
    Copyright Â© 2025 Promisan

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
	




	
    	
		<br>
		<cfset dname=replace(dname,"cf_","","ALL")>
		<cfdirectory directory="#SESSION.rootPath#_examples\#dname#" name="files" action="LIST">

			<tr>						
			<td>
				#Dname#
			</td>
			</tr>		
		
			<cfloop query="files">
				
				
				<cfif files.type IS "file">

	
				
					<cffile action = "read" 
					    file = "#files.directory#\#files.name#" 
					    variable = "Message">
						
						<tr>						
						<td>
							#files.name#
						</td>
						</tr>
						
						<tr>						
							<td>

							<cfinvoke component="Service.Presentation.ColorCode"  
							   method="colorstring" 
							   datastring="#message#" 
							   returnvariable="result">		
			   	
						       <cfset result = replace(result, "Â", "", "all")/>
								   <table><tr><td>#result#</td></tr></table>

							</td>
						</tr>
						
						
						<tr>						
							<td>
							</td>
						</tr>												
						
		
				</cfif>

			</cfloop>
		

</cfoutput>

</table>
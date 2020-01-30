	

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
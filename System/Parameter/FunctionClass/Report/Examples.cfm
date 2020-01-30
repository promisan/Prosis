<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">
<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css"  media="print">	
		

<cfoutput>
	



<cfdirectory directory="#SESSION.rootPath#\_examples" name="dirQuery" action="LIST">
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfloop query="dirQuery">

	<cfif dirQuery.type IS "dir">
	
    	
		<br>
		<cfdirectory directory="#SESSION.rootPath#_examples\#dirQuery.name#" name="files" action="LIST">

			<tr>						
			<td>
				#dirQuery.name#
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
		
	</cfif>
	
	
</cfloop>

</cfoutput>

</table>
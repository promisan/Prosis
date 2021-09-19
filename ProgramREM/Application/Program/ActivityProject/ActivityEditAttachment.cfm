
<!--- Query returning search results for activities  --->
<cfquery name="EditActivity" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*, 
	         O.OrgUnitName, 
			 O.OrgUnitCode, 
			 O.OrgUnitClass, 
			 O.Mission, 
			 O.MandateNo		
	FROM     #CLIENT.LanPrefix#ProgramActivity A left join Organization.dbo.#CLIENT.LanPrefix#Organization O
	ON       A.OrgUnit = O.OrgUnit
	WHERE    A.ActivityID = '#URL.ActivityId#'  
</cfquery>


<table width="95%" align="center" class="formpadding">

		<tr><td height="5"></td></tr>		
		<tr><td height="40" class="labelmedium2">Attach relevant documents</td></tr>		
				
		<tr><td height="5"></td></tr>
		
		<tr><td colspan="2">										
							
		<!--- Query returning program parameters --->
		<cfquery name="Parameter" 
		datasource="AppsProgram" >
		    SELECT *
		    FROM Parameter
		</cfquery>
		
		<cfif access eq "All" OR access eq "EDIT">   
		
		<cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#EditActivity.ProgramCode#" 
			Filter="act#activityid#"
			Insert="yes"
			Box="att#activityid#"
			loadscript="no"
			Remove="yes"
			Highlight="no"
			Rowheader="no"
			Width="100%"
			Listing="yes">		
			
		<cfelse>				
							
		<cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#EditActivity.ProgramCode#" 
			Filter="act#activityid#"
			Insert="no"
			Box="att#activityid#"
			loadscript="no"
			Remove="no"
			Highlight="no"
			Rowheader="no"
			Width="100%"
			Listing="yes">	
			
		</cfif>	
											
		</td>
		</TR>	
		
		<tr><td id="outputsave"></td></tr>
		
</table>						
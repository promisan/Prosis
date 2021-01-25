
<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT   *
   FROM     xl#Client.LanguageId#_Ref_ModuleControl
   WHERE    SystemModule   = 'System'
   	AND     FunctionClass  = 'Organization'
   	AND     MenuClass      = 'Detail'
   	AND     Operational    = '1'
   ORDER BY MenuClass, MenuOrder 
</cfquery>

<cfset cnt = 0>

<cfoutput query="SearchResult">

	<cfinvoke component="Service.Access"  
	     method="function"  
		 SystemFunctionId="#SystemFunctionId#" 
		 returnvariable="access">
		 
	<CFIF access is "GRANTED"> 		
		<cfset cnt = 1>		 	
	</cfif>
 
</cfoutput>

<cfif cnt eq "1">

	<cf_UItree
		id="root"
		title="<span style='font-size:17px;color:gray;'>Features</span>"			
		expand="Yes">
		
		 
		<cfoutput query="SearchResult">
		
			<cfinvoke component="Service.Access"  
			     method="function"  
				 SystemFunctionId="#SystemFunctionId#" 
				 returnvariable="access">
				 
			<CFIF access is "GRANTED"> 	
			
				<cf_UItreeitem value="#FunctionName#"
			        display="<span style='font-size:15px;padding-top:4px' class='labelit'>#FunctionName#</span>"						
					parent="root"	
					target="right"									
					href="UnitViewOpen.cfm?systemfunctionid=#systemfunctionid#&ID1=#scriptname#&ID=#URL.ID#"								
			        expand="Yes">						
								 	
			</cfif>
		 
		</cfoutput>
	
	</cf_UItree>

</cfif>




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
	
	<cftree name="root"
		font="Calibri"
		fontsize="15"		
		bold="No"   
		format="html"    
		required="No">  
	 
		<cfoutput query="SearchResult">
		
			<cfinvoke component="Service.Access"  
			     method="function"  
				 SystemFunctionId="#SystemFunctionId#" 
				 returnvariable="access">
				 
			<CFIF access is "GRANTED"> 	
					
				<cftreeitem value="#FunctionName#"
			        display="<font color='0080C0'>#FunctionName#</font>"
					parent="root"	
					target="right"									
					href="UnitViewOpen.cfm?systemfunctionid=#systemfunctionid#&ID1=#scriptname#&ID=#URL.ID#"		
			        expand="Yes">	
				 	
			</cfif>
		 
		</cfoutput>
	
	</cftree>

</cfif>



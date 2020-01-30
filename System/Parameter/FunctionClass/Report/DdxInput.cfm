
<cfquery name="QClass" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM Class
		order by ClassId
</cfquery>
<cfoutput>

<cfloop query="QClass">

	<cfset fname=#QClass.ClassName#>
	<cfset fname=replace(fname," ","_","ALL")>
	<cfset theClass=QClass.ClassId>
	<cfinclude template="MergeAttachments.cfm">
	
	<CFScript>
		StructInsert(input, "#fname#", "#SESSION.rootPath#\cfrstage\mergepdf\intro_#theClass#.pdf");
	</CFScript>
	
	
	
	
	
	
</cfloop>


<cfquery name="QfType" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Class.ClassName, ClassFunction.ClassFunctionType
		FROM         ClassFunction INNER JOIN
	                 Class ON ClassFunction.ClassId = Class.ClassId
		ORDER BY Class.ClassName
</cfquery>



<cfloop query="QfType">
	<cfset fname=#Qftype.ClassName#>
	<cfset fname=replace(fname," ","_","ALL")>
	<CFScript>
		StructInsert(input, "#fname#_Details_#QfType.ClassFunctionType#", "pdfs/#fname#_Details_#QfType.ClassFunctionType#.pdf");
	</CFScript>
</cfloop>
		
		


</cfoutput>

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
	<PDF result="s#fname#" >
		<PDF source="#fname#"  bookmarkTitle="Overview" includeInTOC="true"/>
		
		<cfquery name="QfType" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT Class.ClassName, ClassFunction.ClassFunctionType,Ref_FunctionType.Name,Ref_FunctionType.ListingOrder
				FROM         ClassFunction INNER JOIN
			                 Class ON ClassFunction.ClassId = Class.ClassId INNER JOIN
							 Ref_FunctionType ON Ref_FunctionType.Code=ClassFunction.ClassFunctionType
				WHERE ClassFunction.ClassId='#QClass.ClassId#'			 
				ORDER BY Ref_FunctionType.ListingOrder
		</cfquery>

		
		<cfloop query="QfType">
			<PDF source="#fname#_Details_#QfType.ClassFunctionType#"  bookmarkTitle="#QfType.Name#" includeInTOC="true"/>											
		</cfloop>
		
		
	</PDF>	

</cfloop>
</cfoutput>



	 

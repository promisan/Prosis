<cfcomponent
	output="false"
	hint="Handles Comparison operations for workflow objects">


	<cffunction name="Values"
		access="Public"
		returntype="array"
		hint="Returns a array with found differences in values">

		<cfargument 
			name="DataSource" 
			type="string" 
			required="true" 
			/>

		<cfargument 
			name="Table" 
			type="string" 
			required="true" 
			/>
			
		<cfargument 
			name="PK" 
			type="string" 
			required="true" 
			/>			

				<cfquery name="Origin1" Datasource="AppsOrganization">
					SELECT     *
					FROM    #Table#
					WHERE   #PreserveSingleQuotes(PK)#
				</cfquery>	
				
				<cfset qColumns="#Origin1.columnList#">	
				<!--Removing columns that are for logging purposes only ---->
					<cfset qColumns=ReplaceNoCase(qColumns,"OfficerUserId","")>
					<cfset qColumns=ReplaceNoCase(qColumns,"OfficerFirstName","")>				
					<cfset qColumns=ReplaceNoCase(qColumns,"OfficerLastName","")>									
					<cfset qColumns=ReplaceNoCase(qColumns,"Created","")>														
					<cfset qColumns=ReplaceNoCase(qColumns,",,",",","all")>																		
					<cfset qColumns=ReplaceNoCase(qColumns,",,",",","all")>							
					<cfif Left(qColumns,1) eq ",">
						<cfset qColumns=Mid(qColumns,2,Len(qColumns)-1)>																								
					</cfif>					
					<cfif Right(qColumns,1) eq ",">
						<cfset qColumns=Mid(qColumns,1,Len(qColumns)-1)>																								
					</cfif>					

					
				<cfset aResponse=arraynew(1)>
				<cfset i=1>
					

				<cfquery name="Destination1" Datasource="AppsOrganization">
					SELECT     Count(1) as Total
					FROM    [#DataSource#].Organization.dbo.#Table#
					WHERE  #PreserveSingleQuotes(PK)#
				</cfquery>	
				
				<cftry>
					<cfquery name="Check" Datasource="AppsOrganization">
						SELECT sum(character_maximum_length) as tbytes
						FROM information_schema.columns
						WHERE table_name = '#Table#'
					</cfquery>		
					
					<cfif Check.tbytes gt 3000>
						<cfset error=1>
					<cfelse>
						<cfset error=0>		
					</cfif>
				<cfcatch>
					<cfset error=1>
				</cfcatch>
				</cftry>	
				
				<cfset Done=0>
				<cfloop query="Origin1">
						<cfif Destination1.Total eq 1>
						<!----COMPARISON AT FIELD LEVEL IS REQUIRED ---->
							<cfloop index = "ListElement" 
								   list = "#qColumns#"> 

								   	<cfif error eq 1>
											<cfquery name="qType" Datasource="AppsOrganization">
												SELECT Data_Type
												FROM INFORMATION_SCHEMA.COLUMNS 
												WHERE Table_Name='#Table#'
												AND COLUMN_NAME='#ListElement#'
											</cfquery>													
									
											
							   				<cfquery name="Destination2" Datasource="AppsOrganization">
												SELECT  
												<cfif qType.Data_Type eq  "text" or qType.Data_Type eq "ntext" or qType.Data_Type eq "varchar">
													IsNull(#ListElement#,'') as '#ListElement#'
												<cfelse>
													#ListElement#
												</cfif>
												FROM    [#DataSource#].Organization.dbo.#Table#
												WHERE  #PreserveSingleQuotes(PK)#
											</cfquery>	
						
									<cfelseif Done eq 0>
										<!--- No error, I can query using * without problem ----->
						   				<cfquery name="Destination2" Datasource="AppsOrganization">
											SELECT  *
											FROM    [#DataSource#].Organization.dbo.#Table#
											WHERE  #PreserveSingleQuotes(PK)#											
										</cfquery>
										<cfset Done=1>
									</cfif>	
								   
									<cftry>
										<cfset FieldOrigin = Evaluate("Origin1.#ListElement#")>
										<cfset FieldDestination = Evaluate("Destination2.#ListElement#")>
										<cfif FieldOrigin neq FieldDestination>
										   <cfset SQL="UPDATE [#DataSource#].Organization.dbo.#Table# SET #ListElement#='#FieldOrigin#' WHERE #PreserveSingleQuotes(PK)#">
										   <cfset sElement= StructNew()/>		
										   
		   								   <cfset a=StructInsert(sElement, "Type", "UPDATE")>
		   								   <cfset a=StructInsert(sElement, "SQL", "#SQL#")>									   
		   								   <cfset a=StructInsert(sElement, "Table", "#Table#")>	
										   <cfset a=StructInsert(sElement, "Field", "#ListElement#")>
									       <cfset a=StructInsert(sElement, "PK", "#PK#")>									   									
	   									   <cfset a=StructInsert(sElement, "Source", "#FieldOrigin#")>									   									
										   <cfset a=StructInsert(sElement, "Destination", "#FieldDestination#")>									   									
										   
										   <cfset aResponse[i]=sElement>
										   <cfset i=i+1>
										 </cfif>
									<cfcatch>
										
									</cfcatch>		 
									</cftry>	 
							</cfloop>
						<cfelse>
						<!--- DO NOT EXIST THE ROW INSERT IS NEEDED ---->
								<cfset sElement= StructNew()/>		
								<cfset SQL="INSERT INTO [#DataSource#].Organization.dbo.#Table# (#qColumns#) SELECT #qColumns# FROM #Table# WHERE #PreserveSingleQuotes(PK)#">
	   							<cfset a=StructInsert(sElement, "Type", "INSERT")>
	   							<cfset a=StructInsert(sElement, "SQL", "#SQL#")>									   
	   							<cfset a=StructInsert(sElement, "Table", "#Table#")>	
								<cfset a=StructInsert(sElement, "Field", "")>		
 						        <cfset a=StructInsert(sElement, "PK", "#PK#")>									   																								   									
   								<cfset a=StructInsert(sElement, "Source", "")>									   									
							    <cfset a=StructInsert(sElement, "Destination", "")>								
							    <cfset aResponse[i]=#sElement#>
							    <cfset i=i+1>					
						</cfif>
				</cfloop>
				
				<cfreturn aResponse/>

	
		
	</cffunction>


</cfcomponent>




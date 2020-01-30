<cfset vPhoto = "#session.rootdocument#/EmployeePhoto/#vUserAccount#.jpg">

<cfif not FileExists('#session.rootdocumentpath#\EmployeePhoto\#vUserAccount#.jpg') OR trim(vUserAccount) eq "">

	<cfset vPhoto = "#session.rootdocument#/EmployeePhoto/#vIndexNo#.jpg">
		
	<cfif not FileExists('#session.rootdocumentpath#\EmployeePhoto\#vIndexNo#.jpg') OR trim(vIndexNo) eq "">
	
		<cfset vPhoto = "#session.rootdocument#/EmployeePhoto/#replace(vIndexNo,'00','')#.jpg">
	
		<cfif not FileExists('#session.rootdocumentpath#\EmployeePhoto\#replace(vIndexNo,'00','')#.jpg') OR trim(vIndexNo) eq "">
		
			<cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
			
			<cfif vGender eq "f">
				<cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
			</cfif>
			
		</cfif>
		
	</cfif>

</cfif>
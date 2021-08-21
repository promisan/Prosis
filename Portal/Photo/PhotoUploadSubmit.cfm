<cf_param name="url.width" 			default="54px"	type="string">
<cf_param name="url.height" 		default="44px"	type="string">
<cf_param name="url.source"      	default=""		type="string">
<cf_param name="url.destination" 	default="EmployeePhoto" type="string">
<cf_param name="url.style" 			default="" 		type="string">
<cf_param name="url.pic" 			default="" 		type="string">
<cf_param name="url.filename" 		default="" 		type="string">

<cf_tl id="Picture updated" var="lblUpdated">

<cftry>
	<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\#url.destination#">
	<cfcatch></cfcatch>
</cftry>

	<cf_assignid>
	
	<cftry>
		 
		<cfif ParameterExists(Form.load)> 	
			
			<!--- upload file with unique name --->
			<cffile action="UPLOAD"
		       	filefield="UploadedFile"
			    destination="#SESSION.rootDocumentPath#\#url.destination#\#url.filename#.jpg"
		        nameconflict="OVERWRITE">
			
		</cfif>
		
		<cfif ParameterExists(Form.Delete)> 	
			<cffile action="DELETE" file="#SESSION.rootDocumentPath#\#url.destination#\#url.filename#.jpg">	
		</cfif>
		
		<cfoutput>
			
			<script>		
				parent.ptoken.navigate('#session.root#/Portal/Photo/PhotoUploadView.cfm?filename=#url.filename#&destination=#url.destination#','photoshow')

				<cfif url.mode eq "Staffing">
				
					<cfquery name="get" 
					     datasource="AppsEmployee" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
			               	SELECT *
			                FROM   Person
			                WHERE  IndexNo = '#URL.filename#'
			        </cfquery>

			        <cfif get.recordCount eq "1">
			        	parent.ptoken.navigate('#session.root#/Staffing/Application/Employee/PersonPicture/PersonViewPicture.cfm?mode=staffing&indexNo=#url.filename#&reference=&personno=&destination=#url.destination#&style=#url.style#','#url.Pic#')
				    <cfelse>

				    	<cfquery name="get" 
						     datasource="AppsEmployee" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
				               	SELECT *
				                FROM   Person
				                WHERE  reference = '#URL.filename#'
				        </cfquery>

				        <cfif get.recordCount eq "1">
				        	parent.ptoken.navigate('#session.root#/Staffing/Application/Employee/PersonPicture/PersonViewPicture.cfm?mode=staffing&indexNo=&reference=#url.filename#&personno=&destination=#url.destination#&style=#url.style#','#url.Pic#')
					    <cfelse>

					    	<cfquery name="get" 
							     datasource="AppsEmployee" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
					               	SELECT *
					                FROM   Person
					                WHERE  personno = '#URL.filename#'
					        </cfquery>
					        parent.ptoken.navigate('#session.root#/Staffing/Application/Employee/PersonPicture/PersonViewPicture.cfm?mode=staffing&indexNo=&reference=&personno=#url.filename#&destination=#url.destination#&style=#url.style#','#url.Pic#')

				        </cfif>


			        </cfif>
					
					if (parent.parent) {
						if (parent.parent.$('.clsNavigationBarRefresh').length > 0) {
							parent.parent.$('.clsNavigationBarRefresh').first().trigger('click');
						}
					}
					
				<cfelseif url.mode eq "User">
					parent.ptoken.navigate('#session.root#/Portal/PhotoShow.cfm?filename=#url.filename#&acc=#url.filename#&width=#url.width#&height=#url.height#&destination=#url.destination#&style=#url.style#','#url.Pic#')
				<cfelseif url.mode eq "Applicant">
					parent.ptoken.navigate('#session.root#/Portal/PhotoShow.cfm?filename=#url.filename#&acc=#url.filename#&width=#url.width#&height=#url.height#&destination=#url.destination#&style=#url.style#','#url.Pic#')
				<cfelse>
					parent.ptoken.navigate('#session.root#/Portal/PhotoShow.cfm?filename=#url.filename#&acc=#url.filename#&width=#url.width#&height=#url.height#&destination=#url.destination#&style=#url.style#','#url.Pic#')
				</cfif>	
			</script>
			
		</cfoutput>
			
	<cfcatch>
			
		<cfoutput>
			<script>
				alert("Please select a picture first")
			</script>
		</cfoutput>
		
	</cfcatch>	

	</cftry>
	

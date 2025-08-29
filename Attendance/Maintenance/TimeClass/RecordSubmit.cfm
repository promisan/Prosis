<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfif url.id1 eq ""> 
	
	<cfquery name="Verify" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_TimeClass
		WHERE  TimeClass  = '#Form.TimeClass#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!");
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO Ref_TimeClass
			       	(
						TimeClass,
					   	Description,
						<cfif trim(form.DescriptionShort neq "")>DescriptionShort,</cfif>
					   	ListingOrder,
					   	ViewColor,
					   	ShowInAttendance
					)
			  VALUES  
			  		(	'#Form.TimeClass#',
			           	'#Form.Description#', 
					   	<cfif trim(form.DescriptionShort neq "")>'#form.DescriptionShort#',</cfif>
					   	#form.ListingOrder#,
			    	   	'#form.ViewColor#',		  
				  	   	#form.ShowInAttendance#
					)
		</cfquery>
		 
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#form#">
		 
    </cfif>		  
           
<cfelse>
	
	<cfquery name="Update" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_TimeClass
			SET   	Description = '#Form.Description#',
					DescriptionShort = <cfif trim(form.DescriptionShort) neq "">'#form.DescriptionShort#'<cfelse>null</cfif>,
					ListingOrder = #form.ListingOrder#,
					ViewColor = '#form.ViewColor#',
					ShowInAttendance = #form.ShowInAttendance#
			WHERE 	TimeClass = '#url.id1#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">		 

</cfif>	

<script>
	window.close();
	opener.location.reload();
</script>

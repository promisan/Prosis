<cfparam name="Form.Operational"    default="1">
<cfparam name="Form.ListValue"      default="">

<cfparam name="Form.GroupListCode"  default="#url.lc#">
<cfparam name="Form.Description"    default="#url.de#">
<cfparam name="Form.GroupListOrder" default="#url.lo#">

<cfif Form.GroupListCode eq "">

<cfelse>

	<cfif URL.ID2 neq "new">

		 <cfquery name="Update" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_PersonGroupList
			  SET    Operational         = '#Form.Operational#',
	 		         Description         = '#Form.Description#',			 
					 GroupListOrder      = '#Form.GroupListOrder#'
			  WHERE  GroupListCode = '#Form.GroupListCode#'
			   AND   GroupCode = '#URL.Code#' 
		</cfquery>
	
	
		<cfset url.id2 = "">
					
	<cfelse>

		<cfquery name="Exist" 
		    datasource="AppsEmployee" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT *
			FROM Ref_PersonGroupList
			  WHERE  GroupListCode = '#Form.GroupListCode#'
			   AND   GroupCode = '#URL.Code#' 
		</cfquery>
		
		<cfif Exist.recordCount eq "0">
			
				<cfquery name="Insert" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO Ref_PersonGroupList
				         (GroupCode,
						 GroupListCode,
						 Description,
						 GroupListOrder,
						 Operational)
				      VALUES ('#URL.Code#',
					      '#Form.GroupListCode#',
						  '#Form.Description#',
						  '#Form.GroupListOrder#',
				      	  '#Form.Operational#')
				</cfquery>
				
		<cfelse>
				
			<script>
			<cfoutput>
			alert("Sorry, but #Form.ListValue# already exists")
			</cfoutput>
			</script>
					
		</cfif>		
		
		<cfset url.id2 = "new">
			   	
	</cfif>

</cfif>	

<cfoutput>
  <script>
	#ajaxlink('List.cfm?code=#url.code#&id2=#url.id2#')#
  </script>	
</cfoutput>



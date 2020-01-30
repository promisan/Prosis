
<cfparam name="URL.Operational"    default="0">
<cfparam name="URL.ListCode"       default="">
<cfparam name="URL.ListValue"      default="">
<cfparam name="URL.ListOrder"      default="">
<cfparam name="URL.ListDefault"    default="0">

<cfset alias = URL.alias>

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="#alias#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_TopicList
		  SET    Operational         = '#URL.Operational#',
 		         ListValue           = '#URL.ListValue#',
				 ListOrder           = '#URL.ListOrder#',
				 ListDefault         = '#URL.ListDefault#'
		  WHERE  ListCode = '#URL.ListCode#'
		   AND   Code = '#URL.Code#' 
	</cfquery>
	
	<cfif systemmodule eq "Roster">		
		<cfset tablecode = "Ref_Topic">		
    <cfelse>		
		<cfset tablecode = "topic#systemmodule#">
   </cfif>						

	<cf_LanguageInput
			TableCode       = "#tablecode#List" 
			Mode            = "Save"
			DataSource      = "#alias#"
			Key1Value       = "#URL.Code#"
			Key2Value       = "#URL.ListCode#"
			Name1           = "ListValue">			
	
	
	<cfif URL.ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="#alias#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_TopicList
			  SET    ListDefault = 0
			  WHERE  ListCode <> '#URL.ListCode#'
			   AND   Code = '#URL.Code#' 
		</cfquery>
	
	</cfif>
	
	<cfset url.id2 = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="#alias#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_TopicList
		  WHERE  ListCode = '#URL.ListCode#'
		   AND   Code = '#URL.Code#' 
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="#alias#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_TopicList
			         (Code,
					 ListCode,
					 ListValue,
					 ListOrder,
					 ListDefault,
					 Operational)
			      VALUES ('#URL.Code#',
				      '#URL.ListCode#',
					  '#URL.ListValue#',
					  '#URL.ListOrder#',
					  '#URL.ListDefault#',
			      	  '#URL.Operational#')
			</cfquery>
			
			<cfif systemmodule eq "Roster">		
				<cfset tablecode = "Ref_Topic">		
		    <cfelse>		
				<cfset tablecode = "topic#systemmodule#">
		   </cfif>						
		
			<cf_LanguageInput
					TableCode       = "#tablecode#List" 
					Mode            = "Save"
					DataSource      = "#alias#"
					Key1Value       = "#URL.Code#"
					Key2Value       = "#URL.ListCode#"
					Name1           = "ListValue">		
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("Sorry, but #URL.ListCode# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
	
	<cfset url.id2 = "new">
	
	<cfif URL.ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="#alias#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  UPDATE Ref_TopicList
				  SET    ListDefault = 0
				  WHERE  ListCode <> '#URL.ListCode#'
				   AND   Code = '#URL.Code#' 
		</cfquery>
	
	</cfif>
		   	
</cfif>

<cfset URL.ID2 = "new">
<cfinclude template="List.cfm">


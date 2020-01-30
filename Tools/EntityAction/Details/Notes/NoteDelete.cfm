

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM   OrganizationObjectActionMail
		WHERE  ObjectId  = '#URL.ObjectId#'
		AND    ThreadId   = '#URL.ThreadId#'
		AND    SerialNo   >= '#URL.SerialNo#' 			
</cfquery>

<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   OrganizationObjectActionMail
		WHERE  ObjectId  = '#URL.ObjectId#'
		AND    ThreadId   = '#URL.ThreadId#'
		AND    SerialNo   >= '#URL.SerialNo#' 			
</cfquery>


<cfoutput>

<cfif url.mode eq "actor">

     <!--- insight portal mode --->
	
	 <script>
	   
		 window.dialogArguments.opener.listcontent('#url.Objectid#')
		 window.close()
	 </script>
		
<cfelse>
	
	 <script>	
	    try {	      
		parent.opener.ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/notes/NoteList.cfm?box=#url.box#&mode=note&objectid=#url.ObjectId#&actioncode=#url.ActionCode#','#url.box#')		
		} catch(e) {}
		window.close()
	 </script>

</cfif>	

</cfoutput>



	

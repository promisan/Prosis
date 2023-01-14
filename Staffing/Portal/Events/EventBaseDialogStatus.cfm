

<cfquery name="get" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   PersonEvent
		 WHERE  EventId = '#url.id#'
   </cfquery>	
   
<cfoutput>   

<cfif get.ActionStatus eq "1">
									
	<input type="button" value="Edit" style="width:60px" name="Edit" class="button10g" 
	   onClick="eventedit('#url.id#','inquiry','1')">
								   													
<cfelseif get.ActionStatus eq "3">
									
	    <cfif getAdministrator("#get.mission#")>
												
		<img src="#session.root#/Images/check.png"  title="Completed"
		   alt="" width="25" height="25" border="0">
			
		<cfelse>
		
		<img src="#session.root#/Images/check.png" title="Completed" 
		   alt="" width="25" height="25" border="0">
		</cfif>   
		
	<!--- closed --->		
 </cfif>
 
 </cfoutput>

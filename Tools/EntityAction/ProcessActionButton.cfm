
<cfquery name="Check" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublishScript
		WHERE  ActionPublishNo = '#URL.PublishNo#'
		AND    ActionCode = '#URL.ActionCode#' 
		AND    Method = '#URL.Method#'
</cfquery>			

<cfif Check.ActorAuthenticate neq "1">
	
	<cfoutput>	
	
	  <cf_tl id="Submit" var="1">
	  &nbsp;&nbsp;&nbsp;
		      
	  <!--- ------------------------------------------------------------- --->
	  <!--- process step and process custom fields and/or dialogs as well --->
	  <!--- ------------------------------------------------------------- --->
			  
	  <input type = "button" 
	      name    = "saveaction" 
		  id      = "saveaction"
	      onclick = "updateTextArea();Prosis.busy('yes');saveforms('#url.wfmode#')" 
		  value   = "#lt_text#" 
		  style   = "width:120px;height:25;font-size:14px;border-radius:5px;border:none;background:##033F5D;color:##FFFFFF;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,'Raleway',sans-serif !important;"
		  class   = "button10g">
		  
	</cfoutput>		
	
<cfelse>

    <cfoutput>
	
    <script>
	    ColdFusion.Window.create('boxauth', 'Process Action', '',{x:100,y:100,height:220,width:350,closable:false,resizable:false,modal:true,center:true});
		ColdFusion.navigate('ProcessActionPassword.cfm?wfmode=#url.wfmode#&PublishNo=#url.PublishNo#&ActionCode=#url.ActionCode#&Method=#url.method#','boxauth')		
	</script>
	
	</cfoutput> 
		
</cfif>		  
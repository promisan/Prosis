
<!--- launch document from the my clearances listing --->

<cftry>

	<cfparam name="url.myclentity" default="">
	
	<cfset client.LogonPage = "default">
	
	<cfquery name="Object" 
	 datasource="AppsOrganization">
	 SELECT *
	 FROM OrganizationObject 		
	 WHERE (ObjectId = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> 
	 OR ObjectKeyValue4 = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> )
	 AND Operational  = 1  
	</cfquery>
	
	<cfif url.myclentity eq "">
	   <cfset mycl = object.entitycode>
	<cfelse>
	   <cfset mycl = url.myclentity>   
	</cfif>
					
	<cfif Object.recordcount gte "1" and Object.ObjectURL neq "">
	
		<cfquery name="Entity" 
		 datasource="AppsOrganization">
		 	 SELECT *
			 FROM   Ref_Entity
			 WHERE  EntityCode = '#Object.EntityCode#'	 
		</cfquery>
		
		<!---
		<cfif Entity.ProcessMode eq "0">
		--->
		
			    <cfset client.refer = "workflow">
																					
			    <cfinvoke component="Service.Process.System.Security" method="passtru" returnvariable="hashvalue"/>		
																												
			    <cfif find("myclentity=",Object.ObjectURL)>				
				     <!--- prevent duplication --->
					<cflocation url="#SESSION.root#/#Object.ObjectURL#?mid=#hashvalue#" addtoken="No"> 
				<cfelseif find("refer=",Object.ObjectURL)>							
					<cflocation url="#SESSION.root#/#Object.ObjectURL#&mycl=1&myclentity=#mycl#&#hashvalue#" addtoken="No"> 			
				<cfelse>			
					<cflocation url="#SESSION.root#/#Object.ObjectURL#&mycl=1&myclentity=#mycl#&refer=workflow&#hashvalue#" addtoken="No"> 
				</cfif>	
		
		<!---	
		<cfelse>
		
		      <!--- not operational
		
				<cfinvoke component="Service.Process.System.Security" method="passtru" returnvariable="hashvalue"/>
							
				<!--- show a list of pending actions --->
		
				<cf_screentop height="100%" scroll="no" html="No" jQuery="Yes" title="Process workflow action">
				<cf_layoutscript>			
				
				<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>	

				<cf_layout attributeCollection="#attrib#">	
					
					<cf_layoutarea 
					   position="left"
					   name="search"						    	       
					   overflow="hidden"
					   size="220" 
					   title="Menu bar"  	
					   collapsible="true"        
					   maxsize="400"
					   splitter="true">
					   
					   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
									<tr><td height="30" align="center">
									
									<cfoutput>
									
									    <input type="button" 
									        name="Close" 
				   						    value="Close and Return"
										    class="button10s" 
										    style="width:190px"
										    onclick="opener.ColdFusion.navigate('MyClearancesEntity.cfm?entitycode=#object.entitycode#','c#object.entitycode#');window.close()">
										
									</cfoutput>	
									 			 
									</td></tr>
												
									<tr><td height="98%" valign="top" align="center">
									[Select from list]
									</td></tr>
									</table>		
					   
				   </cf_layoutarea>	
	
				   <cf_layoutarea  
					    position="center" 														
						name="maincontainer">
							
						<table width="100%" height="100%" cellspacing="0" cellpadding="0">
								<tr>								
								
								  <td bgcolor="e3e3e3">
									
									<cfoutput>
									
										 <iframe src="#SESSION.root#/#Object.ObjectURL#&mycl=1&myclentity=#object.entitycode#&refer=workflow&#hashvalue#"
									         width="100%"
									         height="100%"
									         frameborder="0"
									         style="background-color: D6d6d6;"></iframe> 
											 
									 </cfoutput>				 
									 				 
									</td>
								</tr>
								</table>
															
					</cf_layoutarea>				
					
				</cf_layout>	
				
				--->	
				
			</cfif>		
			
			--->
		
	<cfelse>
		
	<cf_screentop html="No" title="Problem">
	
	<table width="90%" height="90" class="formpadding" cellspacing="0" cellpadding="0">
	<tr><td align="center" style="font-size:20px" class="labelmedium">

	<cfif Object.ObjectURL eq "">			
		<b>Attention:</b> Document could not be redirected. Please contact your administrator		
	<cfelse>	
  		<b>Attention:</b> Requested document has been processed already or does not longer exist.	
	</cfif>
		
	</td></tr>
	</table>
	
	</cfif>

<cfcatch>

	<cf_screentop html="No" title="Problem">
	
	<table width="90%" height="100" cellspacing="2" cellpadding="2">
	<tr><td align="center" style="color:red;" class="labelmedium">
	  Requested action could not be retrieved. <p>Please contact your administrator if the problem persists.	
	</td></tr></table>

</cfcatch>

</cftry>


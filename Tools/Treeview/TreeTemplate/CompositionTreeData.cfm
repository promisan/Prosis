
<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#attributes.Mission#'
</cfquery>

			  
<cf_tl id="Encounters" var="vAction">

<cf_UItree
	id="root"
	title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#attributes.Mission#</span>"	
	expand="Yes">
				  
			   <cf_UItreeitem value="action"
			        display="<span style='font-size:19px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labellarge'>#vAction#</span>"						
					parent="root"	
					target="right"
					href="javascript:ptoken.navigate('workorderlineview.cfm?drillid=#url.drillid#','myContainer')"						
			        expand="Yes">				 						
									
			  <cfquery name="CompositionTypeList" 
			  datasource="AppsWorkOrder" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      SELECT *
			      FROM   Ref_CompositionType T
				  WHERE  Code IN (SELECT CompositionType 
				                  FROM   Ref_CompositionTypeMission
								  WHERE  Mission     = '#Attributes.Mission#')		
				  ORDER BY ListingOrder				  		
			  </cfquery>
			  
			  <cf_tl id="Content" var="vContent">
			  						  
			  <cf_UItreeitem value="type"
			        display="<span style='font-size:19px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labellarge'>#vContent#</span>"						
					parent="root"							
			        expand="Yes">						
					
												  
		      <cfoutput query="CompositionTypeList">		  
			  
			  	 <cf_UItreeitem value="type_#code#"
					        display="<span style='font-size:17px;padding-top:5px;padding-bottom:5px' class='labelit'>#Description#</span>"
							parent="type"											
							target="right"
					        expand="True">	
							
				 <cfquery name="Element" 
				  datasource="AppsWorkOrder" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Ref_CompositionElement T
					  WHERE  CompositionType = '#Code#'		
					  ORDER BY ListingOrder				  		
				  </cfquery>	
				  
				  <cfset cde = code>
			  
			  	<cfloop query="Element">
			  
			  	 <cf_UItreeitem value="elem_#Elementcode#"
					        display="<span style='font-size:14px' class='labelit'>#ElementName#</span>"
							parent="type_#cde#"											
							target="right"
					        expand="No">	
							
				</cfloop>							    
				
			</cfoutput>							
			
</cf_UItree>


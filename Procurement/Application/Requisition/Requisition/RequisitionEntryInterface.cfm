
<cfparam name="URL.mode"   default="">
<cfparam name="URL.des"    default="">
<cfparam name="URL.option" default="uom">
<cfparam name="URL.access" default="#url.mode#">
<cfparam name="URL.init"   default="1">

<cfquery name="Reset" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE RequisitionLine
	SET    RequestType     = 'Regular', 
	       WarehouseItemNo = NULL, 
		   WarehouseUoM    = NULL	
	WHERE  RequisitionNo   = '#URL.reqid#'
</cfquery>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   RequisitionLine
	WHERE  RequisitionNo = '#URL.reqid#'
</cfquery>
  
<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission  = '#Line.Mission#'	
 </cfquery>
   
<cfoutput>	
		
	<cfswitch expression="#URL.option#">
	
	<cfcase value="itm">
	
	   <table width="100%">
	   
   		   <tr id="requestmemo"><td width="100%" style="padding-bottom:6px;height:1px"  class="labelmedium">
		   
			<cfif url.Access eq "View">
				
				#url.des# 
				  
			<cfelse>	
											
				<textarea class = "regular" 
				      onkeyup   = "ismaxlength(this);" 
					  name      = "requestdescription" 
                      id        = "requestdescription" 
					  onchange  = "verifystatus('#url.reqid#')" 
					  totlength = "200"
					  style     = "border:1px solid silver;padding-left:3px;font-size:16px;height:28px;width:99%;min-height:30px">#url.des#</textarea>					
					  
			</cfif>			
			
			</td>
			
			<td>	
			
			<!--- toggle mode to basic 					
									
			  <cfif Parameter.RequestDescriptionMode neq "0">				  			  
				  <cfif url.access neq "View" and Line.actionStatus lte "2">				 			 				  
				  	  <cf_img icon="open" id="viewmorebutton" name="viewmorebutton">					  						   					   
				   </cfif> 				   
			   <cfelse>			   			   	
				 <cf_img icon="open" id="viewmorebutton" name="viewmorebutton">	 				   			   
			   </cfif>
			   
			   --->
			   
			</td>
			</tr>				
			
			<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT RequisitionNo 
				FROM   RequisitionLineService 
				WHERE  RequisitionNo = '#URL.reqid#'
				UNION
				SELECT RequisitionNo  
				FROM   RequisitionLineTravel 
				WHERE  RequisitionNo = '#URL.reqid#'
				UNION
				SELECT RequisitionNo  
				FROM   Employee.dbo.PositionParentFunding 
				WHERE  RequisitionNo = '#URL.reqid#'
		    </cfquery>
								
			<!--- change the requirements as we no longer enforce entry in the beginning --->	
																	
			<cfif Check.recordcount gte "0">
																
				<tr>
				<td name="servicecontentbox" id="servicecontentbox" style="padding-right:23px">
																		
					<cfif url.access eq "view">
									
						  <cfset url.id = url.reqid>				  				  
						  <cfinclude template="setInterface.cfm">
					 				 
					<cfelse>
					
						 <cfset acc = "Edit"> 
						 <cfset url.id = url.reqid>
															 
						 <cfinclude template="setInterface.cfm">
																		 					 				  
						 <script>
						   try { document.getElementById("serviceinput").value = "Yes" } catch(e) {}  
						 </script>
					 
					</cfif>							
						
				</td></tr>			
															
			
			</cfif>		
								
		</table>
	  
	</cfcase>
			
	<cfcase value="uom">
					
		<cfquery name="UoM" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_UoM
		</cfquery>
				
		<cfif url.Access eq "View">
			 #url.UoM#
		<cfelse>
			
			<select name="quantityuom" id="quantityuom" size="1" class="regularxxl">
		    	<cfloop query="UoM">
				<option value="#Code#" <cfif Code eq url.uom>selected</cfif>>
		    		#Description#
				</option>
				</cfloop>
			</select>
		</cfif>		
	  
	</cfcase>
	
	</cfswitch>

</cfoutput>

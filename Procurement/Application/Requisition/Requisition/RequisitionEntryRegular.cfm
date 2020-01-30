
<cfparam name="URL.mode"   default="">
<cfparam name="URL.des"    default="">
<cfparam name="URL.option" default="uom">
<cfparam name="URL.access" default="#url.mode#">

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
	   
   		   <tr><td width="100%" style="padding-bottom:3px;height:1px"  class="labelmedium">
		   
			<cfif url.Access eq "View">
				
				#url.des# 
				  
			<cfelse>	
											
				<textarea class = "regular" 
				      onkeyup   = "ismaxlength(this);" 
					  name      = "requestdescription" 
                      id        = "requestdescription" 
					  onchange  = "verifystatus('#url.reqid#')" 
					  totlength = "200"
					  style     = "padding:3px;font-size:14px;height:27;width:96%">#url.des#</textarea>					
					  
			</cfif>			
			
			</td>
			
			<td>
			
			  <cfif Parameter.RequestDescriptionMode neq "0">			
			  
				  <cfif url.access neq "View" and Line.actionStatus lte "2">
				  				  
					  <img src="#SESSION.root#/Images/viewmore.gif" 
					   alt="Record more details" 
					   id="viewmorebutton"
					   name="viewmorebutton"
					   class="regular"
					   style="width:23;height:23px"
					   onclick="enterservice()"
					   border="0" 
					   align="absmiddle">
					   					   
				   </cfif> 
			   
			   </cfif>
			   
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
				<td name="servicecontentbox" id="servicecontentbox" class="labelit" style="padding-right:23px">
							
				<cfif url.access eq "view">
								
				  <cfset url.id = url.reqid>				  				  
				  <cfinclude template="RequisitionEditDetail.cfm">
				 				 
				<cfelse>
				
				 <cfset acc = "Edit"> 
				 								 
				 <cfdiv id="iservice"
				  bind="url:#SESSION.root#/procurement/application/requisition/Requisition/RequisitionEditDetail.cfm?itemmaster={itemmaster}&access=#acc#&id=#URL.reqid#">
				  
				  <script>
				   try { document.getElementById("serviceinput").value = "Yes" } catch(e) {}  
				  </script>
				 
				</cfif>							
						
				</td></tr>				
										
			<cfelse>
			
				<tr>				
					<td colspan="1" name="servicecontentbox" id="servicecontentbox" class="hide"><cfdiv id="iservice"/></td>
				</tr>	
				
				<script>
				   try { document.getElementById('bdet#URL.reqid#_detail').className = "hide" } catch(e) {}
				</script>	
				
				<cfif url.access neq "view">
				
				<script>
				   try { document.getElementById("serviceinput").value = "Yes" } catch(e) {}
				</script>		
				
				</cfif>
							
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
			
			<select name="quantityuom" id="quantityuom" size="1" class="regularxl">
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

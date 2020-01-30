
<cfparam name="URL.access" default="EDIT">
<cfparam name="URL.mode"   default="default">

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLine 
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLineService 
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission  = '#Line.Mission#'	
 </cfquery>
 
<cfif url.mode eq "default">

   <!--- if default determine if to be shown ---> 
 
   <cfif Parameter.RequestDescriptionMode eq "1">
   
   		<cfset url.mode = "extended">
   		
   </cfif>
  
</cfif>

<cfparam name="URL.ID2" default="">
	
<table width="100%" class="formpadding">

    
  <tr>
    <td width="100%" align="center">
	
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
	
		<cfif url.mode eq "Listing">
			
			<cfoutput>
				<tr><td height="1" colspan="8" class="labelit">#Line.RequestDescription#</td></tr>
			</cfoutput>
		
		</cfif>
		
		<cfif url.mode eq "Listing" and detail.recordcount eq "0">	
		
			<!--- hide --->
		
		<cfelse>
				
	    <tr class="labelmedium line">
			
		 <td width="80"><cf_tl id="Item"></td>		
	     <td width="30%"><cf_tl id="Description"></td>    		 
	    
	     <cfif url.mode eq "extended">
		 
		     <td height="20" width="70"><cf_tl id="Qty"></td>  
		     <td width="20%" colspan="2"><cf_tl id="UoM"></td>  
			 
		 <cfelse>
		 
		     <td height="20" width="70"><cf_tl id="Qty"></td> 
		 	 <td width="10%"><cf_tl id="Start"></td>	 
			 <td width="10%"><cf_tl id="End"></td>
			 
	     </cfif>
		 
	     <td align="right" class="labelsmall">
		   		   		   
		   <cfif parameter.EnableCurrency eq "0">
		   
		   <cf_tl id="Rate">
		   
		   <cfelse>		   
		  		   		   			
				<cfquery name="Currency" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM   Currency
					WHERE  EnableProcurement = 1
				</cfquery>
		   
			     <cfif Line.RequestCurrency eq "">
					<cfset cur = Parameter.DefaultCurrency>
				<cfelse>
				    <cfset cur = Line.RequestCurrency>
				</cfif>
				
				<cfoutput>	
				
				<cfif url.access eq "Edit">
				
					<select name="ratecurrency" id="ratecurrency"
				        size="1"
				        style="font-size: 11px"
				        onChange="document.getElementById('requestcurrency').value=this.value;base2('#url.id#',requestcurrencyprice.value,requestquantity.value);">
						
							<cfloop query="currency">
								<option value="#Currency#" <cfif Currency eq cur>selected</cfif>>
						   		#Currency#
								</option>
							</cfloop>
					</select>
				
				<cfelse>
				    #cur#
				</cfif>
				
				</cfoutput>
			</cfif>	
		   
		   </td>	
		   <td align="right" class="labelit"><cf_tl id="Total"></td>  		  
		   
		   <td width="7%" align="center" class="labelmedium">
		   
	         <cfoutput>
			 <cfif url.access eq "Edit" or url.access eq "Limited">			 
				 <cfset jvlink = "ColdFusion.Window.create('dialogservice', 'Service Detail', '',{x:100,y:100,height:400,width:520,resizable:false,modal:true,center:true});ColdFusion.navigate('../Service/ServiceItemDialog.cfm?ID=#URL.ID#&ID2=new&mode=#url.mode#','dialogservice')">							 
			     <A href="javascript:#jvlink#">[<cf_tl id="add">]</a>
			 </cfif>
			 </cfoutput>
			 
		   </td>
		  
	    </TR>	
					
		<cfif detail.recordcount eq "0">
		
		<tr class="line"><td colspan="8" class="labelmedium" style="height:40px" align="center"><cf_tl id="There are no records to show in this view"><cfif url.access eq "Edit"><A href="javascript:<cfoutput>#jvlink#</cfoutput>">[<cf_tl id="add">]</a></cfif></td></tr>
						
		</cfif>
		
			<cfoutput query="Detail">		
			
			  	<cfset jvlink = "ColdFusion.Window.create('dialogservice', 'Service Detail', '',{x:100,y:100,height:375,width:520,resizable:false,modal:true,center:true});ColdFusion.navigate('../Service/ServiceItemDialog.cfm?ID=#URL.ID#&ID2=#serviceid#&mode=#url.mode#','dialogservice')">							 
								 	
				<TR class="navigation_row">
				    
					<td class="labelit">
					<cfif url.access eq "Edit">
					<a href="javascript:#jvlink#">#PersonnelActionNo#</a>
					<cfelse>
					#PersonnelActionNo#
					</cfif>
					</td>
				    <td class="labelit">#servicedescription#</td>
									
					<cfif url.mode eq "extended">
								
					    <td height="20" class="labelit">#serviceQuantity#</td>
				    	<td align="center" height="20" class="labelit">#quantity#</td>
						<td class="labelit">#uoM#</td>
						
					<cfelse>
					
						 <td class="labelit" height="20">#serviceQuantity#</td>
						 <td class="labelit">#dateformat(ServiceEffective,CLIENT.DateFormatShow)#</td>
					     <td class="labelit">#dateformat(ServiceExpiration,CLIENT.DateFormatShow)#</td>	
						
					</cfif>
									
					<td align="right" class="labelit">#numberformat(uOMRate,",.__")#</td>				
					<td align="right" class="labelit">#numberformat(Amount,",.__")#</td>
					
				    <td align="center">
					
						<table cellspacing="0" cellpadding="0"><tr>
					
						<cfif url.access eq "Edit">
						
							<td style="padding-left:4px">
							   <cf_img icon="delete" onclick="deletedetail('#URL.ID#','#serviceid#')">											   				 					
							</td>
							  
						</cfif>	  
						
						</tr>
						</table>
					
				  </td>
				   
			    </TR>	
				
				<cfquery name="ServiceUnit" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization
					WHERE  OrgUnit  = '#ServiceOrgunit#'						
				</cfquery>
				
				<cfif serviceunit.recordcount eq "1">
				
				<tr class="navigation_row_child">
				<td></td>
				<td class="labelit" colspan="7"><font color="808080"><cf_tl id="Beneficiary">:</font>
				
				    <cfif serviceUnit.HierarchyRootUnit eq serviceUnit.OrgUnitCode>
						#ServiceUnit.OrgUnitName#
					<cfelse>
					
						<cfquery name="Parent" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM   Organization
							WHERE  OrgUnitCode  = '#ServiceUnit.HierarchyRootUnit#'		
							AND    Mission = '#ServiceUnit.Mission#'		
							AND    MandateNo = '#ServiceUnit.MandateNo#'						
						</cfquery>
				
					    #Parent.OrgUnitName# / #ServiceUnit.OrgUnitName#
					</cfif>
					
				</td>
				
				</tr>
				
				</cfif>
				
				<tr><td colspan="8" class="line"></td></tr>
							
			</cfoutput>
			
		</cfif>	
							
	</table>
	</td>
	</tr>
							
</table>

<cfset ajaxonload("doHighlight")>
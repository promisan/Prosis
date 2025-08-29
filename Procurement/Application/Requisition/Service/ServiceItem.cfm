<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	
		
    <table width="100%" class="navigation_table">
	
		<cfif url.mode eq "Listing">
			
			<cfoutput>
				<tr><td height="1" colspan="8" class="labelit">#Line.RequestDescription#</td></tr>
			</cfoutput>
		
		</cfif>
		
		<cfif url.mode eq "Listing" and detail.recordcount eq "0">	
		
			<!--- hide --->
		
		<cfelse>
				
	    <tr class="labelmedium line fixlengthlist">
			
		 <td><cf_tl id="Item"></td>		
	     <td><cf_tl id="Description"></td>    		 
	    
	     <cfif url.mode eq "extended">		 
		     <td height="20"><cf_tl id="Qty"></td>  
		     <td colspan="2"><cf_tl id="UoM"></td> 			 
		 <cfelse>		 
		     <td height="20"><cf_tl id="Qty"></td> 
		 	 <td><cf_tl id="Start"></td>	 
			 <td><cf_tl id="End"></td>			 
	     </cfif>
		 
	     <td align="right">
		   		   		   
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
				        style="height:25px;font-size:12px;border-bottom:0px"
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
		   <td align="right"><cf_tl id="Total"></td>  		  
		   
		   <td width="7%" align="center" class="labelmedium" style="padding-left:3px">		   
		   
	         <cfoutput>
			 <cfif url.access eq "Edit" or url.access eq "Limited">			 
				 <cfset jvlink = "ProsisUI.createWindow('dialogservice', 'Service Detail', '',{x:100,y:100,height:450,width:520,resizable:false,modal:true,center:true});ptoken.navigate('../Service/ServiceItemDialog.cfm?ID=#URL.ID#&ID2=new&mode=#url.mode#','dialogservice')">							 
			     <A href="javascript:#jvlink#"><cf_tl id="add"></a>
			 </cfif>
			 </cfoutput>
			 
		   </td>
		  
	    </TR>	
					
		<cfif detail.recordcount eq "0">
		
		<tr class="line"><td colspan="8" class="labelmedium" style="height:40px" align="center"><cf_tl id="There are no records to show in this view"><cfif url.access eq "Edit"><A href="javascript:<cfoutput>#jvlink#</cfoutput>">[<cf_tl id="add">]</a></cfif></td></tr>
						
		</cfif>
		
			<cfoutput query="Detail">		
			
			  	<cfset jvlink = "ProsisUI.createWindow('dialogservice', 'Service Detail', '',{x:100,y:100,height:450,width:520,resizable:false,modal:true,center:true});ptoken.navigate('../Service/ServiceItemDialog.cfm?ID=#URL.ID#&ID2=#serviceid#&mode=#url.mode#','dialogservice')">							 
								 	
				<TR class="navigation_row fixlengthlist labelmedium2">
				    
					<td>
					<cfif url.access eq "Edit">
					<a href="javascript:#jvlink#">#PersonnelActionNo#</a>
					<cfelse>
					#PersonnelActionNo#
					</cfif>
					</td>
				    <td>#servicedescription#</td>
									
					<cfif url.mode eq "extended">
								
					    <td height="20">#serviceQuantity#</td>
				    	<td align="center" height="20">#quantity#</td>
						<td>#uoM#</td>
						
					<cfelse>
					
						 <td height="20">#serviceQuantity#</td>
						 <td>#dateformat(ServiceEffective,CLIENT.DateFormatShow)#</td>
					     <td>#dateformat(ServiceExpiration,CLIENT.DateFormatShow)#</td>	
						
					</cfif>
									
					<td align="right">#numberformat(uOMRate,",.__")#</td>				
					<td align="right">#numberformat(Amount,",.__")#</td>
					
				    <td align="center">
					
						<table><tr>
					
						<cfif url.access eq "Edit">
						
							<td style="padding-left:4px;padding-top:2px">
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
				
				<tr class="navigation_row_child fixlengthlist">
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
	

<cfset ajaxonload("doHighlight")>
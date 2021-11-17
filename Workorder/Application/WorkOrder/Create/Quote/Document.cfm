

<!--- new order --->

<cfquery name="get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT *
     FROM   CustomerRequest
	 WHERE  RequestNo = '#url.requestNo#'			
</cfquery>

<cfquery name="getLine" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT *
     FROM   CustomerRequestLine
	 WHERE  RequestNo = '#url.requestNo#'			
</cfquery>

<cfquery name="Type" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT *
	 FROM    ServiceItem
	 WHERE   Code IN (SELECT ServiceItem 
	                  FROM   ServiceItemMission 
				      WHERE  Mission = '#get.mission#')
	AND      ServiceDomain IN (SELECT ServiceDomain FROM Ref_ServiceItemDomainClass WHERE ServiceType = 'Sale') 			   
	AND      Operational = 1
	ORDER By ListingOrder
</cfquery>

<cfquery name="Class" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Code, Description 
	FROM  Ref_ServiceItemDomain
	WHERE Code IN (SELECT ServiceDomain FROM Ref_ServiceItemDomainClass WHERE ServiceType = 'Sale') 			   	
</cfquery>

<cfform method="POST" name="salesorder" onsubmit="return false">

<cfoutput>

	<table width="96%" align="center" class="formpadding formspacing">
	
		<cfquery name="Owner" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		
			SELECT    O.OrgUnit, O.OrgUnitCode, O.OrgUnitName
			FROM      Materials.dbo.Warehouse AS W INNER JOIN
                      Organization.dbo.Organization AS O ON W.MissionOrgUnitId = O.MissionOrgUnitId
			WHERE     W.Warehouse = '#get.Warehouse#'		  
			ORDER BY W.Created DESC
		</cfquery>	
		
		<tr class="labelmedium2">
		<td><cf_tl id="Owner">:</td>
		<td>
		
			<table>
				 <tr><td>
				       
					 <cfinput type="text" name="orgunitname1" id="orgunitname1" value="#Owner.OrgUnitName#" message="No unit selected" required="No" class="regularxxl" size="40" maxlength="80" readonly>					  
					 
					 </td>
					 
					 <td style="padding-left:2px">
					 
					 
					     <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
						   onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
						   onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
						   style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
						   onClick="selectorgN('#get.mission#','administrative','orgunit','applyorgunit','1','1','modal')">
					  	     
							 <input type="hidden" name="orgunit1"      id="orgunit1" value="#Owner.OrgUnit#"> 
							 <input type="hidden" name="mission1"      id="mission1"> 
							 <input type="hidden" name="orgunit1code"  id="orgunit1code">
						   	 <input type="hidden" name="orgunit1class" id="orgunit1class"> 
					 					 
					 </td>
					 <td class="hide" id="process"></td>
				  </tr>			 
	         </table>
		
		</td>
		</tr>
		
		<tr class="labelmedium2">
		<td><cf_tl id="Class">:</td>
		<td>
		
		<select name="servicedomain" class="regularxxl">   
		   <cfloop query="Class">
		   	<option value="#Code#">#Description#</option>
		   </cfloop>
	   </select>
		
		
		</td>
		</tr>
		
		<tr class="labelmedium2">
		<td><cf_tl id="Service">:</td>
		<td>
		 <select name="serviceitem" class="regularxxl">   
		   <cfloop query="Type">
		   	<option value="#Code#">#Description#</option>
		   </cfloop>
	   </select>
		
		</td>
		</tr>
				
		<tr class="labelmedium2">
		<td><cf_tl id="Customer">:</td>
		<td>
		
		<cfinvoke component  = "Service.Process.WorkOrder.Customer"  
		   method            = "syncCustomer" 
		   customerId        = "#get.CustomerId#"
		   returnvariable    = "customer">	
		   
		   <input type="hidden" name="customerid" value="#customer.customerid#" style="width:100px">
		   
		   <input type="text" class="regularxxl" name="CustomerName" value="#customer.customername#" style="width:100%">
		   		
		<!--- method to obtain or sync the customer from materials to workorder and present the customer --->
		
		
		</td>
		</tr>
		
		<tr class="labelmedium2">
		<td><cf_tl id="Reference">:</td>
		<td>
		<input type="text" class="regularxxl" name="Reference" id="Reference" value="#get.RequestNo#" style="width:100px">
		</td>
		</tr>
		<tr class="labelmedium2">
		<td><cf_tl id="Order date">:</td>
		<td>
		
		       <cfset st = Dateformat(now(), CLIENT.DateFormatShow)>
			
			     <cf_intelliCalendarDate9
					FieldName="OrderDate" 
					Manual="True"		
					class="regularxl"								
					Default="#st#"
					AllowBlank="False">		
		
		</td>
		</tr>
		
		<tr class="labelmedium2">
		<td><cf_tl id="Due date">:</td>
		<td>
		
		  <cfset st = Dateformat(now()+1, CLIENT.DateFormatShow)>
			
			     <cf_intelliCalendarDate9
					FieldName="DateExpiration" 
					Manual="True"		
					class="regularxl"								
					Default="#st#"
					AllowBlank="False">		
		
		</td>
		</tr>
		
		<tr class="labelmedium2">
		<td><cf_tl id="Currency">:</td>
		<td>
		
		<cfquery name="Currency" 
		 datasource="AppsLedger" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      Currency				  
			 WHERE      Operational = 1			
		</cfquery>
				
		<select name="Currency" class="regularxxl">
		<cfloop query="Currency">
		    <option value="#currency#" <cfif getLine.SalesCurrency eq currency>selected</cfif>>#Currency#</option>
		</cfloop>
		</select>
		
		</td>
		</tr>
				
		<tr class="labelmedium2 line">
		<td valign="top" style="padding-top:3px"><cf_tl id="Memo">:</td>
		
		<td>
		<textarea name="memo" style="height:35px;font-size:15px;padding:3px;width:99%">#get.Remarks#</textarea>		
		</td>
		</tr>
		
		<tr>
		  <td colspan="2" align="center">
		  
		  <table><tr><td>
		  	  <input type="button" class="button10g" style="width:200px;border:1px solid silver" onclick="submitOrder('#url.requestno#')" name="Submit" value="Submit">
		  </td>
		  
		  <td style="padding-left:10px"><cf_tl id="Open quote"></td>
		  
		  <td>
		  <input type="checkbox" name="openquote" value="1" checked>
		  </td>
		  
		  </tr></table>
		  
		  </td>
		</tr>
	
	</table>
	
</cfoutput>	

</cfform>

<cfset ajaxonload("doCalendar")>


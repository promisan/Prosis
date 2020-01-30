
<!--- --------CUSTOM FORM DATA ENTRY --------- --->
<!--- ---------------------------------------- --->
<!--- --Deliver service for Kuntz data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">

<cfparam name="url.customerid"    default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.scope"         default="entry">
<cfparam name="url.serviceitem"   default="#type.code#">

<cfform name="orderform" onsubmit="return false">
	
	<input type="hidden" name="serviceitem" id="serviceitem" value="<cfoutput>#url.serviceitem#</cfoutput>">
	<input type="hidden" name="scope" id="scope" value="<cfoutput>#url.scope#</cfoutput>">
		
	<cfquery name="WorkOrder" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrder
		WHERE  WorkOrderId   = '#URL.workorderid#'						  
	</cfquery>		
	
	<cfif workorder.recordcount eq "1">
	
		<cfquery name="Customer" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   Customer
			WHERE  CustomerId   = '#workorder.customerid#'						  
		</cfquery>			
	
	<cfelse>
	
		<cfquery name="Customer" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   Customer
			WHERE  CustomerId   = '#url.customerid#'						  
		</cfquery>		
	
	</cfif>
	
	<cfquery name="Line" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrderLine
		WHERE  WorkOrderId   = '#URL.workorderid#'		  
		AND    WorkOrderLine = '#url.workorderline#'					  
	</cfquery>	
	
	<cfquery name="Org" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  Mission  = '#URL.Mission#'						  
		AND    OrgUnitClass != 'Administrative'
		ORDER BY OrgUnitName
	</cfquery>			
	
	<cfquery name="Person" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM   Person	
		WHERE  ( PersonNo IN (SELECT PersonNO 
		                   FROM   vwAssignment
						   WHERE  DateEffective < getdate() and DateExpiration > getDate() 
						   AND    AssignmentStatus IN ('0','1'))
		AND    PersonStatus = '1'
		
		)
		
		OR 	  PersonNo IN ( SELECT PersonNo 
						    FROM   WorkOrder.dbo.WorkOrderLine
							WHERE WorkOrderId = '#url.workorderid#'															
						   )
		
	</cfquery>		
		
	
	<table width="97%" border="0" cellspacing="3" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>			
			
	<tr>
	    <td style="padding-left:5px" class="labelmedium"><cf_tl id="Branch">:</td>
		<td>
		
		<select name="OrgUnitOwner" id="OrgUnitOwner" class="regularxl">
		    <cfoutput query="Org">
			<option value="#OrgUnit#" <cfif WorkOrder.OrgUnitOwner eq OrgUnit>selected</cfif>>#OrgUnitName#</option>
			</cfoutput>
		</select>
		
		</td>
	</tr>
	
	<cfoutput>
		
	<tr><td style="padding-left:3px;font-size:25px;height:45px" class="labellarge"><cf_tl id="Customer"></td></tr>
		
	<tr><td style="padding-left:5px" class="labelmedium"><cf_tl id="Name">:</td><td>	
		<cfinput type="text" name="CustomerName" message="Please enter a name" required="Yes" value="#Customer.CustomerName#" style="width:90%" maxlength="80" class="enterastab regularxl">
	   </td>
    </tr>
	<tr>
		<td style="padding-left:5px" class="labelmedium"><cf_tl id="Address">:</td>	
		<td><input type="text" name="Address" id="Address" value="#Customer.Address#" style="width:90%" maxlength="100" class="enterastab regularxl"></td>
	</tr>
	<tr><td style="padding-left:5px" class="labelmedium"><cf_tl id="Postal Code">:</td><td>
		<input type="text" name="PostalCode" id="PostalCode" value="#Customer.PostalCode#" style="width:80" maxlength="7" class="enterastab regularxl">
	</td>
	</tr>
	<tr><td style="padding-left:5px" class="labelmedium"><cf_tl id="City">:</td><td>
		<input type="text" name="City" id="City" value="#Customer.City#" style="width:300" maxlength="40" class="enterastab regularxl">
	</td></tr>
	<tr><td style="padding-left:5px" class="labelmedium"><cf_tl id="Phone">:</td><td>
		<input type="text" name="PhoneNumber" id="PhoneNumber" value="#Customer.PhoneNumber#" style="width:200" maxlength="50" class="enterastab regularxl">
	</td>
	<tr><td style="padding-left:5px" class="labelmedium"><cf_tl id="Mobile Number">:</td><td>
		<input type="text" name="MobileNumber" id="MobileNumber" value="#Customer.MobileNumber#" style="width:200" maxlength="50" class="enterastab regularxl">
	</td>
	</tr>
	</cfoutput>
	
	<!--- Line fields --->
		
	<tr><td height="20" style="padding-left:3px;font-size:25px;height:45px" class="labellarge"><cf_tl id="Delivery"></td></tr>	
	
	<!--- disabled for new version 
	
	<tr>
	    <td style="padding-left:5px" class="labelmedium"><cf_tl id="Driver">:</td>
		<td>
		
		<select name="PersonNo" id="PersonNo" class="enterastab regularxl">
		<option value=""></option>
		    <cfoutput query="Person">
			<option value="#PersonNo#" <cfif Line.PersonNo eq PersonNo>selected</cfif>>#FullName#</option>
			</cfoutput>
		</select>
		
		</td>
	</tr>
	
	--->
		
	<cfset url.inputclass = "regularxl">
		
	<!--- Custom classification fields --->
	<cfinclude template="../CustomFields.cfm">	
			
	<!--- Custom action fields --->
	<cfif workorder.recordcount eq "0" or url.context eq "Portal">		    
		<cfset datemode = "Request">		
	<cfelseif url.context eq "Backoffice" and getAdministrator("*") eq "0">	    
		<cfset datemode = "Planning"> 						
	<cfelse>		
	    <cfset datemode = "Actual"> 		
	</cfif>
	
	<cf_WorkOrderActionFields
	       mission        = "#url.mission#" 
	       serviceitem    = "#url.serviceitem#" 
		   workorderid    = "#url.workorderid#" 
		   workorderline  = "#url.workorderline#"
		   mode           = "edit"
		   calendar       = "9"							  
		   actiondatemode = "#datemode#">
	
	
		
</table>

</cfform>

<cfset AjaxOnLoad("doCalendar")>
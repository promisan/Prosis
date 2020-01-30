
	
<cfquery name="pendingSubmission" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WarehouseCart 
    WHERE  Warehouse IN (SELECT Warehouse 
	                     FROM   Warehouse 
						 WHERE  Mission = '#url.mission#')
						   
		
	AND ShipToWarehouse is NOT NULL

	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->

	<cfelse>	
		
		AND  (
		
				 ShipToWarehouse IN (
				 <!--- only if the user may indeed submit for the warehouse --->
				 #preservesinglequotes(requestaccess)#	
			     ) OR
				 ShipToWarehouse IN (
				 <!--- only if the user may indeed submit for the warehouse --->
				 #preservesinglequotes(facilityaccess)#	
			     )
			 )	
			
	</cfif>		
					
</cfquery>

<cfif pendingSubmission.recordcount gte "1">

	<cfset cnt = pendingSubmission.recordcount>

	<cfoutput>
	   
	   <tr><td colspan="13" align="center">
	   
	   <cf_tableround mode="modal" color="white" padding="0" totalwidth="100%">
	   
		    <table width="100%" cellspacing="0" cellpadding="0" bgcolor="yellow">
		    <tr>
			
			<td style="padding-left:6px;width:35">
			 <img src="#SESSION.root#/images/logos/warehouse/checkout.png" height="30" width="30" border="0" align="absmiddle">
			</td>
			<td style="padding-left:6px;padding-bottom:0px" class="labellarge">
			<table>
			<tr><td class="labellarge">
				<font color="gray"><i><b>Alert:</b></font><font color="black"> There <cfif cnt eq "1">is<cfelse>are</cfif> <b>#cnt#</b> request<cfif cnt gt "1">s</cfif> pending submission
			</td></tr>
			<tr><td class="labelit" style="padding-left:10px">#session.welcome# notification service</td></tr>
			</table>
			</td>
			<td style="padding-right:16px" align="right">
			<input type="button" name="Submit" value="Submit" class="button10s" onclick="processcart('#url.mission#')" style="font-size:15;height:30;width:130">
			</td>			
			</tr>	 
			</table>
		
	   </cf_tableround>
	   
	   </td></tr>
	    
	</cfoutput>  
	
<cfelse>

	<tr><td colspan="13" align="center">
		<input type="button" name="Submit" class="button10s" value="Add new Request" onclick="processcart('#url.mission#')" style="font-size:15;height:30;width:190">
		</td>
	</tr>
	
</cfif>

<tr><td height="4"></td></tr>
<tr><td colspan="13" class="linedotted"></td></tr>
<tr><td height="4"></td></tr>
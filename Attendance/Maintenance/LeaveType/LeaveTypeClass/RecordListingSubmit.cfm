
<cfif URL.code neq "new">

	 <cfquery name="Update" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			UPDATE Ref_LeaveTypeClass
			SET 
			Description           = '#Form.Description#',
			ListingOrder          = '#Form.ListingOrder#',
			LeaveMaximum          = '#Form.LeaveMax#',
			CompensationPointer   = '#Form.CompensationPointer#',
			<cfif Form.CompensationLeaveType eq "">
			CompensationLeaveType = NULL,
			<cfelse>
			CompensationLeaveType = '#Form.CompensationLeaveType#',
			</cfif>
			PointerLeave	      = '#Form.PointerLeave#',
			<cfif Form.EntityClass neq "">
				EntityClass       = '#Form.EntityClass#',
			<cfelse>
				EntityClass       =  NULL,    
			</cfif>
			Operational	          = '#Form.Operational#',
			StopEntitlement       = '#Form.StopEntitlement#',
			StopAccrual   		  = '#Form.StopAccrual#'
			
			WHERE Code            = '#URL.Code#'
			AND   LeaveType       = '#URL.ID1#'
	</cfquery>
				

<cfelse>
			
	<cfquery name="Verify" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_LeaveTypeClass
		WHERE Code      = '#Form.Code#' 
		AND   LeaveType = '#URL.ID1#'
	</cfquery>

    <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
		     alert("A record with this code has been registered already!")
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_LeaveTypeClass
			         (LeaveType,
					 Code,
					 Description,
					 LeaveMaximum,
					 CompensationPointer,
					 CompensationLeaveType,
					 PointerLeave,
					 <cfif Form.EntityClass neq "">
					 	EntityClass,
					 </cfif>
					 StopAccrual,
					 StopEntitlement,
					 ListingOrder,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#URL.ID1#',
			  		  '#Form.Code#', 
			          '#Form.Description#',
					  '#Form.LeaveMax#',
					  '#Form.CompensationPointer#',
					  <cfif Form.CompensationLeaveType eq "">
					  NULL,
					  <cfelse>
					  '#Form.CompensationLeaveType#',
					  </cfif>
					  '#Form.PointerLeave#',
					  <cfif Form.EntityClass neq "">
					 	'#Form.EntityClass#',
					 </cfif>
					  '#Form.StopAccrual#',
					  '#Form.StopEntitlement#',
  	  				  '#Form.ListingOrder#',
					  '#Form.Operational#',
			   	      '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				      '#SESSION.first#',
				       getDate()) 
		  </cfquery>
		  
	</cfif>	  
		   	
</cfif>

<cfset url.code = "">
<cfinclude template="RecordListingDetail.cfm">


<cfparam name="url.scope" default="requisition">

<cfoutput>

	<cfquery name="Clean" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE RequisitionLine
		 SET PersonNo = '#url.pers#'
		 WHERE RequisitionNo = '#url.id#'		
	</cfquery>

	<cfquery name="Clean" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM RequisitionLineItinerary
		 WHERE RequisitionNo = '#url.id#'		
	</cfquery>
	
	<cfloop index="itm" list="1,2,3,4,99" delimiters=",">
	
		<cfparam name="Form.LocationCity#itm#"        default="">
		<cfparam name="Form.City#itm#Id"              default="">
		<cfparam name="Form.DateDeparture#itm#"       default="">
		<cfparam name="Form.DateArrival#itm#"         default="">
		<cfparam name="Form.TransportDeparture#itm#"  default="0">
		<cfparam name="Form.TransportArrival#itm#"    default="0">
		<cfparam name="Form.TransportMode#itm#"       default="">
		<cfparam name="Form.TransportClass#itm#"      default="">
		<cfparam name="Form.Memo#itm#"                default="">
				
		<cfset City                = evaluate("Form.City#itm#ID")>
		<cfset DateDeparture       = evaluate("Form.DateDeparture#itm#")>
		<cfset DateArrival         = evaluate("Form.DateArrival#itm#")>
		<cfset TransportDeparture  = evaluate("Form.TransportDeparture#itm#")>
		<cfset TransportMode       = evaluate("Form.TransportMode#itm#")>
		<cfset TransportClass      = evaluate("Form.TransportClass#itm#")>
		<cfset TransportArrival    = evaluate("Form.TransportArrival#itm#")>
		<cfset Memo                = evaluate("Form.Memo#itm#")>
						
		<cfif DateDeparture neq ''>
		    <CF_DateConvert Value="#DateDeparture#">
			<cfset DEP = dateValue>
		<cfelse>
		    <cfset DEP = 'NULL'>
		</cfif>	
		
		<cfif DateArrival neq ''>
		    <CF_DateConvert Value="#DateArrival#">
			<cfset ARR = dateValue>
		<cfelse>
		    <cfset ARR = 'NULL'>
		</cfif>	
		
		<cfif city neq "">
		
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO RequisitionLineItinerary
				         (RequisitionNo,
						 ItineraryLineNo,						
						 CountryCityId,
						 DateArrival,
						 DateDeparture,
						 TransportArrival,
						 TransportDeparture,
						 TransportMode,
						 TransportClass,
						 Memo, 
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
			      VALUES ('#url.id#',
				          '#itm#',				         
						  '#city#',
				          #arr#,
						  #dep#,
						  '#transportarrival#',
						  '#transportdeparture#',
						  '#TransportMode#',
						  '#TransportClass#',
						  '#Memo#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
			</cfquery>
			
			
		
		</cfif>
				
	</cfloop>
		
	<script>
		  
		<cfif url.scope eq "requisition">   
		ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Travel/TravelItem.cfm?ID=#URL.ID#','iservice')
		<cfelse>
		ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/Travel/TravelItem.cfm?mode=edit&ID=#URL.ID#','iservice')
		</cfif>
		ProsisUI.closeWindow('dialogitin')
		
	</script>	

</cfoutput>
 	

  

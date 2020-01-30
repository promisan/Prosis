
<cfparam name="Attributes.TransactionId"   default="">
<cfparam name="Attributes.AssetId"    	   default="">
<cfparam name="Attributes.DataSource"      default="appsMaterials">

<cfparam name="Attributes.Event1"    	   default="">
<cfparam name="Attributes.EventDate1"      default="">
<cfparam name="Attributes.EventDetails1"   default="">

<cfparam name="Attributes.Event2"    	   default="">
<cfparam name="Attributes.EventDate2"      default="">
<cfparam name="Attributes.EventDetails2"   default="">

<cfparam name="Attributes.Event3"    	   default="">
<cfparam name="Attributes.EventDate3"      default="">
<cfparam name="Attributes.EventDetails3"   default="">

<cfparam name="Attributes.Event4"    	   default="">
<cfparam name="Attributes.EventDate4"      default="">
<cfparam name="Attributes.EventDetails4"   default="">

<cfparam name="Attributes.Event5"    	   default="">
<cfparam name="Attributes.EventDate5"      default="">
<cfparam name="Attributes.EventDetails5"   default="">

<cfloop from = "1" to = "5" index="i">

	<cfset Event        = Evaluate("Attributes.Event#i#")>
	<cfset EventDate    = Evaluate("Attributes.EventDate#i#")>
	<cfset EventDetails = Evaluate("Attributes.EventDetails#i#")>	
	
	<cfif Event neq "">
	
		<cfquery name = "qInsertMetric" 
	     datasource="#Attributes.DataSource#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 
			INSERT INTO AssetItemEvent
				       (AssetId, 
					    EventCode, 
						DateTimePlanning, 
						EventDetails, 
						TransactionId, 
						ActionStatus, 
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)
			VALUES ('#Attributes.AssetId#',
			        '#Event#',
					'#EventDate#',
					'#EventDetails#',
					'#Attributes.TransactionId#',
					'1',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')
		</cfquery>		
		
	</cfif>						
	
</cfloop>	
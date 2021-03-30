
<cfset url.name = "e">

<!---  password       = "Hanno621004" --->

<cfexchangeconnection action = "OPEN"
	          connection     = "ConExch"
	          server         = "mail.promisan.com"
		      username       = "information"	         
			  mailboxname    = "information"
			  password       = "Promisan17@info"
			  serverversion  = "2016"
	          protocol       = "https">
			
		<cfoutput>	  
		<cfsavecontent variable="taskmessage">
								
		  Action      : 777777777777777777777					  
		  <p></p>		
		  Reference   : 9999999999999999999999999999				  
		  <p></p>						  
		  <b>Instruction</b> : <a href="#SESSION.root#">Click here to process it</a>					  
		 								
		</cfsavecontent>	
		</cfoutput>  

		<cfscript>
		stask=StructNew();
		stask.Priority     = "low";
		stask.Status       = "Not_Started";
		stask.DueDate      = "3:00 PM 03/30/2021";
		stask.Subject      = "#now()# My New Task to be tested";
		stask.PercentCompleted=50;
		stask.Message      = "#taskmessage#";
		</cfscript>

      <!--- Create the task using a transient connection. --->

      <cfexchangetask action="create"
            connection  = "ConExch"			
			task        = "#stask#"
			result      = "varUID">	
			
		<cftry>	
		 <cfexchangetask action="delete"
            connection  = "ConExch"						
			uid="#session.var#">	
			
			<cfcatch>not found</cfcatch>  	
			
		</cftry>	
		
		
			
		
		<!--- getmail	  
		<cfexchangemail action="get"
	          connection  = "ConExch"
			  name        = "result"> 			  
			    <cfset endTime = Now()>
				<cfset startTime = DateAdd("d","-1", endTime)>								
				<cfexchangefilter name="TimeSent" from="#startTime#" to="#endTime#">			  					  			  
		</cfexchangemail>	
		--->
		
		<!--- get Address book	  
		<cfexchangecontact action="get"
	          connection  = "ConExch"
			  name        = "Address"> 			  			  
			  <cfexchangefilter name="LastName" value="Ola">						  			  
		</cfexchangecontact>	  		
		--->
			  
	<cfexchangeconnection action="close" connection="ConExch">
	
	<!---
	
	<cfdump var="#result#">			 
	
	---> 
	
	<cfset session.var = varUID>
	
	<cfoutput>#varUID#</cfoutput>
	
	
	
<!--- refresing --->
	
<cfquery name="TaskType" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_TaskType
 </cfquery>	  

<cfoutput>

 <cfloop query="tasktype">
 
 	<cfset url.tasktype = code>
 	
	<!--- disabled 28/11/2012
    <cfinclude template = "../Task/Shipment/TaskDeliveryStatus.cfm">
	--->
	
	<cfinvoke component = "Service.Process.Materials.Taskorder"  
		   method           = "TaskorderList" 
		   mission          = "#url.mission#"
		   warehouse        = "#url.warehouse#"
		   tasktype         = "#code#"
		   stockorderid     = ""
		   selected         = ""
		   returnvariable   = "gettask">	
	
	  <script language="JavaScript"> 
	        try { 
            document.getElementById('treestatus_#code#_unassigned').innerHTML = "#getTask.recordcount#"		
			} catch(e) {}
      </script>
  
	  <cfquery name="sStatus" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">					  
			  SELECT   Class,
			           Status,
					   ListingOrder,
					   Description
			  FROM     Status
			  WHERE    Class   = 'TaskOrder'
			  AND      Show    = '1'
			  ORDER BY ListingOrder				  
	  </cfquery>	
	  
	  <cfloop query = "sStatus">
	  
	        <cfif url.warehouse neq "" and url.mission neq "">
	  
			    <cfinvoke component = "Service.Process.Materials.Taskorder"  
				   method           = "CountStatus" 
				   mode             = "counting"
				   mission          = "#url.mission#"
				   warehouse        = "#url.warehouse#"
				   tasktype         = "#url.tasktype#"
				   STA              = "#Status#"							  
				   returnvariable   = "getCount">			
				
				<script language="JavaScript">  
					    try {
		    		    document.getElementById('#url.tasktype#_treestatus_#sStatus.Class#_#sStatus.Status#').innerHTML = "#getCount#"		
						} catch(e) {}
			    </script>
			
			</cfif>
						 	
	  </cfloop>
	
 </cfloop>	

</cfoutput>

<cf_compression>

  
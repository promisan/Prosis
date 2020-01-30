
<!--- Generic script to apply all the items of the request --->
 
<!--- perform a cfc posting function --->  
	
 <cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
	   method           = "RevertRequest" 
	   requestid        = "#Object.ObjectKeyValue4#">	

	  
	  
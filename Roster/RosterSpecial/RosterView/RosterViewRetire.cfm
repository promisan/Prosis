
<cftransaction>
  
  <cfquery name="Parameter" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	  SELECT *
	  FROM   Ref_ParameterOwner
	  WHERE  Owner = '#URL.Owner#'
  </cfquery>
		
	<!--- logging --->
	
	<cf_RosterActionNo ActionRemarks="Batch retirement" 
	                   ActionCode="FUN"> 
					   	
		
	<cfquery name="UpdateFunctionStatusAction" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO  ApplicantFunctionAction
			   (ApplicantNo,
			   FunctionId, 
			   RosterActionNo, 
			   Status,
			   StatusDate)
		SELECT ApplicantNo, 
		       FunctionId, 
			   '#RosterActionNo#', 
			   '5', 
			   '#dateformat(now(),client.dateSQL)#'
		FROM   ApplicantFunction
		WHERE  FunctionId = '#URL.ID#'
		AND    Created < getDate() - #Parameter.ProcessDays#
		AND    Status = '0'
	</cfquery>
			
	<cfquery name="RetireNow" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE ApplicantFunction 
		
		SET    Status                = '5',
		       StatusDate            = '#dateformat(now(),client.dateSQL)#',
	    	   FunctionJustification = 'Batch retirement' 
			   
		WHERE  FunctionId = '#URL.Id#'
		AND    Created < getDate() - #Parameter.ProcessDays#		
		AND    Status = '0'
		
	</cfquery>	
	
</cftransaction>

<cfoutput>
<script>
  Prosis.busy('no')  
  <!---  listing('#url.occ#','show','#url.mode#','#url.filter#','#url.level#','#url.line#','','#url.exerciseclass#') --->
  listing('#url.occ#','show','#url.mode#','#url.filter#','#url.level#','#url.line#','','')
</script>
</cfoutput>



	
	

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

    <cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
	<cfset DTE = dateValue>
	
	<cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Snapshot
		WHERE  SnapshotDate = #dte#
		AND    EditionId    = '#form.editionid#'		
		AND    Period       = '#form.period#'
	</cfquery>

   <cfif Verify.recordCount gte 1>
   
   		<script language="JavaScript">
   		     alert("A snapshot for this date has been registered already!")     
	    </script>  
  
   <cfelse>
   
   		<cftransaction>
		
		<cf_assignid>	
	   
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_Snapshot
			         (SnapshotBatchId,
					  SnapshotDate,
					  Period,
					  EditionId,
					  Memo,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,	
					  Created)
			  VALUES ('#rowguid#',
			          #dte#,
			          '#Form.Period#', 
					  '#Form.EditionId#',
					  '#Form.Memo#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
		</cfquery>
		
		<cfquery name="Snapshot" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				INSERT INTO ProgramAllotmentRequestSnapshot
						(SnapShotBatchId,
						 SnapshotDate,
						 RequirementId, 
						 ProgramCode, 
						 Period, 
						 EditionId, 
						 ObjectCode, 
						 Fund, 
						 BudgetCategory,
						 ActivityId,
						 ItemMaster, 
						 TopicValueCode, 
						 RequestType,
						 RequestDescription, 
						 RequestDue, 
						 RequestLocationCode,
			             ResourceUnit, 
						 ResourceQuantity, 
						 ResourceDays, 
						 RequestQuantity, 
						 RequestPrice, 
						 AmountBaseAllotment,
						 RequestRemarks, 
						 ActionStatus, 
						 Source, 
			             SourceId, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName, 
						 Created)
				SELECT   '#rowguid#',
				         #dte#, 
				         RequirementId, 
						 ProgramCode, 
						 Period, 
						 EditionId, 
						 ObjectCode, 
						 Fund, 
						 BudgetCategory,
						 ActivityId,
						 ItemMaster, 
						 TopicValueCode, 
						 RequestType,
						 RequestDescription, 
						 RequestDue, 
						 RequestLocationCode,
			             ResourceUnit, 
						 ResourceQuantity, 
						 ResourceDays, 
						 RequestQuantity, 
						 RequestPrice, 		
						 AmountBaseAllotment,				
						 RequestRemarks, 
						 ActionStatus, 
						 Source, 
			             SourceId, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName, 
						 Created
				FROM     ProgramAllotmentRequest
				WHERE    EditionId = '#Form.EditionId#'
				AND      Period    = '#Form.Period#'
				<!--- only cleared requirements 
				AND      ActionStatus = '1'
				--->
				
		</cfquery>
		
		</cftransaction>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Snapshot
		SET    Memo             = '#Form.Memo#'
		WHERE  SnapshotBatchId  = '#url.SnapshotBatchId#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	    DELETE FROM Ref_Snapshot		
		WHERE  SnapshotBatchId   = '#url.SnapshotBatchId#'
    </cfquery>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  

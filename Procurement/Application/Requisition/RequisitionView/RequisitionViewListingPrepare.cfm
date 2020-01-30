
<!--- extended search --->

<cfparam name="url.Mode"                 default="">
<cfparam name="Form.CaseNo"              default="">
<cfparam name="Form.PersonNo"            default="">
<cfparam name="Form.Period"              default="">
<cfparam name="Form.WorkOrderId"         default="">
<cfparam name="Form.ActionStatus"        default="">
<cfparam name="Form.ProgramCode"         default="">
<cfparam name="Form.EntryClass"          default="">
<cfparam name="Form.RequestDescription"  default="">
<cfparam name="Form.Reference"           default="">
<cfparam name="Form.AnnotationSel"       default="">
<cfparam name="Form.DateStart"           default="">
<cfparam name="Form.DateEnd"             default="">
 
<cfset condition = "">
		
  <cfif Form.Period eq "">
	  <cfset condition = "WHERE L.Mission = '#URL.Mission#'">
  <cfelse> 
	  <cfset condition = "WHERE L.Period = '#Form.Period#' and L.Mission = '#URL.Mission#'">
  </cfif>
  
  <cfset text = "Inquiry">
  
  <cfif Form.ActionStatus neq "">
       <cfset condition   = "#condition# AND L.ActionStatus IN (#Form.ActionStatus#)">	   
  </cfif>   
  
  <cfif Form.ProgramCode neq "">
       <cfset condition   = "#condition# AND L.RequisitionNo IN (SELECT RequisitionNo FROM RequisitionLineFunding WHERE programCode = '#Form.ProgramCode#')">	   
  </cfif>  
  
  <cfif Form.WorkOrderId neq "''" AND Form.WorkOrderId neq "">
       <cfset condition   = "#condition# AND L.WorkOrderId IN (#preservesingleQuotes(form.workorderid)#)">	   
  </cfif>  
 
  <cfif Form.EntryClass neq "">
        <cfset condition  = "#condition# AND  L.ItemMaster IN (SELECT Code FROM ItemMaster WHERE EntryClass = '#Form.EntryClass#') ">
  </cfif>	 
  
  <cfif Form.PersonNo neq "">
        <cfset condition  = "#condition# AND  L.PersonNo Like '%#Form.PersonNo#%'">
  </cfif>	
    
  <cfif Form.RequestDescription neq "">
		<cfset condition  = "#condition# AND L.RequestDescription LIKE  '%#Form.RequestDescription#%'">		
  </cfif>	
	
  <cfif Form.Reference neq "">
        <cfset condition  = "#condition# AND (L.RequisitionNo LIKE '%#Form.Reference#%' or L.Reference LIKE  '%#Form.Reference#%' or L.CaseNo LIKE '%#Form.Reference#%')">
  </cfif>	
  
  <cfif Form.Annotationsel neq "">  
  	    <cfset condition  = "#condition# AND L.RequisitionNo IN (SELECT ObjectKeyValue1 FROM System.dbo.UserAnnotationRecord WHERE Account = '#SESSION.acc#' AND  EntityCode = 'ProcReq' AND AnnotationId = '#Form.annotationsel#')">	
  </cfif>
  
  <cfif Form.DateStart neq "">
	     <cfset dateValue = "">
		 <CF_DateConvert Value="#Form.DateStart#">
		 <cfset dte = dateValue>
		 <cfset condition = "#condition# AND L.Created >= #dte#">
  </cfif>	
  
  <cfif Form.DateEnd neq "">
		 <cfset dateValue = "">
		 <CF_DateConvert Value="#Form.DateEnd#">
		 <cfset dte = dateValue>
		 <cfset condition = "#condition# AND L.Created <= #dte#">
  </cfif>	
      
<cfset FileNo = round(Rand()*10)> 
 
<CF_DropTable dbName="AppsQuery"  tblName="loc#SESSION.acc#Requisition#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#RequisitionBase#FileNo#">		
   
<cfsavecontent variable="SubInfo">

	  (  SELECT count(*) 
		 FROM RequisitionLineTravel
		 WHERE RequisitionNo = L.RequisitionNo						 
	  )  as IndTravel,			  
	  
	  (  SELECT count(*)
		 FROM Employee.dbo.PositionParentFunding
         WHERE RequisitionNo = L.RequisitionNo
	  )  as IndPosition,
	  	
	  (  SELECT count(*)
         FROM RequisitionLineService
         WHERE RequisitionNo = L.RequisitionNo
      )  as IndService,		
	  
	  (  SELECT CustomDialog
         FROM   Ref_EntryClass S2, ItemMaster S1
         WHERE  S2.Code = S1.EntryClass
		 AND    S1.Code = L.ItemMaster
         )  as CustomDialog,	
		 
	 (  SELECT count(*)
		 FROM   RequisitionLineTopic R, Ref_Topic S
		 WHERE  R.Topic = S.Code
		  AND    S.Operational   = 1
		  AND    R.RequisitionNo = L.RequisitionNo) as CountedTopics,	
		
		 
	 (  SELECT CustomForm
         FROM ItemMaster
         WHERE Code = L.ItemMaster
         )  as CustomForm			 
				  
</cfsavecontent>

<cfinvoke component = "Service.Process.Procurement.Requisition"  
	   method           = "getQueryScope" 
	   role             = "#url.role#" 
	   returnvariable   = "UserRequestScope">	

<cftransaction isolation="READ_UNCOMMITTED">
   
<cfquery name="Set" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT L.*, 
		       #preservesingleQuotes(subinfo)#,
		       ' ' as Buyer, 
			  
			     (SELECT Description 
					   FROM   Status 
					   WHERE  Status = L.ActionStatus
					   AND    StatusClass       = 'Requisition') as StatusDescription, 
					   
			   ' ' as PurchaseNo, 
			   ' ' as PurchaseStatus, 
			   ' ' as Receipt,
				   (SELECT  RequisitionPurpose 
					FROM    Requisition
				    WHERE   Reference = L.Reference) as RequisitionPurpose
		INTO  userQuery.dbo.loc#SESSION.acc#Requisition#FileNo#
		FROM  RequisitionLine L
							
		#preserveSingleQuotes(Condition)#		
				
		AND   L.ActionStatus != '0' AND L.ActionStatus != '0z'   	
		AND   L.RequestType  IN ('Regular','Warehouse') 	
		
		<cfif Form.CaseNo neq "">
    
 		AND L.JobNo IN (
		                SELECT JobNo 
		                FROM   Job 
						WHERE  (CaseNo LIKE '%#Form.CaseNo#%' OR JobNo LIKE '%#Form.CaseNo#%')
						AND    Mission = '#url.mission#'
					    )
 
		</cfif>
		
		<cfif url.mode neq "all">
			<cfif getAdministrator(url.mission) eq "1">
					<!--- no filtering --->
			<cfelse>
					AND  #preserveSingleQuotes(UserRequestScope)# 					
			</cfif>		
		</cfif>
		
</cfquery>
	   	   	   	   
<cfquery name="Base" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT count(*) as Total
		INTO   userQuery.dbo.tmp#SESSION.acc#RequisitionBase#FileNo#
		
		FROM  RequisitionLine L, Status S 
						
			#preserveSingleQuotes(Condition)#		
			
			AND	  S.Status       = L.ActionStatus
			AND   L.ActionStatus != '0'  
			AND   L.ActionStatus != '0z'
	    	AND   S.StatusClass  = 'Requisition'
			AND   L.RequestType  IN ('Regular','Warehouse') 	
			
			<cfif Form.CaseNo neq "">
	  
					AND L.JobNo IN (
			                SELECT JobNo 
			                FROM   Job 
							WHERE  (CaseNo LIKE '%#Form.CaseNo#%' or JobNo LIKE '%#Form.CaseNo#%')
							AND    Mission = '#url.mission#' 
				    )
	
			</cfif>	
							
</cfquery>	  

</cftransaction>	
	  	  		   	   
<cflocation url="RequisitionViewGeneral.cfm?FileNo=#FileNo#&Period=#URL.Period#&Mission=#URL.Mission#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&Role=#url.role#" addtoken="No">


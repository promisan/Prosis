
<cfparam name="url.message"      default="">
<cfparam name="url.source"       default="">
<cfparam name="url.search"       default="">
<cfparam name="url.unit"         default="">
<cfparam name="url.annotationid" default="">
<cfparam name="url.fund"         default="">
<cfparam name="url.status"       default="1">

<cfset fun = "0">
 
<cfoutput>

	<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
	</cfquery>	
				
	<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    L.*, 
	          I.EntryClass, 
			  I.Description, 
		 
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
			  
			  (  SELECT count(*)
				 FROM   RequisitionLineTopic R, Ref_Topic S
				 WHERE  R.Topic = S.Code
			     AND    S.Operational   = 1
			     AND    R.RequisitionNo = L.RequisitionNo
			   ) as CountedTopics,	  
					  
			  Org.Mission, 			  
			  Org.MandateNo, 
			  Org.HierarchyCode, 
			  Org.OrgUnitName
			  
	FROM      RequisitionLine L, 
	          ItemMaster I, 
			  Organization.dbo.Organization Org
	
	<cfif url.status eq "1">	
	
	WHERE     ((L.ActionStatus > '1' and L.ActionStatus < '9' and L.Reference is NULL) OR (L.ActionStatus = '1'))
	<cfelse>
	WHERE     L.ActionStatus = '1f'	
	</cfif>
	
	<cfif url.source neq "">
	AND       L.Source = '#url.source#'
	</cfif>
	
	AND       L.OrgUnit = Org.OrgUnit
	
	<!--- you may only submit your own requisitions !! --->
	
	<cfif url.annotationid neq "">
			
		<cfif url.annotationid eq "None">
			
			AND  L.RequisitionNo NOT IN (SELECT ObjectKeyValue1
			                         FROM   System.dbo.UserAnnotationRecord
									 WHERE  Account = '#SESSION.acc#' 
									 AND    EntityCode = 'ProcReq')	
			
		<cfelse>

			AND  L.RequisitionNo IN (SELECT ObjectKeyValue1
			                         FROM   System.dbo.UserAnnotationRecord
									 WHERE  Account = '#SESSION.acc#' 
									 AND    EntityCode = 'ProcReq' 
									 AND    AnnotationId = '#url.annotationid#')	
									 
		</cfif>						 
			
	</cfif>
		
	<cfif getAdministrator(url.mission) eq "0">
	AND      ( 				
				L.RequisitionNo IN (
				                    SELECT RequisitionNo 
	                                FROM   RequisitionLineActor 
								    WHERE  ActorUserId = '#SESSION.acc#'
								    AND    Role        = 'ProcReqEntry' 
								   )
								   
				OR  L.OrgUnit	IN (
				                    SELECT OrgUnit
									FROM   Organization.dbo.OrganizationAuthorization
									WHERE  UserAccount = '#SESSION.acc#'
									AND    OrgUnit     = L.OrgUnit
									AND    Role        = 'ProcReqEntry'
									AND    ClassParameter = I.EntryClass
								   )	
								   
				OR  L.Mission	IN (
				                    SELECT Mission
									FROM   Organization.dbo.OrganizationAuthorization
									WHERE  UserAccount = '#SESSION.acc#'
									AND    OrgUnit is NULL
									AND    Role        = 'ProcReqEntry'
									AND    ClassParameter = I.EntryClass									
								   )			   				      						   
								      	
				OR	L.OfficerUserid = '#SESSION.acc#'
				)			  					 
	
	</cfif>				
	
	<cfif url.fund neq "">	
	AND   L.RequisitionNo IN (SELECT RequisitionNo FROM RequisitionLineFunding WHERE Fund = '#url.fund#')
	</cfif>
	
	AND   L.Period     = '#URL.Period#'	
	AND   Org.Mission  = '#URL.Mission#'			
	AND   RequestType != 'Purchase'		
	AND   I.Code       = L.ItemMaster 
	AND   LEN(L.RequestDescription) > 0	
	
	<cfif url.unit neq "">
	AND   L.OrgUnit = '#url.Unit#'
	</cfif>
	
	<cfif url.search neq "">
		AND   (L.Reference LIKE '%#URL.Search#%' OR 
	       L.RequisitionNo LIKE '%#URL.Search#%' OR 
		   L.RequestDescription LIKE '%#URL.Search#%' OR 
		   I.Description LIKE '%#URL.Search#%' OR 
		   L.OfficerLastName LIKE '%#URL.Search#%' OR
		   L.OfficerFirstName LIKE '%#URL.Search#%') OR
		   L.RequisitionNo IN (SELECT RequisitionNo 
		                       FROM RequisitionLineTopic
							   WHERE RequisitionNo = L.RequisitionNo
							   AND   (CAST(TopicValue AS varchar(100)) LIKE '%#URL.Search#%'))
							   
							   
							   
	</cfif>	   
		
	ORDER BY Reference, L.Created DESC							
	</cfquery>		
				
	<cfset Mode = "Pending">	
	
	<table width="100%" height="100%" class="formpadding">
	  
	    <cfif url.message neq "">
			<tr><td height="5"></td></tr>	
			<tr><td colspan="2" class="labelmedium">&nbsp;#url.message#</td></tr>
		</cfif>
		
		<cfparam name="url.page" default="1">
		
		<cfquery name="Count"
         dbtype="query">
		 	SELECT DISTINCT RequisitionNo
			FROM   Requisition		 
		 </cfquery>		
		 		 		 		
		<cf_PageCountN count="#count.recordcount#" show="#Parameter.LinesInView#">		
				
		<tr class="line">
			<td>
						
			<input type="hidden" name="status" id="status" value="#url.status#">
						
			<table class="formpadding">	
			
				<tr>
						
					<td style="padding-left:10px"><input type="radio" class="radiol" onclick="document.getElementById('status').value='1';reqsearch()" name="statussel" id="statussel" value="1" <cfif url.status eq "1">checked</cfif>></td>
					<td style="font-size:19px;font-weight:250;padding-left:3px;cursor:pointer" class="labelmedium" onclick="document.getElementById('status').value='1';reqsearch()"><cfif url.status eq "1"><b></cfif><cf_tl id="Pending Submission"></td>
					<td style="width:10"></td>
					<td><input type="radio" class="radiol" onclick="document.getElementById('status').value='1f';reqsearch()" name="statussel" id="statussel" value="1f" <cfif url.status eq "1f">checked</cfif>></td>
					<td style="font-size:19px;font-weight:250;padding-left:3px;cursor:pointer" class="labelmedium" onclick="document.getElementById('status').value='1f';reqsearch()"><cfif url.status eq "1f"><b></cfif><cf_tl id="Forecasted Requirements"></td>			
										
				</tr>
			
			</table>				
			
			</td>
					   
		<cfif pages lte "1">
		   
		   		<input type="hidden" name="page" id="page" value="1">
				
		<cfelse>
		   		   	
			<td height="25" align="right">
		   		   		
				<cfset currrow = 0>
				<cfset navigation = 1>
				
				<cf_tl id="Page" var="1">
				<cfset vPage = lt_text>
	
				<cf_tl id="Of" var="1">
				<cfset vOf = lt_text>
		   			   				
			    <select name="page" id="page" class="regularxl" onChange="reqsearch()">
				   
					   <cfloop index="Item" from="1" to="#pages#" step="1">
			              <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>#vPage# #Item# #vOf# #pages#</option></cfoutput>
			           </cfloop>	 
				   
		        </SELECT>	
			   
			 </td>			 	
				   
		</cfif>  
		
		</tr>   
				
		<!---
		<cfset md         = "RequisitionNo">	
		--->
		
		<!--- disabled after discussion with CMP 14/5/2009		
		<cfset fundcheck  = "budget">	--->		
		
		<cfset fundcheck  = "Funds">	
		
		<tr>
			<td colspan="2" style="height:100%;padding-left:15px;padding-right:15px">							
			   <cfinclude template="RequisitionListing.cfm">
			</td>
		</tr>	
		
		<!--- refreshing the view by status --->
		<cfset url.role = "ProcReqEntry">
		<cfinclude template="../RequisitionView/RequisitionViewTreeRefresh.cfm">
								
		<cf_tl id="Submit for review" var="1">
		<cfset vSubmit=#lt_text#>
		
		<CFIF requisition.recordcount gt "0">
								
			<tr class="line">
			<td align="center" style="height:50" colspan="2" class="line">			
			   <input type="button" onclick="submitdata('#url.period#')" style="font-size:16px;height:31;width:260px" name="PostData" id="PostData" value="#vSubmit#" class="button10g">
			</td>
			</tr>
				
			
		</CFIF>
		
	</table>	
		
</cfoutput>		

<script>
	Prosis.busy('no')
</script>
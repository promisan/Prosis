<!--- create selection lines --->
<cfparam name="SESSION.reqNo" default="'0'">
<cfset url.selected = SESSION.reqNo>
<cfparam name="url.mode"         default="Pending">
<cfparam name="url.type"         default="">
<cfparam name="url.annotationid" default="">	
<cfparam name="url.orgunit" default="">	
<cfparam name="url.personno" default="">	

<cfset mode = url.mode>


<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_ParameterMission
	  WHERE Mission = '#URL.Mission#'
</cfquery>

<cfparam name="URL.search" default="">
	
	<cfset st = "'2k'">
		
	<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    L.*, 
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
				  
				  (  SELECT CustomDialog
			         FROM Ref_EntryClass
			         WHERE Code = I.EntryClass
		          )  as CustomDialog,		
				  
				   (  SELECT count(*)
				 FROM   RequisitionLineTopic R, Ref_Topic S
				 WHERE  R.Topic = S.Code
			     AND    S.Operational   = 1
			     AND    R.RequisitionNo = L.RequisitionNo
			   ) as CountedTopics,	  
				  
				  		  
				  I.CustomForm,
				  
				  Org.Mission, 
				  Org.MandateNo, 
				  Org.HierarchyCode, 
				  Org.OrgUnitName,
				  
				  <!--- get the preferred vendor for this itemmaster --->
				  
				  (  SELECT TOP 1 OrgUnit
			        FROM   Organization.dbo.Organization O, ItemMasterVendor V 
					WHERE  V.Code          = L.ItemMaster
					AND    V.Mission       = L.Mission
					AND    V.OrgUnitVendor = O.OrgUnit
					AND    V.Preferred = 1
		          ) as VendorOrgUnit,		
				  
			     (  SELECT TOP 1 OrgUnitName
			        FROM   Organization.dbo.Organization O, ItemMasterVendor V 
					WHERE  V.Code          = L.ItemMaster
					AND    V.Mission       = L.Mission
					AND    V.OrgUnitVendor = O.OrgUnit
					AND    V.Preferred = 1
		          ) as VendorOrgUnitName		
				  
		FROM      RequisitionLine L, 
		          ItemMaster I, 				  
				  Organization.dbo.Organization Org
		WHERE     L.ActionStatus IN (#preserveSingleQuotes(st)#) 
		AND       L.OrgUnit = Org.OrgUnit
		AND       (L.JobNo is NULL OR L.JobNo = '') 
			
		<cfif mode neq "pending" and url.selected neq "'0'">
				
			AND   L.RequisitionNo IN (#preservesinglequotes(url.selected)#) 
								
		<cfelseif mode eq "view">
		
			AND   L.RequisitionNo = ''
			
		</cfif>
		
		<!--- filter the lines to be selected here --->
		
		<cfif mode eq "Travel">
		
			AND       L.PersonNo IN (SELECT PersonNo FROM Employee.dbo.Person)
			<cfif url.personno neq "">
			AND       L.PersonNo = '#URL.PersonNo#'  
			</cfif>
			
		
		<cfelseif mode eq "Position">
		
			AND        L.ItemMaster IN (
			                            SELECT I.Code 
		                                FROM   ItemMaster I, Ref_EntryClass R
									    WHERE  I.EntryClass = R.Code
									    AND    (
									       
										        (R.CustomDialog = 'Contract') AND I.CustomForm = 1  
										   												   								   
										      OR									   
											  
										      I.CustomDialogOverwrite = 'Contract'								  										  
											  										  
											 
										      )	
									   )		
		
		<cfelseif mode eq "job" or mode eq "po">
				
			AND       (L.PersonNo is NULL or L.PersonNo = '') 		
			AND        L.ItemMaster NOT IN (SELECT I.Code 
		                                FROM   ItemMaster I, Ref_EntryClass R
									    WHERE  I.EntryClass = R.Code
										
									    AND    (
									       
										        (R.CustomDialog = 'Contract' AND I.CustomForm = 1)
										   
										         OR		
										   							   
										         I.CustomDialogOverwrite = 'Contract'								  										  
											  
										       )	
									   )	   		
		
		</cfif>
		
		<cfif getAdministrator(url.mission) eq "1">
				
				<!--- no filtering --->
										
		<cfelse>
		
		AND       (
		
		        L.RequisitionNo IN (SELECT RequisitionNo
		                            FROM   RequisitionLineActor  									
								    WHERE  ActorUserId = '#SESSION.acc#'
									AND    Role = 'ProcBuyer') 										
										
				OR
	
	            I.EntryClass IN (
					 SELECT DISTINCT ClassParameter 
					 FROM   Organization.dbo.OrganizationAuthorization 
					 WHERE  Role        = 'ProcManager'
					 AND    UserAccount = '#SESSION.acc#'
					 AND    (OrgUnit = L.OrgUnit or Mission = '#url.mission#')
					 AND    ClassParameter = I.EntryClass				
					 AND    AccessLevel IN ('1','2'))
				
			 )						
														
		</cfif>		
				
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
		
		<cfif url.search neq "">	
			AND   (L.RequestDescription LIKE '%#URL.Search#%' OR 
			       L.CaseNo LIKE '%#URL.Search#%' OR 
				   L.Reference LIKE '%#URL.Search#%' OR 
				   I.Description LIKE '%#URL.Search#%' OR
				   L.PersonNo     IN (SELECT PersonNo
				                      FROM   Employee.dbo.Person
								      WHERE  PersonNo = L.PersonNo
								      AND    FullName LIKE '%#URL.Search#%') OR
					
				   <!--- search for topic value --->				 
				   L.RequisitionNo IN (SELECT RequisitionNo 
		                               FROM RequisitionLineTopic
							           WHERE RequisitionNo = L.RequisitionNo
							           AND   (CAST(TopicValue AS varchar(100)) LIKE '%#URL.Search#%')) OR		

				   <!--- search for items for a specific vendor --->			   		 
				   L.ItemMaster    IN (SELECT Code
							           FROM   Organization.dbo.Organization O, ItemMasterVendor V 
									   WHERE  V.Code          = L.ItemMaster
									   AND    V.Mission       = L.Mission
									   AND    V.OrgUnitVendor = O.OrgUnit
									   AND    V.Preferred = 1
									   AND    O.OrgUnitName LIKE '%#URL.Search#%') 
				   )		
			AND   I.Code = L.ItemMaster 
		<cfelse>
			AND   I.Code = L.ItemMaster 
		</cfif> 			
		AND       L.Period  = '#URL.Period#'	
		AND       Org.Mission = '#URL.Mission#'					
		ORDER BY  Org.Mission, Org.MandateNo, Org.HierarchyCode, L.Reference,L.Created DESC				
		
		
					
	</cfquery>
	
	<cfif Requisition.recordcount eq "0">
			
			<cfoutput>
	
				 <script>
					try {	
					document.getElementById("#mode#_submit").className = "hide";
					} catch(e) {}		
				
				</script>
			
			</cfoutput>
			
	</cfif>		
		
	<cfparam name="url.page" default="1">
		
	<cfquery name="Count"
        dbtype="query">
	 	SELECT DISTINCT Reference
		FROM   Requisition		 
	 </cfquery>				 		
	 		 		 		
	<cf_PageCountN count="#count.recordcount#" show="#Parameter.LinesInView#">
					   
	<cfif pages lte "1">
		   
	   		<input type="hidden" name="pagesel" id="pagesel" value="1">
			
	<cfelse>
	
		<table width="100%" align="center">
	   
		   	<tr>
				<td align="right" valign="bottom">
			   		   		
					<cfset currrow = 0>
					<cfset navigation = 1>
					
					<cf_tl id="Page" var="1">
					<cfset vPage = lt_text>
		
					<cf_tl id="Of" var="1">
					<cfset vOf = lt_text>
			   			
					<cfoutput>   				
				    <select name="pagesel" id="pagesel" class="regularxl" onChange="reqsearch(this.value)">					  
					   <cfloop index="Item" from="1" to="#pages#" step="1">
			              <cfoutput><option value="#Item#"<cfif URL.page eq Item>selected</cfif>>#vPage# #Item# #vOf# #pages#</option></cfoutput>
			           </cfloop>	 					   
			        </SELECT>	
					</cfoutput>	
				   
				 </td>
			 </tr>  	
		 
		 </table>
			   
	</cfif>    
	
	<cfoutput>
	
		 <script>
			try {	
			document.getElementById("CaseName").value = '#Requisition.OrgUnitName#';
			} catch(e) {}		
		
		</script>
		
		<cfif Requisition.vendorOrgUnitName neq "">
		
			<!--- initially populate vendor and currency based on the selection --->
			
			<script>
				try {	
					if (document.getElementById("vendororgunit").value == '') { 
						document.getElementById("vendororgunit").value = '#Requisition.vendorOrgUnit#'; 
						document.getElementById("vendororgunitname").value = '#Requisition.vendorOrgUnitName#';
					}
				} catch(e) {}			
			</script>		
		
			<cfquery name="get" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     Purchase
				WHERE    OrgUnitVendor = '#Requisition.vendorOrgUnit#'
				ORDER BY Created DESC
			</cfquery>	
						
			<cfif get.Currency neq Application.BaseCurrency>
			
				<script>
					_cf_loadingtexthtml='';	
					se = document.getElementById("currencybox")
					if (se) {
					   ColdFusion.navigate('getCurrency.cfm?currency=#get.Currency#','currencybox') 
					}
				</script>
			
			</cfif>			
		
		</cfif>
										
		<cfset fun = "Job">		
																	
		<cfinclude template="../../Requisition/Process/RequisitionListing.cfm">		
								
		<cfset SESSION["reqlist_#mode#"] = "#QuotedValueList(Requisition.RequisitionNo)#">				  
		
	</cfoutput>	
	
	<script>
		Prosis.busy('no');
	</script>
	
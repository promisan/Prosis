
<cfoutput>

<script language="JavaScript">

function savechange() {    
	ColdFusion.navigate('RequestEditSubmit.cfm?id=#url.id#','result','','','POST','requestform')
}

function cancelexecutionreq() {		
		   		
		   se = document.getElementById("execution_reason")
		   ln = document.getElementById("submit_reason")
		   m = document.getElementById("submitline")
		  
		   if (se.className == "hide") {
		       se.className = "regular"
			   ln.className = "regular"
			   m.className  = "hide"
			  
		   } else {
		       se.className = "hide"	
			   ln.className = "hide"
			   m.className  = "regular"   
		   }
	  				
}

function hla(itm,val,fld){

     se = document.getElementById(itm+'_0')	
	
	 if (fld != false) {
		 se.className = "highLight5";
		 document.getElementById(itm).value = val		
		  try {				
			 document.getElementById(itm+'_1').className = "regular"						
			 document.getElementById(itm+'_2').className = "regular"			
			 } catch(e) {}	
	 } else { 
	      se.className = "header"; 
		   document.getElementById(itm).value = ""
		  try {
			 document.getElementById(itm+'_1').className = "hide"
			 document.getElementById(itm+'_2').className = "hide"
			 } catch(e) {}	
	 }
	 	
  }  
  
function savereason() {   
	ColdFusion.navigate('RequestEditCancel.cfm?id=#url.id#&action=cancel','result','','','POST','requestform')
}  

function showreasons(id) {
   ColdFusion.Window.create('executereasons', 'Purchase execution reasons for cancellation', '',{x:100,y:100,height:300,width:640,modal:false,center:true})>		
   ColdFusion.Window.show('executereasons')
   ColdFusion.navigate('#SESSION.root#/procurement/application/PurchaseOrder/ExecutionRequest/CancellationReasons.cfm?id='+id,'executereasons')
}

</script>

</cfoutput>

<cfajaximport tags="cfmenu,cfdiv,cfwindow">
<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_dialogProcurement>
<cf_textareascript>

<cfquery name="Get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    PurchaseExecutionRequest
		WHERE   RequestId = '#URL.ID#'
</cfquery>

<!--- view status --->
<cfset viewstatus = "2">

<cfif get.actionStatus lt viewstatus or get.actionStatus eq "1p">
   <cfset acc = "edit">
<cfelse>
   <cfset acc = "view">
</cfif>

<!--- ------- --->
<!--- details --->
<!--- ------- --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ExecutionRequest_#client.sessionNo#"> 

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
CREATE TABLE dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo# ( 
	[SerialNo] [int] IDENTITY (1, 1) NOT NULL,
	[DetailDescription] [varchar] (80) NULL ,
	[DetailReference] [varchar] (20) NULL ,
	[DetailQuantity] [float] NULL	,
	[DetailRate] [float] NULL ,
	[DetailAmount] [float]  NULL	
) ON [PRIMARY]
</cfquery>

<cfquery name="Populate" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    INSERT INTO UserQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo# 
	(DetailDescription,DetailReference,DetailQuantity,DetailRate,DetailAmount)
    SELECT DetailDescription,DetailReference,DetailQuantity,DetailRate,DetailAmount
    FROM   PurchaseExecutionRequestDetail
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Purchase" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Purchase
		WHERE   PurchaseNo = '#get.PurchaseNo#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Purchase.Mission#'
</cfquery>


<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM OrganizationObject
	 WHERE  ObjectKeyValue4   = '#URL.Id#'	
</cfquery>	

<cfquery name="Status"
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM Ref_EntityStatus
	 WHERE  EntityCode = 'ProcExecution'
	 AND EntityStatus = '#Get.ActionStatus#'	
</cfquery>	

<cfif Get.recordcount eq "0">
  <cf_message message="Problem, this request does no longer exist in the database.">
  <cfabort>
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  banner="gray" 
              layout="webapp"
			  jquery="Yes"
			  line="no" 
			  label="Purchase Execution Request #Get.Reference#">

<cf_divscroll style="height:100%;padding:10px">
			  
	<cfform name="requestform" method="POST">
	
	<table width="94%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td height="5"></td></tr>
	<cfoutput query="Get">
	
	<tr><td class="hide" id="result" align="center" height="100" colspan="2"></td></tr>
	
	<tr id="submitline">
	
		<td colspan="2" align="left" height="40">
		<table width="100%"><tr><td>
		
		<cf_tl id="Delete Request" var="vDelete">
		<cf_tl id="Cancel Request" var="vCancel">
		<cf_tl id="Print" var="vPrint">
		<cf_tl id="Save and Close" var="vSave">
		
		 <cfif Get.ActionStatus lt viewstatus>
	 	    <input type="button" class="button10g" style="width:120" name="Delete" id="Delete" value="#vDelete#" onClick="ptoken.navigate('RequestEditCancel.cfm?id=#url.id#&action=delete','result')">
			<input type="button" class="button10g" style="width:120" name="Cancel" id="Cancel" value="#vCancel#" onClick="cancelexecutionreq()">
		 </cfif> 
		 <input type="button" name="Print" id="Print" class="button10g" value="#vPrint#" style="width:120" onClick="ptoken.navigate('RequestEditPrint.cfm?id=#url.id#','result')">
		 <cfif Get.ActionStatus lt viewstatus>
		 <input type="button" name="save" id="save" class="button10g" value="#vSave#" style="width:120" onClick="updateTextArea();savechange();">
		 </cfif>
		 
		 </td>
		 </tr>
		 </table>
		</td>
	</tr>
	
	<tr class="hide" id="submit_reason">
		<td colspan="2" align="left" height="30">
		<table width="100%"><tr><td>
		 <td>
		 <input type="button" name="close" id="close" class="button10g" value="Back" style="width:120" onClick="cancelexecutionreq()">
		 <input type="button" name="save" id="save" class="button10g" value="Submit Cancellation" style="width:120" onClick="savereason()">
		 </td>
		</tr></table>
		</td>
	</tr>
	
	<tr><td height="5"></td></tr>
	
	<tr class="hide" id="execution_reason">
	<td colspan="2" align="left" height="30">
		<cfdiv bind="url:ExecutionRequestReason.cfm?row=1&id=#url.Id#&statusclass=execution&status=9">
	</td>
	</tr>	
						
	<cfquery name="PeriodList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	       SELECT R.*, M.MandateNo 
		   FROM   Ref_Period R, 
		          Organization.dbo.Ref_MissionPeriod M
		   WHERE  M.Mission = '#purchase.mission#' 
		   AND    R.Period = M.Period 
		   AND    R.IncludeListing = 1
	</cfquery>
	
	<tr><td width="20%" class="labelmedium"><cf_space spaces="45"><cf_tl id="Period">:</td>
	    <td height="25" width="80%">
		
			<table width="100%" cellspacing="0" cellpadding="0"><tr><td class="labelmedium">
		
		     <cfif acc eq "edit">
			 
			 <select name="period" id="period" class="regularxl">
			  	  <cfloop query="PeriodList">
				    	 <option value="#Period#" <cfif get.Period eq Period> SELECTED</cfif>>#Period#</option>
				  </cfloop>
		      </select>
			  
			  <cfelse>
			  
			  #Get.Period#
			  
			  </cfif>
			  
			  </td>
			  <td width="30"></td>
			  <td class="labelmedium"><cf_tl id="Unit">:</td>
			  <td height="20" class="labelmedium">
				
				<cfquery name="Unit" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				       SELECT * 
					   FROM   Organization
					   WHERE  OrgUnit = '#get.OrgUnit#' 		   
				    </cfquery>
					
					#unit.OrgUnitName#	
				
			  </td>
			  <td width="40"></td>
				
			  <td width="50%" align="right" class="labelmedium" height="20" id="Status" style="font-family: Calibri; font-size: xx-large;">
				<cfdiv bind="url:RequestEditStatus.cfm?id=#url.id#" id="reqstatus">
			  </td>
					  
			  </tr></table>
		
		</td>
	</tr>
	
	<tr><td width="200" class="labelmedium"><cf_tl id="Reference">:</td>
	
	    <td height="20" class="labelmedium">
		
		<cfif acc eq "edit">
		
			<table cellspacing="0" cellpadding="0">
		    <tr><td>
			
				<cfif Parameter.ExecutionRequestReferenceCheck eq "1">
				    <cfset sc = "ColdFusion.navigate('RequestReferenceCheck.cfm?reference='+this.value+'&executionId=#url.id#','refcheck')">				
				<cfelse>		
				    <cfset sc = "">					
				</cfif>		
					
				<cfinput type="Text"
			       name="Reference"
			       required="No"
			       visible="Yes"		   
			       enabled="Yes"  
				   value="#get.reference#"   
			       size="20"
			       maxlength="20"
			       class="regularxl"
				   onchange="#sc#">		
				   </td>
				   
				   <td>&nbsp;</td>
				   <td id="refcheck"></td>
		     </tr>
			   
			   
			   </table>   
					   
		<cfelse>
		
			#Get.Reference#
		
		</cfif>	   
		</td>
	</tr>
	
	<tr><td class="labelmedium"><cf_tl id="Description">:</td>
	    <td height="20" class="labelmedium">
		
			<cfif get.actionStatus lt viewstatus>
			
				 <cfinput type="Text"
			       name="RequestDescription"
			       message="Please provide a description for your request"
			       validate="noblanks"
			       required="Yes"				   
				   value="#get.RequestDescription#"
			       visible="Yes"	  
			       enabled="Yes"     
			       size="80"
			       maxlength="80"
			       class="regularxl">
			   
			  <cfelse>
			
				#Get.RequestDescription#
			
			</cfif>	   	   
		   
	    </td>
	</tr>
	
	<tr><td></td><td>
	       <cfdiv bind="url:Details/DetailItem.cfm?access=#acc#" id="iservice"/>		
	</td></tr>
	
	<tr><td class="labelmedium"><cf_tl id="Amount">:</td>
		<td height="20" class="labelmedium">
		
		<cfif acc eq "edit">
				
			<cfinput type="Text"
		       name="RequestAmount"
		       message="Please provide an amount for your request"
		       validate="float"
		       required="Yes"
			   readonly
			   style="font:20px;height:27;text-align:right"
			   value="#numberformat(get.RequestAmount,'__,__.__')#"
		       visible="Yes"
		       enabled="Yes"   	  
		       size="15"
		       maxlength="20"
		       class="regularxl">
		   
		   <cfelse>
		
		    <font face="Calibri" size="3">
			#numberformat(get.RequestAmount,'__,__.__')#
			</font>
		
		</cfif>	   
		  	   
		</td>
	
	</tr>
	
	<cfif acc eq "View">
	
	<tr><td width="150" class="labelmedium"><cf_tl id="Purchase Order">:</td>
	    <td id="line" height="20" style="padding-right:10px">	
		<cfdiv bind="url:RequestPurchaseItem.cfm?purchaseNo=#get.PurchaseNo#&executionid=#get.executionid#&access=#acc#">	
		</td>
	</tr>
	
	<cfelse>
	
		<tr><td width="150" class="labelmedium"><cf_tl id="Project">:</td>
		    <td>
			<table cellspacing="0" cellpadding="0" class="formpadding">
				<tr>
				<td>
				<cfquery name="Project" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					SELECT DISTINCT Pr.ProgramCode, Pr.ProgramName
					FROM         Purchase.dbo.Purchase P INNER JOIN
			                      Purchase.dbo.PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
			                      Purchase.dbo.RequisitionLineFunding F ON PL.RequisitionNo = F.RequisitionNo INNER JOIN
			                      Program Pr ON F.ProgramCode = Pr.ProgramCode
					WHERE P.Mission = '#Purchase.mission#'
					AND P.PurchaseNo IN (SELECT PurchaseNo  
					                     FROM Purchase.dbo.PurchaseExecution
										 WHERE PurchaseNo = P.PurchaseNo)	 
					
				</cfquery>
				
				<cfoutput>
				 <select name="programcode" id="programcode" class="regularxl">
				        <option value=""></option>
					    <cfloop query="Project">
						   	 <option value="#ProgramCode#" <cfif ProgramCode eq get.ProgramCode>selected</cfif>>#ProgramName#</option>
						</cfloop>
			      </select>
				</cfoutput>
				
				</td>
				
				<td>
					<cfdiv id="purchase" 
						bind="url:#SESSION.root#/procurement/application/PurchaseOrder/ExecutionRequest/RequestEntryPurchase.cfm?&executionid=#get.executionid#&access=#acc#&PurchaseNo=#get.purchaseNo#&ProgramCode={programcode}&mission=#purchase.mission#"/>
					
				</td>
				</tr>
			</table>	  
		
			</td>
		</tr>
		
		<tr><td id="line" colspan="2">		 
			<cfdiv bind="url:RequestPurchaseItem.cfm?purchaseNo=#get.PurchaseNo#&executionid=#get.executionid#&access=#acc#">	   
			<!--- select a lines which budget visible in screen --->
			</td>
		</tr>
	
	
	</cfif>
	
	<cfquery name="Group" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     Ref_EntityGroup
			WHERE EntityCode = 'ProcExecution'
			<!---
			AND (Owner is NULL or Owner = '#Observation.Owner#')
			--->
	</cfquery>
	
	<cfif group.recordcount gte "1">
	
	<tr><td height="20" class="labelmedium">Work group:</td>
	    <td>
		<cfif acc eq "edit">
		<select name="Workgroup" id="Workgroup" class="regularxl">
		    <cfloop query="group">
			   <option value="#EntityGroup#" <cfif entitygroup eq Object.EntityGroup>selected</cfif>>#EntityGroupName#</option>
			</cfloop>
		    </select>
		<cfelse>
		<cfif Object.EntityGroup eq "">Undefined<cfelse>#Object.EntityGroup#</cfif>
		</cfif>	
		</td>
	</tr>
	
	</cfif>
	
	<tr><td width="100" class="labelmedium" style="padding-right:80px">Attachments:</td>
	   <td width="70%" id="mod">
	
		<cf_filelibraryN
				DocumentPath  = "PurchaseExecution"
				SubDirectory  = "#requestid#" 
				Filter        = ""						
				LoadScript    = "1"		
				EmbedGraphic  = "no"
				Width         = "100%"
				Box           = "mod"
				Insert        = "yes"
				Remove        = "yes">	
	
	</td></tr>
	  
	<tr class="hide"><td id="postatus">
	
	  <cfset wflnk = "RequestEditWorkflow.cfm"> 
	  <input type="hidden" 
	     name="workflowlink_#url.id#" 
		 id="workflowlink_#url.id#"
	     value="#wflnk#"> 
		 
	   <input type="button" class="hide"
		       name   = "workflowlinkprocess_#url.id#" id="workflowlinkprocess_#url.id#"
		       onClick= "ColdFusion.navigate('RequestEditStatus.cfm?id=#url.id#','reqstatus')">
	</td>
	</tr>  
		 
	</cfoutput>	 
	
	<cfif acc eq "edit">
	   					   
			 <tr><td colspan="2"
			    id="outline"
			    style="padding-right:10px;border: 0px solid Silver;">		
			  							 
				  <cf_textarea name="Remarks"                 		           
				   height         = "150"			             		          			   
		   		   init	          = "Yes"      
		           toolbar        = "Basic"
				   color          = "ffffff">	
				   
				   <cfoutput>
				   #Get.Remarks#
				   </cfoutput>
				   
				  </cf_textarea>  
				  
			 </td></tr>		
			 
	<cfelse>
	
		<cfoutput query="get">
	
		 <cf_ProcessActionTopic name="Outline" 
		       title = "Remarks"
			   line  = "No"
			   click = "maximize('outline')">						   
			 <tr>
			 	 <td id="outline" colspan="2" width="98%" align="center" class="hide" style="border: 1px solid Silver;">		
				 #Remarks#
				</td>
			 </tr>
			 
		</cfoutput>	 
			 
	</cfif>		
	
	<tr>
		<td colspan="3" style="border: 0px solid Silver;">	
		<cfdiv id="#url.id#" bind="url:#wflnk#?ajaxid=#url.id#">
		</td>
	
	</tr>
	
	</table>
	
	</cfform>

</cf_divscroll>	

<cf_screenbottom layout="innerbox">

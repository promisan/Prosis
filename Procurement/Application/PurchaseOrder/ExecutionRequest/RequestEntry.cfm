
<cfparam name="url.header" default="1">

<cfif url.header eq "1">
	<cf_screentop height="98%" scroll="Yes" band="no" label="#Url.mission# Execution Request" layout="webapp" banner="gray" jquery="yes">
<cfelse>
    <cf_screentop height="98%" html="No" scroll="no" band="no"  label="#Url.mission# Execution Request" layout="webapp" banner="gray" jquery="yes">
</cfif>

<cfajaximport tags="cfwindow">

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
		[DetailRate] [float] NULL	,
		[DetailAmount] [float]  NULL	
	) ON [PRIMARY]
</cfquery>

<cfparam name="url.mission" default="">

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'
</cfquery>

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Usernames
	WHERE    Account = '#SESSION.acc#'	
</cfquery>

<cf_dialogOrganization>

<cfoutput>

	<script>
	
	function ReferenceCheck(rc,ob){    
		if (rc==1) {
			ref = ob.value; 
			ptoken.navigate('RequestReferenceCheck.cfm?Reference='+ref,'result');
		}
	}
	</script>

</cfoutput>

<cfform action="RequestEntrySubmit.cfm?header=#url.header#" name="requestform" style="height:100%" method="POST" target="result">

	<table width="91%" height="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr class="hide"><td id="process"></td></tr>
	
	<tr><td height="7"></td></tr>
	
	<cfoutput>
	
	<tr class="hide"><td colspan="2"><iframe name="result" id="result"></iframe></td></tr>
	
		  <cfquery name="Check" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		       SELECT * 
			   FROM   Ref_Period
			   WHERE  Period = '#url.Period#' 
			   AND    IncludeListing = 1
		    </cfquery>
				
			<cfquery name="PeriodList" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		       SELECT R.*, M.MandateNo 
			   FROM   Ref_Period R, 
			          Organization.dbo.Ref_MissionPeriod M
			   WHERE  M.Mission = '#url.mission#' 
			   AND    R.Period = M.Period 
			   AND    R.IncludeListing = 1
		    </cfquery>
	
	<tr><td height="20" class="labelmedium" width="150">Period:</td>
	    <td>
		
			 <select name="period" id="period" class="regularxl">
			  	  <cfloop query="PeriodList">
				    	 <option value="#Period#" <cfif url.Period eq Period> SELECTED</cfif>>#Period#</option>
				  </cfloop>
		      </select>
		
		</td>
	</tr>
	
	<tr><td class="labelmedium" width="150"><cf_tl id="Funding Unit">:</td>
	    <td>		
		
		      <table><tr><td>
			       
				 <cfinput type="text" name="orgunitname" id="orgunitname" message="No unit selected" required="Yes" class="regularxl" size="60" maxlength="80" readonly>					  
				 
				 </td>
				 
				 <td>
				   <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
				  onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="24" height="25" border="0" align="absmiddle" 
				  onClick="selectorgroleN('#url.mission#','',document.getElementById('period').value,'ProcReqEntry','orgunit','applyorgunit','','','disable')">
				  	     
	
				 <input type="hidden" name="orgunit"      id="orgunit"> 
				 <input type="hidden" name="mission"      id="mission"> 
				 <input type="hidden" name="orgunitcode"  id="orgunitcode">
			   	 <input type="hidden" name="orgunitclass" id="orgunitclass"> 
				 
				 </td></tr></table>
		
		</td>
	</tr>
	
	
	<tr><td width="150" class="labelmedium">Reference:</td>
	    <td>
		
		<cfinput type="Text"
	       name="Reference"
	       required="No"
	       visible="Yes"
	       enabled="Yes"     
	       size="20"
	       maxlength="20"
	       class="regularxl"
		   onchange="javascript:ReferenceCheck('#Parameter.ExecutionRequestReferenceCheck#',this)">
		   
		</td>
	</tr>
	
	<tr><td class="labelmedium">Description:</td>
	    <td>
		
		   <cfinput type="Text"
	       name="RequestDescription"
	       message="Please provide a description for your request"
	       validate="noblanks"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"     
	       size="80"
	       maxlength="80"
	       class="regularxl">
		   
	   </td>
	</tr>
	
	<tr><td></td><td id="iservice">
		<cfinclude template="Details/DetailItem.cfm">
	</td></tr>
	
	<tr><td class="labelmedium"><cf_tl id="Amount Requested"><cf_space spaces="40"></td>
		<td id="amount">
				
			<cfinput type="Text"
		       name="RequestAmount"
		       message="Please provide an amount for your request"
			   style="font:20px;height:27;text-align:right;background-color:f4f4f4"		   
			   readonly		       
		       visible="Yes"
		       enabled="Yes"     
		       size="20"
		       maxlength="20"
		       class="regularxl">
			   
		</td>
	
	</tr>
	
	<tr><td valign="top" style="padding-top:5px" class="labelmedium" width="150"><cf_tl id="Project/Purchase">:</td>
	    <td>
		<table cellspacing="0" cellpadding="0">
			<tr>
			<td width="10">
			
			<cfquery name="Project" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT DISTINCT Pr.ProgramCode, Pr.ProgramName
					FROM      Purchase.dbo.Purchase P INNER JOIN
			                  Purchase.dbo.PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
			                  Purchase.dbo.RequisitionLineFunding F ON PL.RequisitionNo = F.RequisitionNo INNER JOIN
			                  Program Pr ON F.ProgramCode = Pr.ProgramCode
					WHERE     P.Mission = '#url.mission#'
					AND       P.PurchaseNo IN (SELECT PurchaseNo
					                           FROM   Purchase.dbo.PurchaseExecution
											   WHERE  PurchaseNo = P.PurchaseNo)	 
				
			</cfquery>
			
			<cfoutput>
			 <select name="programcode" id="programcode" class="regularxl">
			        <option value=""></option>
				    <cfloop query="Project">
					   	 <option value="#ProgramCode#">#ProgramName#</option>
					</cfloop>
		      </select>
			</cfoutput>
			
			</td>
			
			<td style="padding-left:4px">
			
				<cfdiv id="purchase" 
					bind="url:#SESSION.root#/procurement/application/PurchaseOrder/ExecutionRequest/RequestEntryPurchase.cfm?ProgramCode={programcode}&mission=#url.mission#"/>
				
			</td>
			</tr>
			
			<tr><td colspan="2" id="line" width="900px" height="300px" class="hide">		    
				<!--- select a lines which budget visible in screen --->
				</td>
			</tr>
			
		</table>	  
	
		</td>
	</tr>
		
	
	
	
	<tr id="group"><td class="labelmedium"><cf_tl id="Authorization group">:</td>
	    <td>	
		<cfdiv bind="url:DocumentEntryGroup.cfm" id="workgrp"/>			
		</td>
	</tr>
	
	<tr><td class="labelmedium"><cf_tl id="Workflow">:</td>
	    <td>	
		<cfdiv bind="url:DocumentEntryClass.cfm" id="workcls"/>						
		</td>
	</tr>
	
	<cf_assignId>
	
	<cfoutput>
	<input type="hidden" name="RequestId" id="RequestId" value="#rowguid#">
	</cfoutput>
	
	<tr><td height="10" class="labelmedium">Attachments:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="75%" id="mod">
	
		<cf_filelibraryN
				DocumentPath  = "PurchaseExecution"
				SubDirectory  = "#rowguid#" 
				Filter        = ""						
				LoadScript    = "1"		
				EmbedGraphic  = "no"
				Width         = "100%"
				Box           = "mod"
				Insert        = "yes"
				Remove        = "yes">	
	
	</td></tr>
	
	
	<tr><td height="7"></td></tr>
	
	<tr><td colspan="2" style="border: 0px solid Silver;height:100%">
			
		<textarea name="Remarks" 
		    style="border-radius:2px;font-size:14px;padding:3px;width:100%;height:100%;border:1px solid silver"></textarea>			
		 
		</td>
	</tr>
	
	<tr><td colspan="2" height="30" align="center" id="save" style="padding-top:5px">
		<cfif url.header eq "1">
		<input type="button" name="close" id="close" style="width:180px" class="button10g" value="Close" onclick="window.close()">
		</cfif>
		<input type="submit" name="save" id="save" style="width:180px" class="button10g" value="Save">
	
	</td></tr>
	
	<tr><td height="7"></td></tr>
	
	</cfoutput>
	
	</table>

</cfform>

<cf_screenbottom layout="webapp">

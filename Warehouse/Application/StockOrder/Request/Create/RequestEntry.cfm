<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="url.mode"   default="regular">
<cfparam name="url.scope"  default="backoffice">

<cfajaximport tags="cfwindow,cfform">

<cf_PreventCache>

<cfoutput>

<script>

function submitaddrequest(mission, warehouse) {   
	try { ColdFusion.Window.destroy('dialogaddrequest',true)} catch(e){};
	ColdFusion.navigate('RequestEntryDetail.cfm?mode=submit&mission='+mission+'&warehouse='+warehouse,'main');
}

function addrequest(scope,mission,warehouse) {    
	try { ColdFusion.Window.destroy('dialogaddrequest',true)} catch(e){};
	ColdFusion.Window.create('dialogaddrequest', 'Add Line', '',{x:100,y:100,width:520,height:390,resizable:false,modal:true,center:true});
	ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequest.cfm?scope=' + scope + '&mission=' + mission + '&warehouse=' + warehouse,'dialogaddrequest');
}

function cartedit(cartid,qty,box) {	
   if (parseFloat(qty)) {
	    ColdFusion.navigate('#SESSION.root#/warehouse/portal/Requester/CartEdit.cfm?scope=#url.scope#&id='+cartid+'&quantity='+qty,box)
   } else  {
   	  alert("You entered an incorrect quantity ("+qty+")")
   }					
}

function cartpurge(id,box,lid) {
    ColdFusion.navigate('#SESSION.root#/warehouse/portal/Requester/CartPurge.cfm?mission=#url.mission#&scope=#url.scope#&id='+id+'&itemlocationid='+lid,box)				
}

function doit() {
	if (confirm("Do you want to submit this request ?")) {	
	    ColdFusion.navigate('RequestEntrySubmit.cfm?scope=#url.scope#&mission=#url.mission#','process','','','POST','cartcheckout')			
	}	return false	
}

</script>

</cfoutput>

<cf_screentop height="100" scroll="Yes" layout="webapp" line="no" systemmodule="Warehouse" functionclass="Window" functionName="Stockorder request"  banner="red" label="Submit Direct Request" jQuery="yes">

<cfparam name="whs" default="all">

<cfquery name="WarehouseSelect" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Warehouse
	WHERE    Mission = '#URL.Mission#'		
	
	<cfif whs eq "all">	
	AND      Distribution = 1 
	<cfelseif whs neq "">
	AND      Warehouse IN (#preservesinglequotes(whs)#)		
	<cfelse>
	AND      1 = 0						  
	</cfif>		
	
	ORDER BY WarehouseDefault DESC
</cfquery>

<cfif warehouseselect.recordcount eq "0">

	<table align="center">
		<tr><td align="center" class="labelit" style="height:40">Problem no facilities are recorded for this entity.</td></tr>
	</table>

<cfelse>

<!--- request form --->

	<cfform method="POST" name="cartcheckout" id="cartcheckout">
	
	<table width="95%" align="center" class="formpadding" cellspacing="0" cellpadding="0">
	
		<tr><td height="7"></td></tr>
	
	    <cfset whs = "all">
				
		<tr><td>
			<cfinclude template="RequestEntryForm.cfm">
		</td></tr>
			
		<cfparam name="url.warehouse" default="#warehouseselect.warehouse#">
	   	
		<cfoutput>
		
		<tr>
			<td style="padding-left:16px;height:21px" align="left" class="labelit">	
				 <a href="javascript:addrequest('#url.scope#','#url.mission#',document.getElementById('warehouse').value);">
					<font color="0080C0">[Record Items]</font>
				 </a>											 
			</td>
		</tr>
		
		</cfoutput>
						
		<tr><td style="padding-left:8px;padding-right:15px">   
														
			    <table width="98%"
				       border="0"
				       cellspacing="0"
				       cellpadding="0"
				       align="center"
				       bordercolor="C0C0C0">
				   
						<tr>
							<td id="main" style="padding-left:0px;border:0px dotted silver">					   																													
								<cfinclude template="RequestEntryDetail.cfm">										
							</td>
						</tr>	
						
						<tr><td height="3"></td></tr>
						
						<tr><td colspan="1" class="line"></td></tr>
				
				</table>											
								
			</td>
		</tr>	
				
		<tr><td align="center" height="30" style="padding-top:4px">
		
		  <table class="formpadding formspacing" cellspacing="0" cellpadding="0">
			  <tr><td>			 
			  <input type="button" name="Cancel" class="button10s" id="cancelbutton" style="width:140;height:25" value="Cancel" onclick="window.close()">
			  <!--- <cf_button type="button" name="Cancel" id="cancelbutton" value="Cancel" onclick="window.close()"> --->
			  </td>
			  <td>
			  <input type="button" name="Submit" class="button10s" id="submitbutton" style="width:140;height:25" value="Submit" onclick="doit()">			 
			  </td>
			  </tr>
		  </table>
		
		</td></tr>
	
	</table>
	
	</cfform>	
	
</cfif>	

<cf_screenbottom layout="webapp">
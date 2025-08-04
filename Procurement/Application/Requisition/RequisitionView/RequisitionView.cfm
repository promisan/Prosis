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

<cfparam name="url.mission"     default="">
<cfparam name="url.workorderid" default="">
<cfparam name="url.webapp" default="">

<cf_screenTop height="100%"              
			  html="No" 	
			  scroll="No"			  
			  title="#url.mission# - Requisition Manager"		
			  banner="red"
			  MenuAccess="Yes" validateSession="Yes"			 
			  border="0"
			  JQuery = "yes">			
			  			  
<!--- can be removed --->

<cfquery name="ResetTemp" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE RequisitionLine
	SET    RequestCurrency = '#APPLICATION.BaseCurrency#',
	       RequestCurrencyPrice = RequestCostPrice
	WHERE  RequestCurrency is NULL	   	
</cfquery>

<cfquery name="Period" 
	      datasource="AppsProgram" 
    	  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT  R.*, M.MandateNo 
	      FROM    Ref_Period R, 
		          Organization.dbo.Ref_MissionPeriod M
	      WHERE   IncludeListing = 1
		 
		  AND   (
		  
		  		<!--- meant for execution --->
		        M.EditionId != '' 
		  
		        OR   
		  
		  	    R.Period IN (SELECT Period as Period
		                        <!--- period is indeed used --->
		                       FROM   Purchase.dbo.RequisitionLine
							   UNION 
							    <!--- period is default --->
							   SELECT DefaultPeriod as Period
							   FROM   Purchase.dbo.Ref_ParameterMission 
							   WHERE  Mission = '#URL.Mission#' 
							   )
				)			   
							   
	      AND     M.Mission = '#URL.Mission#'
	      AND     R.Period = M.Period
      </cfquery>	  
	  
<cfif Period.recordcount eq "0">
	
	<table align="center" height="50">
		<tr><td><font face="Verdana" size="2" color="0080C0">No valid execution periods found for this <cfoutput>#url.mission#</cfoutput>. Please contact your administrator</font></td></tr>
	</table>	
	<cfabort>
  
</cfif>

<cfoutput>

<script language="JavaScript">
		
	function reloadTree() {		   
	    rle = document.getElementById("role").value	
		per  = treeview.PeriodSelect.value	
	    ColdFusion.navigate('RequisitionViewTree.cfm?role='+rle+'&Mission=#URL.Mission#&period='+per,'treebox');
	}
	
	function updatePeriod(per,mandate) {	
		
		window.treeview.PeriodSelect.value = per	
		
		if (mandate != window.treeview.MandateNo.value){
		   window.treeview.MandateNo.value = mandate	   
		   reloadForm()
		} else {   
		   window.treeview.MandateNo.value = mandate
		   reloadForm()
		}
	}
			
	function expandthis(box) {			   
		 bx = document.getElementById(box)		 
		 if (bx.className == "regular") {
		     bx.className = "hide"
		 } else { 
		     bx.className = "regular" 
		 }
		}
	
	function check() {
	 
	 if (window.event.keyCode == "13")
		{	document.getElementById("searchicon").click() }
					
	   }

	function find(val) {	
		ColdFusion.navigate('RequisitionViewTreeBuyerFind.cfm?mission=#url.mission#&val='+val,'findme')	
	}			

   </script>	
   			
<cf_DialogProcurement>	

<cf_LayoutScript>
<cfajaximport tags="cftree,cfform">	
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
		
	<cfif url.webapp eq "">
	
	     <!--- only for backoffice --->
	  
		<cf_layoutarea 
		   	position  = "header"
		   	name      = "reqtop"
		   	minsize	  = "50px"
			maxsize	  = "50px"
			size 	  = "50px">	

			  	<cf_tl id="Procurement Requests" var="1">		
				<cf_ViewTopMenu label="#url.mission# - #lt_text#" bannerforce="Yes" background="gray">
								 			  
		</cf_layoutarea>	
		
	<cfelse>	
		
		<cf_layoutarea 
		   	position  = "header"
		   	name      = "reqtop"
		   	minsize	  = "18px"
			maxsize	  = "18px"
			size 	  = "18px">	
			
			<table width="100%" height="100%" bgcolor="FF8000"><tr><td width="100%" height="100%" style="height:7px;font-size:1px" bgcolor="FF8000">&nbsp;</td></tr></table>
			
		</cf_layoutarea>	
					
	</cfif>
	  
	<cf_layoutarea 
	    position    = "left" 
		name        = "treebox" 
		maxsize     = "300" 		
		size        = "300" 
		minsize     = "300"
		collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll">
				   
			<table width="100%" height="100%">
			
				<tr class="line"><td style="height:40px;padding-left:5px;padding-right:5px">							
					<cfinclude template="RequisitionRole.cfm">				
					</td>
				</tr>
						
				<tr><td valign="top" align="center" height="100%"> 	
				<cf_divscroll id="treeboxcontent">						
				    <cfinclude template="RequisitionViewTree.cfm">				
				</cf_divscroll>
				</td>
				</tr>
			
			</table>
						
				
	</cf_layoutarea>
	
	<cf_layoutarea position="center" name="box">
				
		<cfif url.WorkOrderId neq "">	
		
			<cfparam name="url.mid" default="">
			
					
			<iframe name="right"
		        id="right"
		        width="100%"
		        height="100%"				
				scrolling="no"
		        frameborder="0" 
				src="#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewView.cfm?Mission=#url.mission#&ID=LOC&ID1=Locate&workOrderId=#URL.WorkOrderId#&doFilter=1&mid=#url.mid#"></iframe>		
		
		<cfelseif url.webapp eq "">	
		
			<iframe name="right"
		        id="right"
		        width="100%"
		        height="100%"				
				scrolling="no"
		        frameborder="0" 
				src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"></iframe>
				
		 <cfelse>		
		
			<iframe name="right"
		        id="right"
		        width="100%"
		        height="100%"				
				scrolling="no"
		        frameborder="0"></iframe>
						
		</cfif>		
					
	</cf_layoutarea>			
		
</cf_layout>

<cf_screenbottom html="No" layout="Innerbox">

</cfoutput>


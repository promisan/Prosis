<!--
    Copyright © 2025 Promisan B.V.

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
<cfoutput>

<cf_DialogProcurement>
<cf_DialogLedger>
<cf_DialogREMprogram>

<script language="JavaScript">

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	 		 	
	 if (fld != false){			 
		 itm.className = "highLight3";				 
	 }else{			 
	     itm.className = "header";		
	 }
  }
  
function facttablexls1(controlid,format,filter,qry,dsn) {			
	w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 110;	
    window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?data=1&dsn="+dsn+"&controlid="+controlid+"&"+qry+"&filter="+filter+"&format="+format+"&ts="+new Date().getTime(), "facttable", "unadorned:yes; edge:raised; status:no; dialogHeight: "+h+" px; dialogWidth:"+w+" px; help:no; scroll:no; center:yes; resizable:no");
}  
  
function object(prg,mis,period,cls,hier,edt,fund) {
			
	icM  = document.getElementById(prg+"_"+edt+"_"+fund+"Min")
    icE  = document.getElementById(prg+"_"+edt+"_"+fund+"Exp")
	se   = document.getElementById("d"+prg+"_"+edt+"_"+fund);				
	
	if (se.className == "hide") {
	    se.className = "regular"
		icM.className = "regular"
		icE.className = "hide"
		ColdFusion.navigate('RequisitionEntryFundingSelectObject.cfm?isparent=1&ItemMaster=#URL.ItemMaster#&id=#url.id#&programcode='+prg+'&programclass='+cls+'&mission=#URL.mission#&programhierarchy='+hier+'&period='+period+'&edition='+edt+'&fund='+fund,'i'+prg+'_'+edt+'_'+fund)	
	} else {
	    se.className = "hide"
		icE.className = "regular"
		icM.className = "hide"	
	}		 		 		
}  

function amore(tpc,box,ed,fund,reqno,period,prg,obj,act,mode,mis,hier,org,resource) {
	    se   = document.getElementById(tpc+box);	
        if (se.className == "regular") {
		    se.className = "hide"
		} else {		    
	        se.className = "regular";
	        ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryDetail.cfm?unithierarchy='+org+'&programhierarchy='+hier+'&isParent=1&resource='+resource+'&ProgramCode='+prg+'&Period='+period+'&Edition='+ed+'&Fund='+fund+'&Object='+obj+'&mode=fund','a'+tpc+box)
		}
}	  
  
function bmore(tpc,box,fund,reqno,period,prg,obj,act,mode,mis,hier,org,edt,resource) {	
        		
		se   = document.getElementById(tpc+box);			 		 
		if (se.className == "hide") {	      	
			se.className  = "regular";		
			ptoken.navigate('../Requisition/RequisitionEntryFundingListing.cfm?mission=#URL.mission#&box='+box+'&reqno='+reqno+'&fund='+fund+'&period='+period+'&programcode='+prg+'&objectcode='+obj+'&isParent=1&resource='+resource+'&mode=fund&unithierarchy='+org+'&programhierarchy='+hier,'i'+tpc+box)	 
		} else {	         	
	        se.className  = "hide"	 		
		}		 		
	}
	
function imore(tpc,box,fund,reqno,period,prg,obj,act,mode,mis,hier,org,edt,resource) {			
       
		se   = document.getElementById(tpc+box);			 		 
		if (se.className == "hide") {	      	
			se.className  = "regular";		
			ptoken.navigate('../Requisition/RequisitionEntryFundingInvoice.cfm?mission=#URL.mission#&box='+box+'&reqno='+reqno+'&fund='+fund+'&period='+period+'&programcode='+prg+'&objectcode='+obj+'&isParent=1&resource='+resource+'&mode=fund&unithierarchy='+org+'&programhierarchy='+hier,'i'+tpc+box)	 
		} else {	         	
	        se.className  = "hide"	 		
		}		 		
	}	
 
</script>

</cfoutput>

<cfquery name="Period" 
     datasource="AppsProgram" 
  	  username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM   Ref_Period 
     WHERE  Period  = '#url.period#'    
</cfquery>	

<cfquery name="Base" 
     datasource="AppsProgram" 
  	  username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM   Organization.dbo.Ref_MissionPeriod M
     WHERE  M.Mission = '#URL.Mission#'
	 AND    M.Period  = '#url.period#'    
</cfquery>	

<!--- select only execution periods for this entity 
   if that period is in the same mandate as otherwise the unit will not match --->

<cfquery name="PeriodList" 
     datasource="AppsProgram" 
  	  username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT R.*, M.MandateNo 
     FROM   Ref_Period R, 
            Organization.dbo.Ref_MissionPeriod M
     WHERE  IncludeListing = 1  	   
     AND    M.Mission   = '#URL.Mission#'
	 AND    M.MandateNo = '#Base.Mandateno#'
     AND    R.Period    = M.Period
	 
	  <!--- limit to periods that have indeed budget entries for the planning period of the requisition --->
	 	 
	 AND    (
	 			R.Period IN (SELECT E.Period
	                     FROM   ProgramAllotmentDetail D, 
						        Ref_AllotmentEdition E
						 WHERE  D.EditionId = E.EditionId 
						 AND    E.Mission   = '#URL.Mission#'
	                     AND    E.Period    = R.Period
						 AND    D.Period    = '#url.period#')
						 
			OR
			
			R.Period = '#url.period#'
			
			)		
			
	 <!--- limit to execution periods that have an overlap with the base period --->
				 	 
	 AND    R.Period IN (SELECT Period 
	                     FROM   Ref_Period 
					     WHERE  DateEffective >= '#Period.DateEffective#' 
						 AND    DateEffective <= '#Period.DateExpiration#') 
	 
</cfquery>	


<cfif PeriodList.recordcount gte "2">
	
	<cfsavecontent variable="option">
	
	<table>
	<tr class="labelmedium">
	   <td width="140" style="padding-left:10px"><cf_tl id="Edition Period">:</td>
	   
	   <td>
	   
	     <table>
			<tr class="labelmedium">
			
			<cfoutput><input type="hidden" name="periodsel" id="periodsel" value="#url.period#"></cfoutput>
			
		    <cfoutput query="PeriodList">
			  <td style="padding-left:5px">
				  <input type="radio" class="radiol"
				    onclick="Prosis.busy('yes');document.getElementById('periodsel').value='#period#';ColdFusion.navigate('RequisitionEntryFundingSelectBase.cfm?period='+this.value+'&mission=#url.mission#&id=#url.id#&itemmaster=#url.itemmaster#&org=#url.org#','budget')" 
					name="Period" 
					id="box#Period#"
					value="#Period#" <cfif url.period eq period>checked</cfif>>		
			  </td>
			  <td style="padding-left:5px;cursor:pointer;padding-right:10px"  
			      onclick="document.getElementById('box#Period#').click()"><b>#Description# (#Period#)</td>
			</cfoutput>  		
			
			</tr>
			
		</table>
	   
	   </td>
	</tr>
	</table>
	
	</cfsavecontent>
	
	 <!--- blur="Yes" --->
	
	<cf_screentop height="100%" 
          html="Yes" 
		  band="No"
		  layout="webapp"		
		  option="#option#"
		  banner="yellow"	 
		  jquery="Yes"	 		  
		  label="#URL.Mission#" 
		  scroll="yes">
	
<cfelse>	

	 <!--- blur="Yes" --->
	
	<cf_screentop height="100%" 
          html="Yes" 
		  band="No"
		  layout="webapp"							 
		  banner="yellow"		
		  jquery="Yes"			 
		  label="#URL.Mission#" 
		  scroll="yes">

</cfif>
			  
<cfset spc = 22>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#URL.Mission#'
</cfquery>			  
		 
	<cfoutput>
	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr>
	<td style="padding-top:21px;padding-right:21px;padding-bottom:12px;padding-left:15px" height="100%" width="100%">
				
		<form target="result" style="height:100%;padding-left:8px" 
	     action="RequisitionEntryFundingSelectSubmit.cfm?ID=#URL.ID#" method="POST" name="fund" id="fund">
		  
			<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			
			<tr height="20" class="line labelmedium">	
			
				<td width="100%" style="font-size:11px;padding-left:5px;height:35;font-size:22" class="labellarge"><cf_space spaces="127"><cf_tl id="Select Funding"></td>
				<td style="font-size:11px;padding-right:1px;border-left: 1px solid Gray;" align="center"><cf_space spaces="#spc#"><cf_tl id="Required"><br>a1</td>
				<td style="font-size:11px;padding-right:1px;border-left: 1px solid Gray;" align="center"><cf_space spaces="#spc#"><cf_tl id="Budget"><br>a2</td>
				<td style="font-size:11px;padding-right:1px;border-left: 1px solid Gray;" align="center"><cf_space spaces="#spc#"><cf_tl id="Approved"><br>b1</td>
				<td style="font-size:11px;padding-right:1px;border-left: 1px solid Gray;" align="center"><cf_space spaces="#spc#"><cf_tl id="Procurement"><br>b2</td>
				<td style="font-size:11px;padding-right:1px;border-left: 1px solid Gray;" align="center"><cf_space spaces="#spc#"><cf_tl id="Obligated"><br>c</td>
				<cfif Parameter.FundingCheckCleared eq "0">
					<td style="font-size:11px;padding-right:1px;border-left: 1px solid Gray;" align="center"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a1-b12c</td>		
				<cfelse>
					<td style="font-size:11px;padding-right:1px;border-left: 1px solid Gray;" align="center"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a2-b12c</td>
				</cfif>	
				<td style="font-size:11px;padding-right:1px;border-left: 1px solid Gray;" align="center"><cf_space spaces="#spc#"><cf_tl id="Disbursed"><br>d</td>				
				<td style="padding-right:1px;border-left: 1px solid Gray;min-width:26px"></td>
			</tr>	
				
			<tr>
				<td colspan="9" width="100%" height="100%" valign="top">
								
				<script>
						Prosis.busy('yes');
				</script>
					
				<cf_divscroll style="width:100%;height:100%;border:0px solid silver;">
				
				<cfdiv id="budget" 
					style="width:100%;height:100%;overflow-y: scroll; position:relative; scrollbar-face-color: white; scrollbar-track-color: fafafa; scrollbar-arrow-color: eaeaea;"
					bind="url:RequisitionEntryFundingSelectBase.cfm?period=#url.period#&mission=#url.mission#&id=#url.id#&itemmaster=#url.itemmaster#&org=#url.org#"/>	 
				
				</cf_divscroll>
					
				</td>
			</tr>
			
			<cf_tl id="Apply" var="1">
			<cfset vSelect=#lt_text#>
			
			<cf_tl id="Close" var="1">
			<cfset vClose=#lt_text#>
			
			<tr><td height="20" colspan="9" align="center" class="line" style="padding-top:4px">
				
					<table class="formpadding">
					<tr>
		
					<cfoutput>
						<td><input class="button10g" style="width:140px;height:25px" type="button" id="Close"  value="#vClose#" onclick="window.close()"></td>
						<td style="padding-left:2px"><input class="button10g" style="width:140px;height:25px" type="submit" id="Submit" value="#vSelect#"></td>
					</cfoutput>
					
					</tr></table>
					
				</td></tr>
			
			</table>
			
		</form>
	
	</td></tr></table>

	</cfoutput>

<cf_screenbottom layout="webapp">

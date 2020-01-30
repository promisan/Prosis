<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<head></head>

<cfoutput>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<!--- End Prosis template framework --->

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<cf_dialogProcurement>
<cf_dialogLookup>
<cf_DialogMaterial>
<cf_DialogREMProgram>
<cf_DialogStaffing>
<cf_menuScript>
<cf_AnnotationScript>
<cfajaximport tags="cfform,cfdiv,cfwindow">

<cf_dialogPosition>
	
	
<cf_tl id="Do you want" var="1">
<cfset dyw=#lt_text#>

<cf_tl id="selected requisition lines" var="1">
<cfset srl=#lt_text#>	

<cf_tl id="process" var="1">
<cfset vprocess =#lt_text#>

<cf_tl id="assign" var="1">
<cfset vassign =#lt_text#>


<cf_tl id="Please select" var="1">
<cfset vselect =#lt_text#>

<script language="JavaScript">

function facttablexls1(control,format,box) {  
    // here I could capture the client variable if this is better for large selections 	
	ColdFusion.navigate('RequisitionViewSelected.cfm','process','','','POST','buyer')	
  	w = #CLIENT.width# - 80;
    h = #CLIENT.height# - 110;		
	window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?ts="+new Date().getTime()+"&box="+box+"&data=1&controlid="+control+"&format="+format, "facttable", "unadorned:yes; edge:raised; status:yes; dialogHeight:"+h+"px; dialogWidth:"+w+"px; help:no; scroll:no; center:yes; resizable:yes");
}	

// function AddVacancy(pos,req) {
// 	 ret = window.showModalDialog("#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?Mission=#URL.Mission#&ID1=" + pos + "&box=" + req + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:640px; dialogWidth:700px; help:no; scroll:yes; center:yes; resizable:yes");
//	 ColdFusion.navigate('../Position/PositionFunding.cfm?reqid='+req,'pos'+req)			 		   			 	 	
// }

function mail2(mode,id) {
	  window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	

	ie = document.all?1:0
	ns4 = document.layers?1:0
	

function togglesel() {
	
	if 	(document.getElementById("selectall").value == "Invert") {
		document.getElementById("selectall").value = "Select All" } else {
		document.getElementById("selectall").value = "Invert"
		}	   
		
	se = document.getElementsByName("RequisitionNo")
	cnt = 0;	
	while (se[cnt]) {
		se[cnt].click();
		cnt++
	}	
			
}	

function hl(itm,fld,no){

	ln1 = document.getElementById(no+"_1")
	ln2 = document.getElementById(no+"_2")
	ln3 = document.getElementById(no+"_3")
   	    	 	 		 	
	 if (fld != false){
	 		
	 ln1.className = "highLight2";
	 ln2.className = "highLight2";
	 ln3.className = "highLight2";
	 
	 }else{
		
	 ln1.className = "regular";	
     ln2.className = "regular";		
	 ln3.className = "regular";
	 
	 }
  }

function processdata(txt,per) {

    se = document.getElementById('userid')
    if (se.value == "0") { 
		alert("#vselect# #Parameter.BuyerDescription#") 		
		buyerselect.click() 

	} else {
		
		
		if (txt == 'process')
		{	
			txt = '#vprocess#'
		}

		if (txt == 'assign')
		{
			txt = '#vassign#'
		}		
				
		if (confirm("#dyw# "+txt+" #srl# ?"))	{
		    Prosis.busy('yes')
			ColdFusion.navigate('RequisitionBuyerSubmit.cfm?mode=process&mission=#URL.Mission#&period='+per,'box','','','POST','buyer')
		}
				
	}
	
}

function search(itm) {
	 if (window.event.keyCode == "13") {	
    	reqsearch()	
		try {
		document.getElementById(itm).onkeyup=new Function("return false")  } catch(e) {} 		
     } 	
}
 
function reqsearch() {
   buy   = document.getElementById("userid").value
   pag   = document.getElementById('page').value
   per   = document.getElementById('periodsel').value       
   unit  = document.getElementById('pending_unit').value
   val   = document.getElementById('pending_search').value
   ann   = document.getElementById('annotationsel').value	
   fun   = document.getElementById('fundsel').value	   
   fund  = document.getElementById('fundcode').value	
  
   ColdFusion.navigate('RequisitionBuyerPending.cfm?page='+pag+'&annotationid='+ann+'&buyer='+buy+'&mission=#url.mission#&period='+per+'&search='+val+'&unit='+unit+'&fun='+fun+'&fund='+fund,'contentbox1')
}  

</script>
	
<cfquery name="PeriodList" 
     datasource="AppsProgram" 
  	  username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT R.*, M.MandateNo 
     FROM   Ref_Period R, 
            Organization.dbo.Ref_MissionPeriod M
     WHERE  IncludeListing = 1
     AND    R.Period IN (SELECT Period as Period
                          FROM Purchase.dbo.RequisitionLine
					      WHERE Mission = '#URL.Mission#'
					      UNION 
					      SELECT DefaultPeriod as Period
					      FROM Purchase.dbo.Ref_ParameterMission 
					      WHERE Mission = '#URL.Mission#'
					     )					   
     AND    M.Mission = '#URL.Mission#'
     AND    R.Period = M.Period
</cfquery>	

<cfsavecontent variable="option">

<table class="formpadding">

<tr>
   <td class="labelit" style="padding-top:1px;padding-right:5px"><cf_tl id="REQ004">:</td>
   <td align="right" style="padding-top:2px">
   
     <table cellspacing="0" cellpadding="0">
		<tr>
		<cfoutput>
		<input type="hidden" name="periodsel" id="periodsel" value="#url.period#">
		</cfoutput>
		
	    <cfloop query="PeriodList">
		  <td>
		  <input type="radio" 
		    onclick="document.getElementById('periodsel').value='#period#';ColdFusion.navigate('RequisitionBuyerPrepare.cfm?period='+this.value+'&mission=#url.mission#','box')" 
			name="Period" 
			id="box#Period#"
			value="#Period#" <cfif url.period eq period>checked</cfif>>		
		  </td>
		  <td style="cursor: pointer;padding-left:4px;padding-right:5px" class="labelit" 
		      onclick="document.getElementById('box#Period#').click()">#Period#</td>
		</cfloop>  
		
		<td class="hide">
		
		   <input type="button" 
			   id="refreshbutton" 	  	  
			   name="refreshbutton"
			   onclick="reqsearch()">
		 
	      </td>
		
		</tr>
		
	</table>
   
   </td>
</tr></table>

</cfsavecontent>

</cfoutput>

<cf_screentop jQuery="Yes" height="100%" layout="webapp" banner="gray" option="#option#" label="Requisition Assignment" band="no" scroll="yes">

<table width="99%" height="99%" border="0" align="center">

<tr><td height="3"></td></tr>

<tr><td colspan="2" height="100%" valign="top">
    <cf_divscroll style="height:100%"id="box">
    <cfset url.process = "checkbox">
    <cfinclude template="RequisitionBuyerPrepare.cfm">	
	</cf_divscroll>
</td></tr>

</table>

<cf_screenbottom layout="innerbox">

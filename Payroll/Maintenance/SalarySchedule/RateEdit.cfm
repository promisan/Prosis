
<cfwindow 
   name        = "dialog"
   title       = "Detail Table"
   height      = "430"
   width       = "350"   
   minheight   = "250"
   minwidth    = "350"
   center      = "True"
   modal       = "True"/>
   
<cf_screentop html="No" scroll="Yes" jQuery="Yes">

<cf_calendarScript>
<cfajaximport tags="cfform">

<cfparam name="URL.Schedule"   default="SALARYICTY">
<cfparam name="URL.Mission"    default="Promisan">
<cfparam name="URL.Location"   default="R001">
<cfparam name="URL.Operational"   default="1">
<cfparam name="URL.Effective"  default="">  <!--- SQL format --->
     
<cfoutput>

<script language="JavaScript">

function populateall(cp,cp2) {	
    e= document.getElementById(cp)
	value=e.value;	
	$( ".amount2" ).each(function( index ) {
  		if ($(this).val()==0 && $(this).attr('id').search(cp2)!=-1)
	  	  	  $(this).val(value);			  
	});		
}

function deleteall(cp,cp2) {
	$( ".amount2" ).each(function( index ) {
  		if ($(this).val()!=0 && $(this).attr('id').search(cp2)!=-1)
	  	  	  $(this).val(0.00);			  
	});   
}

function maximize(itm){	
	
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 se   = document.getElementsByName(itm)	 
	 cnt  = 0	 	
	
	 if (icE.className == "regular") {
	     while (se[cnt]) {		
		 se[cnt].className = "regular";
		 cnt++
		 }
		 icM.className = "regular";
		 icE.className = "hide";
	 } else {
		 while (se[cnt]) {		 		
		 se[cnt].className = "hide";
		 cnt++
		 }
		 icM.className = "hide";
		 icE.className = "regular";			
	 }
  }  
  
function showdetails(sn,cn,pt,mode) {
	
	if (mode != "Default" && mode != "Hour") {	
	    ColdFusion.Window.show('dialog')		
	    _cf_loadingtexthtml='';		
	    ptoken.navigate('DetailTable.cfm?sn='+sn+'&cn='+cn+'&ep='+pt+'&detailmode='+mode,'dialog') 	
	    document.getElementById('percent_'+cn).className = "hide"				
	  } else {
	    document.getElementById('percent_'+cn).className = "regular"	
	  }	  
}  

function deletedt(sn,cn,pt,dv,mde) {
 	  ptoken.navigate('DetailTable.cfm?op=del&sn='+sn+'&cn='+cn+'&ep='+pt+'&dv='+dv+'&detailmode='+mde,'dialog') 									
}  

function saveamount(act,sn,cn,pt,mde,elo,eld,plo,pld) {
	  dv     = document.getElementById(elo).value;
	  dv2    = document.getElementById(eld).value;	
	  per    = document.getElementById(plo).value;
	  per2   = document.getElementById(pld).value;	 
	  ptoken.navigate('DetailTable.cfm?op='+act+'&sn='+sn+'&cn='+cn+'&ep='+pt+'&dv='+dv+'&dv2='+dv2+'&per='+per+'&per2='+per2+'&detailmode='+mde,'dialog') 									
} 

function savemonth(sn,cn,pt,mde) {          
      ptoken.navigate('DetailTable.cfm?op=save&sn='+sn+'&cn='+cn+'&ep='+pt+'&detailmode='+mde,'dialog','','','POST','formmonth')
      alert("Saved.")	
}

function hidedialog() {
      ColdFusion.Window.hide('dialog')	
}

function purge(){
	  var r=confirm("Are you sure you want to delete fully this scale ?");
	  if (r==true) {
		  ColdFusion.navigate("RatePurgeSubmit.cfm?Schedule=#URL.Schedule#&Mission=#URL.Mission#&Location=#URL.Location#&Effective=#URL.Effective#",'dialog','','','POST','rateform')
	  }
}

function scaleactivate(id,val){

	  var r=confirm("Are you sure you want to change the operational status of this scale ?");	 
	  if (r==true) {
		  ColdFusion.navigate('RateActivateSubmit.cfm?idmenu=#url.idmenu#&ScaleNo='+id+'&operational='+val,'activatebox')
	  }
}

function addnew(sn,cn,pt,mde) {
      ptoken.navigate('DetailTable.cfm?op=newd&sn='+sn+'&cn='+cn+'&ep='+pt+'&detailmode='+mde,'dialog') 	
}

function savescale() {
   	  _cf_loadingtexthtml='';	
	  Prosis.busy('yes')
	  ptoken.navigate('RateEditSubmit.cfm?Schedule=#URL.Schedule#&Mission=#URL.Mission#&Location=#URL.Location#&Effective=#URL.Effective#&mode=#url.mode#&operational=#url.operational#','cprint','','','POST','rateform')
 }
  
</script> 

</cfoutput>

<cfquery name="Schedule"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   SalarySchedule
	WHERE  SalarySchedule = '#URL.Schedule#'
</cfquery>

<cfquery name="Mission"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   SalaryScheduleMission
	WHERE  SalarySchedule = '#URL.Schedule#'
	AND    Mission        = '#URL.Mission#'
</cfquery>

<cfquery name="Scale"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     SalaryScale
	WHERE    SalarySchedule  = '#URL.Schedule#'
	   AND   Mission         = '#URL.Mission#'
	   AND   ServiceLocation = '#URL.Location#'
	   AND   Operational     = '#URL.Operational#'
	   <cfif URL.Effective eq "">
	   AND   SalaryEffective = (SELECT Max(SalaryEffective) as SalaryEffective
							    FROM   SalaryScale
							    WHERE  SalarySchedule  = '#URL.Schedule#'
								AND    Mission         = '#URL.Mission#'
								AND    ServiceLocation = '#URL.Location#'
								AND    Operational = 1)
	   <cfelse>
	   AND   SalaryEffective = '#URL.Effective#'
	   </cfif>							
</cfquery>




<!--- we check if the scale has component defined --->

<cfinvoke component = "Service.Process.Payroll.Scale"  
   method           = "setScaleComponent" 
   ScaleNo          = "#Scale.ScaleNo#" 
   Force            = "No">	  

<cfquery name="Location"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PayrollLocation
	WHERE LocationCode = '#URL.Location#'
</cfquery>

<cfquery name="Currency"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Currency
</cfquery>

<table align="center" border="0">
	<tr class="xhide"><td id="cprint"></td></tr>
</table>

<table width="100%" height="100%" align="center" >

	<cfif url.schedule neq "">
	
	<tr><td colspan="2" valign="top" height="100%" style="width:100%;border-left:1px solid silver">
	  
		<cfform name="rateform" 
		   style="height:100%;width:100%" 
		   onsubmit="return false">
			
		<cfoutput>
		
			<table width="100%" height="100%" border="0">
			
			<cfset jvlink = "ColdFusion.Window.create('addscale', 'Add Scale', '',{x:100,y:100,height:325,width:400,resizable:false,modal:true,center:true});ColdFusion.navigate('#SESSION.root#/payroll/maintenance/SalarySchedule/RateAdd.cfm?scaleno=#scale.scaleno#','addscale')">		
									
			<tr class="labelmedium line" id="header" style="background-color:<cfif scale.operational eq '1'>eaeaea<cfelse>FF8080</cfif>;height:25px">
			  <td style="padding-left:10px;"><cf_tl id="Entity">:</td> 
			  <td style="font-size:14px">#URL.Mission#</b></td>
			  <td><cf_tl id="Schedule">:</td>
			  <td style="font-size:14px">#Schedule.SalarySchedule# (#Scale.ScaleNo#)</b></td>			 
			  <td><cf_tl id="Location">:</td>  
			  <td style="font-size:14px">#URL.Location# [#Location.LocationCountry# - #Location.Description#]</b></td>
			</tr>	
				
			<tr class="labelmedium line" style="background-color:eaeaea;height:35px">
			 
			    <td height="20" style="padding-left:10px" class="labelmedium"><cf_tl id="Currency">:</td>
			    <td class="labelmedium">
			  
			  	<select name="Currency" class="regularxl">
				  <cfloop query="Currency">
				  <option value="#Currency#"<cfif Currency eq Schedule.PaymentCurrency>selected</cfif>>#Currency#</option>
				  </cfloop>
				</select>
				
			    </td>
			 
			    <td class="labelmedium"><cf_tl id="Effective">:</td>
			    <td>
				 
					<table cellspacing="0" cellpadding="0">
					<tr>
					<td class="labelmedium">
					
						<cfif Scale.SalaryEffective eq "">			
						
							<cf_intelliCalendarDate9
								FieldName="SalaryEffective" 
								Default="#Dateformat(Scale.SalaryEffective, CLIENT.DateFormatShow)#"
								class="regularxl"
								AllowBlank="False">
						
										
						<cfelse>
								
							<input type="hidden" name="SalaryEffective" value="#Dateformat(Scale.SalaryEffective, CLIENT.DateFormatShow)#">
							#Dateformat(Scale.SalaryEffective, CLIENT.DateFormatShow)#
						
						</cfif>	
							
					</td>
						
					<cfquery name="Check"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  DISTINCT SalaryEffective
						FROM    SalaryScale
						WHERE   SalarySchedule   = '#URL.Schedule#'
						   AND  Mission          = '#URL.Mission#'  
						   AND  ServiceLocation  = '#URL.Location#'
						   AND  Operational = 1	  
					</cfquery>
					
					<cfif check.recordcount gt "1">
					   <td style="padding-left:2px">					   
					   	<input type="button"  onclick="purge()" class="button10g" style="height:23;width:80" name="Purge" value="Delete">
					   </td>	
					</cfif>	
										
					<cfif Scale.operational eq "0">
					 <td style="padding-left:2px" id="activatebox">					   
					   	<input type="button"  onclick="javascript:scaleactivate('#scale.scaleno#','1')" class="button10g" style="height:23;width:80" name="Do" value="Activate">
					   </td>	
					<cfelse>
					 <td style="padding-left:2px" id="activatebox">					   
					   	<input type="button"  onclick="javascript:scaleactivate('#scale.scaleno#','0')" class="button10g" style="height:23;width:80" name="Do" value="Deactivate">
					   </td>	
					</cfif>     
					
					</tr>
					</table>
				
				</td>
			    <td class="labelmedium"><cf_tl id="First applied">:</td>
			    <td> 
					
					<cf_intelliCalendarDate9
						FieldName="SalaryFirstApplied" 
						Default="#Dateformat(Scale.SalaryFirstApplied, CLIENT.DateFormatShow)#"
						class="regularxl"
						AllowBlank="False">					
					
				</td>
			</tr>
			
			</cfoutput>
			
			<input type="hidden" name="ScaleNo" id="ScaleNo" value="<cfoutput>#Scale.ScaleNo#</cfoutput>">
				
			<tr style="height:100%;width:100%">
			
			<td colspan="6" valign="top" style="width:100%;border:0px solid silver;padding-top:5px;height:100%;padding-bottom:5px">
											
				<cfif url.mode eq "Percentage">
				
					<cf_divscroll overflowx="auto" style="width:100%">	
				
						<table width="100%">
															
						<tr id="percent" name="percent" class="regular" style="padding-left:30px">
						     <td><cfinclude template="RateEditPercentage.cfm"></td>
						</tr>	
						
						</table>	
						
					</cf_divscroll>	
					
				<cfelseif url.mode eq "Rate">
				
					<cf_divscroll overflowx="auto" style="height:99%;width:100%">	
					
					<table width="100%">				
						<tr class="regular">
					     <td  style="padding-left:20px"><cfinclude template="RateEditRate.cfm"></td>
					</tr>		
					</table>
					
					</cf_divscroll>	
										
				<cfelse>
					 				
					<cfquery name="Component"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   	SELECT   S.*, R.Description
						FROM     SalaryScaleComponent S INNER JOIN Ref_PayrollComponent R ON S.ComponentName = R.Code
						WHERE    S.Period != 'Percent' 
						AND      S.RateStep NOT IN ('9','8')
						AND      S.ScaleNo = '#Scale.ScaleNo#'
						ORDER BY S.ListingOrder 
				    </cfquery>
														
					<table style="height:100%;width:100%">	
																					
						<tr id="rate" name="rate" class="regular">
							<td align="left" style="padding-left:20px;height:100%;">																									
							<cfinclude template="RateEditComponent.cfm">																				
							</td>
						</tr>	
																	
					</table>					
					
				</cfif>	
						
			</td></tr>
			
			<cfoutput>
			<tr><td colspan="6" height="40" style="padding-left:4px;border-top:1px solid silver">
			
			    <table class="formspacing">
				<tr>
				
				<cfif getAdministrator("*") eq "1">
				
					<td id="refresh">		
					   <input name    = "Refresh" 
					          value   = "Reinitialize Scale Components" 
							  onclick = "_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/payroll/maintenance/SalarySchedule/setScaleComponent.cfm?scaleno=#scale.scaleno#&mode=#url.mode#','refresh')" 
							  type    = "button" 
							  style   = "height:25;width:220px" 
							  class   = "Button10g"/>							  
				    </td>
					
				</cfif>
				<td>
				  <input name="add" onclick="#jvlink#" value="Add New Scale" type="button" style="height:25px;width:120px" class="Button10g"/>
			    </td>
				<td>
				  <input name="Submit" value="Save" type="button" onclick="savescale()" style="height:25;width:120px" class="Button10g"/>
				</td>
								
				<td align="right" style="padding-left:4px">
				
					<a href="javascript:ColdFusion.navigate('SalarySchedulePrint.cfm?mission=#url.mission#&scaleno=#scale.scaleno#','cprint','','','POST','')">				
						<img src="#SESSION.root#/images/print.png" height="25" width="25" align="absmiddle" alt="" border="0">
					</a>
					
				</td>
				
				</tr>
				</table>
				
			</tr>
			</cfoutput>
						
			</table>
			
		</cfform>
		
	</td>
	</tr>
	
	</cfif>

</table>

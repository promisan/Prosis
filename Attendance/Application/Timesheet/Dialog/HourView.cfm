<cfparam name="url.id"         default="">
<cfparam name="datetime"       default="#Now()#">
<cfparam name="url.day"        default="#dateformat(datetime,"d")#">
<cfparam name="url.startmonth" default="#dateformat(datetime,"mm")#">
<cfparam name="url.startyear"  default="#Year(datetime)#">
<cfparam name="URL.edit" 	   default="0">

<cfset dateob=CreateDate(URL.startyear,URL.startmonth,1)>
<cfset thedate  = Createdate(URL.startyear, URL.startmonth, url.day)>
<cfset url.date = dateformat(thedate,CLIENT.DateFormatShow)>

<cfquery name="getOrganizationAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	OrganizationAction
	WHERE 	OrgUnit IN (
				SELECT 	PAx.OrgUnit 
				FROM 	Employee.dbo.PersonAssignment PAx 
						INNER JOIN Employee.dbo.Position POx 
							ON PAx.PositionNo = POx.PositionNo 
				WHERE 	PAx.AssignmentStatus IN ('0','1')
				AND 	#thedate# BETWEEN PAx.DateEffective AND PAx.DateExpiration
				AND		PAx.PersonNo = '#URL.id#'
			)
	AND     #thedate# BETWEEN CalendarDateStart AND CalendarDateEnd
    AND     WorkAction = 'Attendance'	
</cfquery>

<cfif getOrganizationAction.recordCount eq "0" OR getOrganizationAction.actionStatus eq "0">
	<cfset url.edit = "1">
</cfif>

<cfif url.id eq "">

	<table width="100%" height="100%">
	<tr><td class="labelmedium" align="center">An error has occurred</td></tr></table>
	<cfabort>

</cfif>

<cf_presentationscript>
<cfajaximport tags="cfform,cfdiv">

<cfoutput>

<script>
	   
	function selectact(act,cls,row) {
		   
	   document.getElementById("actioncode").value = act
	  	   
	   count = 0
	   tot   = 99  
	  		 	   
	   while (count <= tot)  {
			   
			   try { 
				   rw = document.getElementById("r"+cls+"_"+count)
				   rw.className = "regular"
			   	   } catch(e) {}
				   count++ 
				   
		   }		   
		   rw = document.getElementById("r"+cls+"_"+row)
		   rw.className = "highlight2"  	
		   ptoken.navigate('getActivitySelect.cfm?id=#url.id#&class='+cls+'&activityid='+act+'&date=#url.date#','process')   	   
	   }
	      
	function selectall(vid) {
	
		d = document.getElementsByTagName('input');
		j=0;
		var cl = new Array()
		
		for(i=0;i<d.length;i++) {
			tid = d[i].getAttribute("name"); 
			if (tid) {
			    if (tid.indexOf(vid)!=-1) {
					  element=document.getElementById(tid);
			  	  	  element.checked = true;		
				}		
			}				
		}  
	}
	      
	function removeall(vid) {
		d = document.getElementsByTagName('input');
		j=0;
		var cl = new Array()
		for(i=0;i<d.length;i++) {
			tid = d[i].getAttribute("name"); 
			if (tid) {
			    if (tid.indexOf(vid)!=-1) {
					  element=document.getElementById(tid);
			  	  	  element.checked = false;	
				}
			}					
		}  	
	
	}

	function details(cde,act,row) {

	   $('.activitydetail').css({'display':'none'});
	  
	   if (act == 1) {
		   url = "HourEntryFormActivitySelect.cfm?id=#URL.id#&date=#url.date#&hour=#URL.hour#&ActionClass="+cde
		   _cf_loadingtexthtml='';	
		   ColdFusion.navigate(url,'details_'+cde)				 
		   document.getElementById('detail_'+cde).style.display = 'block'		    
		  } 
	   // selected actionclass
   	   document.getElementById("action").value     = cde	
	   document.getElementById("actioncode").value = '0'
	
	}	
	
	function entryhour(pers,x,mth,yr,hr,slot,context) {			   					
		ptoken.open("HourView.cfm?context="+context+"&id="+pers+"&day="+x+"&startmonth="+mth+"&startyear="+yr+"&hour="+hr+"&slot="+slot,"dataentry")				 
		
	}  
	 	
	function setcolor() {
	     _cf_loadingtexthtml='';	
	     ColdFusion.navigate('setHourColor.cfm','process','','','POST','sheet')	
	}
		 
	function save(act) {
				
		cl  = document.getElementById("action").value
		lo  = document.getElementById("locationcode").value		
		me  = document.getElementById("memo").value
		cde = document.getElementById("actioncode").value

			
		if (cl == "") {
		
		   alert("There is no activity class selected.")
		   
		} else {  	

		   ColdFusion.navigate('HourEntrySubmit.cfm?context=#url.context#&act='+act+'&id=#url.id#&date=#url.date#&cls='+cl+'&cde='+cde+'&loc='+lo+'&mem='+me+'&parenthour=#url.hour#','entrydialog','','','POST','sheet');

		   if (act != 'refresh') {
		   	try {parent.document.getElementById('modalbg').style.display = 'none';} catch (e){}			
			}			
		}
	
	}
	
</script>

</cfoutput>

<cfset option = "Timesheet for #dayOfWeekAsString(dayOfWeek(date))#, #dateformat(thedate,'MMMM DD YYYY')#">

<cf_screentop height="100%" jquery="yes"  html="No" layout="webapp" banner="gray" bannerheight="50" label="#option#" title="Timesheet for #dayOfWeekAsString(dayOfWeek(date))# #dateformat(thedate,CLIENT.DateFormatShow)#" scroll="Yes">
				
<cfoutput>

<form name="sheet" id="sheet" style="height:98%;width:100%">
		
	<table width="100%" height="100%" border="0">
	
	<tr class="line">
		
		<td valign="top">
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">				
			    <tr><td width="90%" align="center" valign="top" id="entrydialog">						    
					<cfinclude template="HourEntryForm.cfm"> 
					</td>											
				</tr> 
			</table>	 
			
		</td>
		
	</tr>
	
	<tr class="line"><td colspan="2">
	
	<table width="95%" align="center" class="formpadding">			
	
	<tr class="labelmedium"><td style="width:14%" ><cf_tl id="Modality"></td>
	    <td>
		
		<cfquery name="Modality" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Ref_PayrollTrigger
				WHERE     TriggerGroup = 'Overtime'
				and       Description NOT LIKE '%Differential%'
		</cfquery>		
						 
		 	<select name="BillingMode" class="regularxl">
				<option value="Contract"><cf_tl id="Contract"></option>
				<cfloop query="modality">
				<option value="#SalaryTrigger#" <cfif last.BillingMode eq salarytrigger>selected</cfif>>#Description#</option>
				</cfloop>
			</select>		
			
		</td>
	</tr>
	
	<tr valign="top" style="padding-top:3px" class="labelmedium"><td><cf_tl id="Memo">		 
		<td>
		  <textarea style="background-color:ffffbf;width:99%;height:60;font-size:15px;padding:4px" 
		    onkeyup="return ismaxlength(this)" 
		    totlength="200" class="regular" name="memo" id="memo"><cfoutput>#Last.ActionMemo#</cfoutput></textarea>			
		</td>
	</tr>
	
	</table>
	</td>
	</tr>
	
	<tr><td align="center" colspan="2" style="padding-top:4px">
	
			<!--- save entry, saves selection and refreshed the schedule : ajax --->
									  
			<cfif url.hour eq "">
			
			  <input type="button"
		      	name="close"
              	id="close"
		      	value="Close"
			  	style="width:140"
		      	class="button10g"
		      	onClick="parent.document.getElementById('timebox').style.display = 'none'; parent.document.getElementById('modalbg').style.display = 'none';">	
				
				<cfif url.edit eq "1">
				  <input type="button"
			      	name="submit"
	              	id="submit"
			     	value="Save"
				 	style="width:140"
			      	class="button10g"
			     	onClick="save('refresh')">		
				</cfif>
			  				  
			  
			<cfelse>										
			  
			  <input type="button"
		      	name="close"
              	id="close"
		      	value="Close"
			  	style="width:140"
		      	class="button10g"
		      	onClick="parent.document.getElementById('timebox').style.display = 'none'; try {parent.document.getElementById('modalbg').style.display = 'none';} catch (e){}">	
				
				<cfif url.edit eq "1">
				  <input type="button"
			      	name="submit"
	              	id="submit"
			     	value="Save"
				 	style="width:140"
			      	class="button10g"
			     	onClick="save('exit')">		
				</cfif>
			
			</cfif>  
		  
					  
		</td>
	</tr>	
			
	</table>
	
</form>	
		
</cfoutput>		
		
<cf_screenbottom layout="webapp">

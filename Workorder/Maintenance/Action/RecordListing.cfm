
<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<cfparam name="alias" default="AppsWorkOrder">	
<cfajaximport tags="cfdiv,cfform,cfinput-autosuggest">
<cf_calendarscript>

	<cfoutput>
	
	<script language="JavaScript">
	
	function recordadd (id) {
		addrecord(id);
	}
	
	function addrecord(id) {     
	    ptoken.open("RecordEdit.cfm?alias=#alias#&idmenu=#url.idmenu#&ID=" + id, "EditAction", "left=80, top=80, width=700, height=550, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function option(sel) {
	  
	   if (sel != 'Text') {
	     document.getElementById("ValueLength").className="hide"
	   } else {
	     document.getElementById("ValueLength").className="regularH"
	   }
	   if (sel != 'Lookup') {
	      lookup.className='hide'
		} else {
		  lookup.className='regular'
		}
		if (sel != 'List') {
		 try {
		  document.getElementById("list1").className = "hide"
		  document.getElementById("list2").className = "hide"	
		 } catch(e) {}
		} else {
		 try {	 	     
			 document.getElementById("list1").className = "regular"
		     document.getElementById("list2").className = "regular"	
			} catch(e) {}
		}
	}
	
	function showme(box,code,mis) {
		
		se = document.getElementById(box)
		if (se.className == "hide") {		
			se.className  = "regular" 
			ptoken.navigate('ActionServiceItem.cfm?mission='+mis+'&alias=#alias#&code='+code,'content_'+box)
		} else {		
			se.className  = "hide"			
		}
	}
	
	function selectitem(action,code,control){
		if (control.checked){
		
			document.getElementById('td_'+action+'_'+code).style.backgroundColor = 'E1EDFF';
			try { document.getElementById('notification_'+action+'_'+code).style.display = 'inline'; } catch(e) {}
			try { document.getElementById('detail_'+action+'_'+code).style.display = 'inline'; } catch(e) {}		
		}
		else{
			document.getElementById('td_'+action+'_'+code).style.backgroundColor = '';
			try { document.getElementById('notification_'+action+'_'+code).style.display = 'none'; } catch(e) {}
			try { document.getElementById('detail_'+action+'_'+code).style.display = 'none'; } catch(e) {}
		}
	}
	
	function saveitem(code) {
	   ptoken.navigate('ActionServiceItemSubmit.cfm?code='+code,'process','','','POST','form'+code)
	}
	 
	function addNotification (caction,cservice){
		ptoken.open('ActionNotificationListing.cfm?scode='+cservice+'&acode='+caction, "Add Notification", "left=80, top=80, width=700, height=500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	</script>
	
</cfoutput>

<table width="94%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Order Action">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<tr><td>

<cf_divscroll>
		
<table width="100%" align="center">

	<tr><td style="height:4px"></td></tr>
	
    <tr class="hide"><td height="4" id="process"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		   <cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	

</cf_divscroll>

</td>
</tr>
</table>
				


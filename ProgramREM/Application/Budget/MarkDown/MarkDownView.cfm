
<cf_screentop height="100%" 
   label="Budget Adjustment"    
   scroll="no" banner="gray" line="no" jquery="Yes"
   html="Yes" layout="webapp">

<cfajaximport tags="cfdiv,cfform">
<cf_calendarscript>

<script>

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
		
	 itm.className = "labelit highLight2";
	 }else{		
     itm.className = "labelit regular";		
	 }
 }
 
 function ajaxsel(fld,val,st) {
         
   prior = document.getElementById(fld).value
     
   if (st == true) {   
    ptoken.navigate('ProgramAjax.cfm?field='+fld+'&prior='+prior+'&val='+val+'&action=add','box'+fld)
   } else {
    ptoken.navigate('ProgramAjax.cfm?field='+fld+'&prior='+prior+'&val='+val+'&action=del','box'+fld)
   }
   
 }
 
 function showwhatif() { 
 	ColdFusion.Layout.enableTab('selection','whatiftab')  
 } 
  
 function applymarkdown(id,val,opt,amt,per) {
   _cf_loadingtexthtml='';
   ptoken.navigate('doRevised.cfm?actionid='+id,'whatifresult','','','POST','markdown') 
 }
 
 
</script>

<cfoutput>

<cfparam name="url.period" default="B08-09">
<cfparam name="url.editionid" default="26">

<cfquery name="Check" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  SELECT * 
       FROM  ProgramAllotmentRequest 
	   WHERE Period        = '#url.period#'
	   AND   ActionStatus != '9'
	   AND   EditionId     = '#url.editionid#'						 		 
</cfquery>

 <cfif check.recordcount eq "0">
 
 	 <table cellspacing="0" cellpadding="0" align="center" class="formpadding">
		 <tr>
			 <td align="center" height="20" class="labelit" class="labelmedium">
			 <font color="808080">There are no items to show in this view.</td>
		 </tr>
	 </table>	 
	 
	 <cfabort>		
	 
 </cfif>

<table width="100%" align="center"cellspacing="0" cellpadding="0">
	
	<tr><td height="14" colspan="2" class="labelmedium" style="padding-top:5px;font-weight:200;padding-left:15px"><font color="808080">Select Programs/Projects and Object of expenditures for which to adjust the requirements</td></tr>

	
	<tr class="hide"><td id="boxprogram">
		  <input type="text" id="program" name="program">	
		</td>
		<td id="boxobject">
		  <input type="text" id="object" name="object">	
		</td>
		
	</tr>
			
	<tr><td colspan="2" style="padding:10px">
	
			<table width="100%" cellspacing="0" cellpadding="0" align="center">
				
			<tr><td align="center">
							
			<cfset attrib = {type="Tab",name="selection",tabstrip="false",width="952",overflow="hidden",height="777"}>	

			<cflayout attributeCollection="#attrib#">	
									
				<cflayoutarea
				   name="programtab" 
				   title="Select Programs" 
				   overflow="auto">
				   
				   <table width="100%"><tr><td style="padding:15px">
				   
				   <cfinclude template="MarkDownProgram.cfm">		
				   
				   </td></tr></table> 
				
				</cflayoutarea>
			
				<cflayoutarea  
				   name="objecttab" 
				   source="MarkDownObject.cfm?period=#url.period#&editionid=#url.editionid#&programselect={program}&objectselect={object}"
				   title="Select Object of Expenditures" 
				   refreshonactivate="true"
				   overflow="auto"/>
						
				 <cflayoutarea 
		          name="whatiftab"
		          source="MarkDownWHATIF.cfm?period=#url.period#&editionid=#url.editionid#&programselect={program}&objectselect={object}"
		          title="WHAT IF scenarios"
		          overflow="auto"
		          disabled="true"
		          refreshonactivate="true"/>
			
			</cflayout>
			
			</td></tr>
			
			</table>

	</td></tr>
	
</table>

</cfoutput>

<cf_screenbottom layout="webapp">



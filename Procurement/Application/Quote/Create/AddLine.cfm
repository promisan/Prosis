
<cf_tl id="Shipping and Handling" var="vShipping">

<cf_screentop height="100%" 
   scroll="Yes" jquery="Yes" layout="webapp" html="no" line="no" banner="blue" user="No" label="#vShipping#" option="<br>Add lines to cover shipping and handling">

<cfset URL.Job = "#URL.ID#">

<cfquery name="Job" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Job 
	WHERE  JobNo       = '#URL.Job#' 
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Ref_ParameterMission
	WHERE Mission = '#Job.Mission#' 
</cfquery>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLine L, 
	       Organization.dbo.Organization O
	WHERE  JobNo       = '#URL.Job#' 
	  AND  RequestType = 'Purchase'
	  AND  L.OrgUnit   = O.OrgUnit 
	  AND  L.RequestQuantity <> '0'
</cfquery>		

<cfset url.mission = job.mission>

<cfif Line.recordcount eq "0">

	<cfinclude template="../../Requisition/Requisition/RequisitionEntryRecord.cfm">
	
<cfelse>
    
    <cfset url.id = line.requisitionNo>	
	
</cfif>

<cf_dialogOrganization>

<cfajaximport tags="cfdiv">

<cfoutput>

<script>

function fd(per) {
 
	   w    = #CLIENT.width# - 100;
	   h    = #CLIENT.height# - 150;
	   obj  = document.getElementById("objectselect")	   
	   mas  = document.getElementById("itemmaster").value	
	   unit = document.getElementById("orgunit1").value   
	        
	   if (unit != "") {
	   	ptoken.open("#SESSION.root#/Procurement/Application/Requisition/Funding/RequisitionEntryFundingSelect.cfm?Mission=#URL.Mission#&ID=#URL.ID#&ItemMaster="+mas+"&Object="+obj+"&Period=#job.period#&Org=" + unit, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=no")	
		// funding()
	   }  else  { alert("You must identify a requesting unit.") }	  
}

function calcul(ln) {
    
	    x = document.getElementById('requestquantity_'+ln)		
		y = document.getElementById('requestcostprice_'+ln)	
		var s = " " + Math.round((x.value*y.value) * 100) / 100
		value(s,'requestamountbase_'+ln)	
		
}

function value(s,field) {
	
	z = document.getElementById(field)
	
	var i = s.indexOf('.')
	   if (i < 0) {
	     z.value = s + ".00" ;
	   } else {
	    var t = s.substring(0, i + 1) + s.substring(i + 1, i + 3);
	    if (i + 2 == s.length) 
		   t += "0";
	       z.value = t; 
		}
}

function selectmas(flditemmaster,mis,per,reqno) {
         
		try { ColdFusion.Window.destroy('mymaster',true) } catch(e) {}
		ColdFusion.Window.create('mymaster', 'Procurement Master', '',{x:100,y:100,height:document.body.clientHeight-40,width:document.body.clientWidth-40,modal:false,resizable:false,center:true})    					
		ColdFusion.navigate('#SESSION.root#/Procurement/Application/Requisition/Item/ItemSearchView.cfm?id='+reqno+'&mission='+mis+'&period='+per+'&flditemmaster= ' + flditemmaster, 'mymaster');	       			
}

function selectmasapply(val) {       
        ColdFusion.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/setItemMaster.cfm?itemmaster='+val,'process')		
}

function funding(clr,fundingid,act,fd,obj,pg,perc,pgper) {						
		ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryFunding.cfm?enforcefund=1&archive=0&clear='+clr+'&mission=#URL.Mission#&access=edit&per=#job.period#&id=#URL.ID#&object='+obj+'&fundingid='+fundingid+'&action='+act+'&fund='+fd+'&objectcode='+obj+'&programcode='+pg+'&percentage='+perc+'&period='+pgper,'fundbox')						
}

</script>

</cfoutput>

<cfquery name="Master" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ItemMaster 
	WHERE  Code  = '#Line.ItemMaster#' 
</cfquery>		

<cfquery name="UoM" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_UoM
</cfquery>

<table align="center" width="100%">

<tr><td height="4"></td></tr>

<tr><td>
	<table width="98%" cellspacing="0" cellpadding="0" align="center">
	<tr><td class="labelmedium">
	This option allows you to record additional lines for the purchase order to reflect mostly shipping and handling costs if these needs to be
	reflected separately. The lines are funded in addition to the recorded lines and are funded through the budget of the requesting units. However funding validation is bypassed. As such 
	this function should be used with care by the buyer.
	</td></tr>
	</table>
</td></tr>

<tr class="hide"><td height="2" id="process"></td></tr>
<tr><td align="center">

<cfform action="AddLineSubmit.cfm?Job=#URL.Job#&ID=#URL.ID#" 
        method="post" 
		name="processaction" target="result">	
				
<table style="width:98%" align="center" class="formspacing formpadding">

<tr class="hide"><td  colspan="6"><iframe name="result" id="result" width="100%" height="60"></iframe></td></tr>		

<tr><td colspan="6">

	<table style="width:100%" class="formpadding">
	
	<TR height="22" class="labelmedium">
	    <TD width="150">
			<cf_tl id="Requesting Unit">:
		</TD>
		
		<TD>	
		
		<cfoutput>	
		<table>
			<tr>
				<td>				
			
			  <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
				  onMouseOver="document.img0.src='#SESSION.root#/Images/Minus.png'" 
				  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'" class="enterastab"
				  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
				  onClick="selectorgroleN('#url.mission#','','#job.period#','ProcReqEntry','orgunit','applyorgunit','1','modal','disable')">
				
				 </td>
				  <td style="padding-left:2px">			
				  
				 <input type="text" name="orgunitname1" id="orgunitname1" class="regularxl enterastab" value="#Line.orgunitName#" size="50" maxlength="80" readonly>					  
				 <input type="hidden" name="mission1" id="mission1"     value="#Line.Mission#"> 
				 <input type="hidden" name="orgunitcode1" id="orgunitcode1"  value="#Line.orgunitcode#">
			   	 <input type="hidden" name="orgunitclass1" id="orgunitclass1" value="#Line.orgunitclass#"> 
			 	 <input type="hidden" name="orgunit1" id="orgunit1"      value="#Line.orgunit#">
				 <input type="hidden" name="period" id="period"       value="#Job.Period#">
				 
				 </td>
				 </tr>
				 </table>
			
		</cfoutput>
		
		</TD>
		</TR>	
				
		<TR height="22" class="labelmedium">
	    <TD>
			<cf_tl id="Request Class">:
		</TD>
	    
		<TD>
				
			<cfoutput>
			<table>
			<tr>
				<td>
				
			 <img src="#SESSION.root#/Images/search.png" 
			      alt="Select item master" 
				  name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" 
				  width="25" 
				  height="25" 
				  border="0" 
				  align="absmiddle" 
				  onClick="selectmas('itemmaster','#url.mission#','#Job.Period#','#url.id#')">
				  
				  </td>
				  <td style="padding-left:2px">						  
				  <input type="text" name="itemmaster" id="itemmaster" value="#Master.Code#" size="5" maxlength="6" class="regularxl enterastab" readonly style="text-align: center;"> 
				  </td>
				  <td>
				  <input type="text" name="itemmasterdescription" id="itemmasterdescription" value="#Master.Description#" size="55" class="regularxl enterastab" maxlength="80" readonly> 
				  </td>
			</tr> 
			</table>	 
			</cfoutput>
		
		</TD>
		</TR>
		
	</table>
</td>
</tr>
	
<tr class="labelmedium">
   <td width="20"></td>
   <td><cf_tl id="Description"></td>
   <td><cf_tl id="Qty"></td>
   <td><cf_tl id="Uom"></td>
   <td><cf_tl id="Price"> <cfoutput>#APPLICATION.BaseCurrency#</cfoutput></td>
   <td><cf_tl id="Total"> <cfoutput>#APPLICATION.BaseCurrency#</cfoutput></td>
</tr>

<cfoutput query="Line">
	
	<input type="hidden" name="RequisitionNo_#CurrentRow#" id="RequisitionNo_#CurrentRow#" value="#RequisitionNo#">
	
	<tr class="labelmedium">
	
	   <td align="center" class="labelit" style="padding-right:4px">#currentRow#.</td>
	   <td>	<input type="text" style="width:95%" class="enterastab regularxl" value="#RequestDescription#" name="requestdescription_#currentRow#" id="requestdescription_#currentRow#" size="40" maxlength="80"></td>
	   <td><cfinput type="Text" 
	       name="requestquantity_#currentrow#" 
		   value="#RequestQuantity#" 
		   message="Enter a valid quantity" 
		   validate="float" 
		   required="No" 
		   size="4" 
		   class="enterastab regularxl"
		   style="text-align: right;" 
		   onChange="calcul('#currentrow#')">
	   </td>
	   <td><select name="requestuom_#currentRow#" style="min-width:90px" id="requestuom_#currentRow#" size="1" class="enterastab regularxl">
		    <cfloop query="UoM">
				<option value="#Code#" <cfif Line.QuantityUoM eq "#Code#">selected</cfif>>#Description#</option>
			</cfloop>
		    </select></td>
	   <td>
	     <cfinput type="Text" class="enterastab regularxl" name="requestcostprice_#currentrow#" value="#NumberFormat(RequestCostPrice,",.__")#" message="Enter a valid price" validate="float" required="No" size="10" style="text-align: right;" 
		  onChange="calcul('#currentrow#')">
	   </td>
	   <td>
	     <input type="text" class="enterastab regularxl" name="requestamountbase_#currentRow#" id="requestamountbase_#currentRow#" size="10" value="#NumberFormat(RequestAmountBase,'_,_.__')#" maxlength="10" readonly style="text-align: right;">
	   </td>
	</tr>

</cfoutput>

<cfoutput>

<cfloop index="ln" from="#1+Line.recordcount#" to="10">
<input type="hidden" name="RequisitionNo_#ln#" id="RequisitionNo_#ln#" value="">
	
	<tr>
	   <td align="center" class="labelit" style="padding-right:4px">#ln#
	   <td>
	   	<input type="text" style="width:95%" class="regularxl enterastab" name="requestdescription_#ln#" id="requestdescription_#ln#" size="40" maxlength="80">
	   </td>
	   <td>
	     <cfinput type="Text" class="regularxl enterastab" name="requestquantity_#ln#" value="" message="Enter a valid quantity" validate="float" required="No" size="4" style="text-align: right;" onChange="calcul('#ln#')">
	   </td>
	   <td>
		   <select name="requestuom_#ln#" style="width:90px" class="enterastab regularxl" id="requestuom_#ln#" size="1">
		    <cfloop query="UoM">
				<option value="#Code#">#Description#</option>
			</cfloop>
		    </select>
	   </td>
	   <td>
	     <cfinput type="Text" class="enterastab regularxl" name="requestcostprice_#ln#" value="" message="Enter a valid price" validate="float" required="No" size="10" style="text-align: right;" onChange="calcul('#ln#')">
	   </td>
	   <td>
	      <input type="text" class="enterastab regularxl" name="requestamountbase_#ln#" id="requestamountbase_#ln#" size="10" maxlength="12" readonly style="text-align: right;">
	   </td>
	   
	</tr>	
		
</cfloop>

</cfoutput>
	
	<TR>
        <td class="labelmedium" id="fundingrefresh" onclick="funding()"></td>
		
		<TD height="25" colspan="5" id="fundbox">
		
		<script>
			funding()
		</script>		
										
	    </TD>
       
	</TR>	
		
	<tr><td height="2" colspan="6"></td></tr>
	<tr><td height="1" colspan="6" class="line"></td></tr>
	<tr><td height="2" colspan="6"></td></tr>

	<cf_tl id="Reset" var="1">
	<cfset vReset=#lt_text#>
		
	<cf_tl id="Close" var="1">
	<cfset vClose=#lt_text#>

	<cf_tl id="Submit" var="1">
	<cfset vSubmit=#lt_text#>

	<cfoutput>
	<tr><td height="1" colspan="6" align="center">
	<input type="hidden"  name="row"    id="row"    value="10">
	<input type="reset"   name="Reset"  id="Reset"  value=" #vReset# "  class="button10g" >
	<input type="button"  name="Close"  id="Close"  value=" #vClose# "  class="button10g" onClick="parent.ProsisUI.closeWindow('myshipping',true)">
	<input type="submit"  name="Submit" id="Submit" value=" #vSubmit# " class="button10g">
	</td></tr>
	</cfoutput>	
		
	<tr><td height="1" colspan="6"></td></tr>
	
</table>

</cfform>

</td></tr>

</table>

<cf_screenbottom layout="webapp">
